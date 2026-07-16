import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../../../core/utils/logger.dart';
import '../domain/models/bili_login_cookies.dart';

typedef BrowserProcessRunner =
    Future<ProcessResult> Function(String executable, List<String> arguments);

typedef BrowserProcessStarter =
    Future<Process> Function(String executable, List<String> arguments);

typedef BrowserProfileDirectoryFactory = Future<Directory> Function();

typedef BrowserWebSocketConnector = Future<WebSocket> Function(String url);

enum LinuxManagedBrowserKind { chromium, firefox }

class LinuxManagedBrowserCandidate {
  const LinuxManagedBrowserCandidate({
    required this.executable,
    required this.kind,
    required this.displayName,
    this.minimumMajorVersion,
  });

  final String executable;
  final LinuxManagedBrowserKind kind;
  final String displayName;
  final int? minimumMajorVersion;

  bool supportsVersion(String versionOutput) {
    final minimum = minimumMajorVersion;
    if (minimum == null) return true;

    final major = LinuxBrowserVersionParser.extractMajorVersion(versionOutput);
    return major != null && major >= minimum;
  }
}

abstract class LinuxManagedBrowserLoginService {
  Future<bool> isAvailable();

  Future<LinuxManagedBrowserLoginSession> startLogin();
}

abstract class LinuxManagedBrowserLoginSession {
  Future<BiliLoginCookies?> readBiliCookies();

  Future<void> close();
}

class LinuxManagedBrowserLoginException implements Exception {
  const LinuxManagedBrowserLoginException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ProcessLinuxManagedBrowserLoginService
    implements LinuxManagedBrowserLoginService {
  ProcessLinuxManagedBrowserLoginService({
    List<LinuxManagedBrowserCandidate>? candidates,
    BrowserProcessRunner? runProcess,
    BrowserProcessStarter? startProcess,
    BrowserProfileDirectoryFactory? createProfileDirectory,
    ChromeDevToolsClient? devToolsClient,
    FirefoxBiDiClient? firefoxBiDiClient,
  }) : _candidates = candidates ?? _defaultCandidates,
       _runProcess = runProcess ?? _defaultRunProcess,
       _startProcess = startProcess ?? _defaultStartProcess,
       _createProfileDirectory =
           createProfileDirectory ??
           (() => Directory.systemTemp.createTemp('busic-web-login-')),
       _devToolsClient = devToolsClient ?? ChromeDevToolsClient(),
       _firefoxBiDiClient = firefoxBiDiClient ?? FirefoxBiDiClient();

  static const _defaultCandidates = [
    LinuxManagedBrowserCandidate(
      executable: 'google-chrome',
      kind: LinuxManagedBrowserKind.chromium,
      displayName: 'Google Chrome',
    ),
    LinuxManagedBrowserCandidate(
      executable: 'google-chrome-stable',
      kind: LinuxManagedBrowserKind.chromium,
      displayName: 'Google Chrome',
    ),
    LinuxManagedBrowserCandidate(
      executable: 'chromium',
      kind: LinuxManagedBrowserKind.chromium,
      displayName: 'Chromium',
    ),
    LinuxManagedBrowserCandidate(
      executable: 'chromium-browser',
      kind: LinuxManagedBrowserKind.chromium,
      displayName: 'Chromium',
    ),
    LinuxManagedBrowserCandidate(
      executable: 'microsoft-edge',
      kind: LinuxManagedBrowserKind.chromium,
      displayName: 'Microsoft Edge',
    ),
    LinuxManagedBrowserCandidate(
      executable: 'microsoft-edge-stable',
      kind: LinuxManagedBrowserKind.chromium,
      displayName: 'Microsoft Edge',
    ),
    LinuxManagedBrowserCandidate(
      executable: 'brave-browser',
      kind: LinuxManagedBrowserKind.chromium,
      displayName: 'Brave',
    ),
    LinuxManagedBrowserCandidate(
      executable: 'vivaldi',
      kind: LinuxManagedBrowserKind.chromium,
      displayName: 'Vivaldi',
    ),
    LinuxManagedBrowserCandidate(
      executable: 'firefox',
      kind: LinuxManagedBrowserKind.firefox,
      displayName: 'Firefox',
      minimumMajorVersion: 124,
    ),
    LinuxManagedBrowserCandidate(
      executable: 'firefox-esr',
      kind: LinuxManagedBrowserKind.firefox,
      displayName: 'Firefox ESR',
      minimumMajorVersion: 124,
    ),
    LinuxManagedBrowserCandidate(
      executable: 'firefox-developer-edition',
      kind: LinuxManagedBrowserKind.firefox,
      displayName: 'Firefox Developer Edition',
      minimumMajorVersion: 124,
    ),
    LinuxManagedBrowserCandidate(
      executable: 'firefox-nightly',
      kind: LinuxManagedBrowserKind.firefox,
      displayName: 'Firefox Nightly',
      minimumMajorVersion: 124,
    ),
  ];

  static final _loginUrl = Uri.parse('https://passport.bilibili.com/login');
  static const _browserProbeTimeout = Duration(seconds: 2);
  static const _devToolsStartupTimeout = Duration(seconds: 10);

  final List<LinuxManagedBrowserCandidate> _candidates;
  final BrowserProcessRunner _runProcess;
  final BrowserProcessStarter _startProcess;
  final BrowserProfileDirectoryFactory _createProfileDirectory;
  final ChromeDevToolsClient _devToolsClient;
  final FirefoxBiDiClient _firefoxBiDiClient;

  static Future<ProcessResult> _defaultRunProcess(
    String executable,
    List<String> arguments,
  ) {
    return Process.run(executable, arguments);
  }

  static Future<Process> _defaultStartProcess(
    String executable,
    List<String> arguments,
  ) {
    return Process.start(executable, arguments);
  }

  @override
  Future<bool> isAvailable() async {
    return await findSupportedCandidate() != null;
  }

  @override
  Future<LinuxManagedBrowserLoginSession> startLogin() async {
    final candidate = await findSupportedCandidate();
    if (candidate == null) {
      throw const LinuxManagedBrowserLoginException(
        'No supported Linux browser was found.',
      );
    }

    return switch (candidate.kind) {
      LinuxManagedBrowserKind.chromium => _startChromiumLogin(candidate),
      LinuxManagedBrowserKind.firefox => _startFirefoxLogin(candidate),
    };
  }

  Future<LinuxManagedBrowserCandidate?> findSupportedCandidate() async {
    for (final candidate in _candidates) {
      try {
        final result = await _runProcess(candidate.executable, [
          '--version',
        ]).timeout(_browserProbeTimeout);
        final versionOutput = '${result.stdout}\n${result.stderr}';
        if (result.exitCode == 0 && candidate.supportsVersion(versionOutput)) {
          return candidate;
        }
      } catch (_) {
        // Try the next browser candidate.
      }
    }
    return null;
  }

  Future<LinuxManagedBrowserLoginSession> _startChromiumLogin(
    LinuxManagedBrowserCandidate candidate,
  ) async {
    final profileDir = await _createProfileDirectory();
    Process? process;
    try {
      process = await _startProcess(candidate.executable, [
        '--user-data-dir=${profileDir.path}',
        '--remote-debugging-port=0',
        '--no-first-run',
        '--no-default-browser-check',
        '--disable-extensions',
        '--new-window',
        _loginUrl.toString(),
      ]);
      unawaited(process.stdout.drain<void>());
      unawaited(process.stderr.drain<void>());

      final browserWebSocketUri = await _waitForDevToolsEndpoint(profileDir);
      return ProcessLinuxManagedBrowserLoginSession(
        process: process,
        profileDir: profileDir,
        browserWebSocketUri: browserWebSocketUri,
        cookieClient: _devToolsClient,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to start Linux Chromium web login',
        tag: 'Auth',
        error: e,
        stackTrace: stackTrace,
      );
      process?.kill();
      await _deleteProfileDirectory(profileDir);
      rethrow;
    }
  }

  Future<LinuxManagedBrowserLoginSession> _startFirefoxLogin(
    LinuxManagedBrowserCandidate candidate,
  ) async {
    final profileDir = await _createProfileDirectory();
    Process? process;
    try {
      process = await _startProcess(candidate.executable, [
        '-profile',
        profileDir.path,
        '-new-instance',
        '-no-remote',
        '--remote-debugging-port=0',
        _loginUrl.toString(),
      ]);
      unawaited(process.stdout.drain<void>());

      final browserWebSocketUri = await _waitForFirefoxBiDiEndpoint(
        process.stderr,
      );
      return ProcessLinuxManagedBrowserLoginSession(
        process: process,
        profileDir: profileDir,
        browserWebSocketUri: browserWebSocketUri,
        cookieClient: _firefoxBiDiClient,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to start Linux Firefox web login',
        tag: 'Auth',
        error: e,
        stackTrace: stackTrace,
      );
      process?.kill();
      await _deleteProfileDirectory(profileDir);
      rethrow;
    }
  }

  Future<Uri> _waitForDevToolsEndpoint(Directory profileDir) async {
    final portFile = File(p.join(profileDir.path, 'DevToolsActivePort'));
    final startedAt = DateTime.now();

    while (DateTime.now().difference(startedAt) < _devToolsStartupTimeout) {
      if (await portFile.exists()) {
        final lines = await portFile.readAsLines();
        if (lines.length >= 2) {
          final port = int.tryParse(lines.first.trim());
          final browserPath = lines[1].trim();
          if (port != null && browserPath.isNotEmpty) {
            return Uri.parse('ws://127.0.0.1:$port$browserPath');
          }
        }
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }

    throw const LinuxManagedBrowserLoginException(
      'The managed browser did not expose a DevTools endpoint.',
    );
  }

  Future<Uri> _waitForFirefoxBiDiEndpoint(Stream<List<int>> stderr) {
    final completer = Completer<Uri>();
    Timer? timer;
    StreamSubscription<String>? subscription;

    void completeWithError() {
      if (!completer.isCompleted) {
        completer.completeError(
          const LinuxManagedBrowserLoginException(
            'The managed Firefox instance did not expose a BiDi endpoint.',
          ),
        );
      }
    }

    timer = Timer(_devToolsStartupTimeout, () {
      unawaited(subscription?.cancel());
      completeWithError();
    });

    subscription = stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (line) {
            final endpoint = FirefoxBiDiEndpointParser.extractEndpoint(line);
            if (endpoint != null && !completer.isCompleted) {
              timer?.cancel();
              completer.complete(endpoint);
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            timer?.cancel();
            if (!completer.isCompleted) {
              completer.completeError(error, stackTrace);
            }
          },
          onDone: () {
            timer?.cancel();
            completeWithError();
          },
        );

    return completer.future;
  }
}

class ProcessLinuxManagedBrowserLoginSession
    implements LinuxManagedBrowserLoginSession {
  ProcessLinuxManagedBrowserLoginSession({
    required Process process,
    required Directory profileDir,
    required Uri browserWebSocketUri,
    required BrowserCookieClient cookieClient,
  }) : _process = process,
       _profileDir = profileDir,
       _browserWebSocketUri = browserWebSocketUri,
       _cookieClient = cookieClient;

  static const _closeTimeout = Duration(seconds: 2);

  final Process _process;
  final Directory _profileDir;
  final Uri _browserWebSocketUri;
  final BrowserCookieClient _cookieClient;
  bool _closed = false;

  @override
  Future<BiliLoginCookies?> readBiliCookies() async {
    final cookies = await _cookieClient.getCookies(_browserWebSocketUri);
    final cookieMap = LinuxManagedBrowserCookieParser.extractBiliCookieMap(
      cookies,
    );
    return BiliLoginCookies.fromCookieMap(cookieMap);
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;

    try {
      _process.kill();
      await _process.exitCode.timeout(_closeTimeout, onTimeout: () => -1);
    } catch (e) {
      AppLogger.warning(
        'Failed to stop Linux managed browser cleanly: $e',
        tag: 'Auth',
      );
    }

    await _deleteProfileDirectory(_profileDir);
  }
}

abstract class BrowserCookieClient {
  Future<List<Map<String, dynamic>>> getCookies(Uri browserWebSocketUri);
}

class ChromeDevToolsClient implements BrowserCookieClient {
  ChromeDevToolsClient({BrowserWebSocketConnector? connectWebSocket})
    : _connectWebSocket = connectWebSocket ?? WebSocket.connect;

  static const _requestTimeout = Duration(seconds: 5);

  final BrowserWebSocketConnector _connectWebSocket;

  @override
  Future<List<Map<String, dynamic>>> getCookies(Uri browserWebSocketUri) async {
    final response = await _send(browserWebSocketUri, 'Storage.getCookies');
    return BrowserCookieResponseParser.extractCookies(
      response,
      protocolName: 'DevTools',
    );
  }

  Future<Map<String, dynamic>> _send(
    Uri browserWebSocketUri,
    String method,
  ) async {
    final socket = await _connectWebSocket(
      browserWebSocketUri.toString(),
    ).timeout(_requestTimeout);
    final connection = _JsonWebSocketCommandConnection(
      socket,
      requestTimeout: _requestTimeout,
    );
    try {
      return await connection.send(method);
    } finally {
      await connection.close();
      await socket.close();
    }
  }
}

class FirefoxBiDiClient implements BrowserCookieClient {
  FirefoxBiDiClient({BrowserWebSocketConnector? connectWebSocket})
    : _connectWebSocket = connectWebSocket ?? WebSocket.connect;

  static const _requestTimeout = Duration(seconds: 5);

  final BrowserWebSocketConnector _connectWebSocket;

  @override
  Future<List<Map<String, dynamic>>> getCookies(Uri browserWebSocketUri) async {
    final socket = await _connectWebSocket(
      browserWebSocketUri.toString(),
    ).timeout(_requestTimeout);
    final connection = _JsonWebSocketCommandConnection(
      socket,
      requestTimeout: _requestTimeout,
    );
    try {
      await connection.send(
        'session.new',
        params: {'capabilities': <String, dynamic>{}},
      );
      final response = await connection.send(
        'storage.getCookies',
        params: <String, dynamic>{},
      );
      return BrowserCookieResponseParser.extractCookies(
        response,
        protocolName: 'WebDriver BiDi',
      );
    } finally {
      await connection.close();
      await socket.close();
    }
  }
}

class _JsonWebSocketCommandConnection {
  _JsonWebSocketCommandConnection(
    WebSocket socket, {
    required Duration requestTimeout,
  }) : _socket = socket,
       _requestTimeout = requestTimeout {
    _subscription = _socket.listen(
      _handleMessage,
      onError: _completePendingWithError,
      onDone: () {
        _completePendingWithError(
          const LinuxManagedBrowserLoginException(
            'Browser WebSocket closed before a response was received.',
          ),
        );
      },
    );
  }

  final WebSocket _socket;
  final Duration _requestTimeout;
  final _pending = <int, Completer<Map<String, dynamic>>>{};
  late final StreamSubscription<dynamic> _subscription;
  int _nextId = 1;

  Future<Map<String, dynamic>> send(
    String method, {
    Map<String, dynamic>? params,
  }) {
    final id = _nextId++;
    final completer = Completer<Map<String, dynamic>>();
    _pending[id] = completer;
    _socket.add(
      jsonEncode({
        'id': id,
        'method': method,
        if (params != null) 'params': params,
      }),
    );
    return completer.future.timeout(_requestTimeout);
  }

  Future<void> close() {
    return _subscription.cancel();
  }

  void _handleMessage(dynamic message) {
    if (message is! String) return;

    final decoded = jsonDecode(message);
    if (decoded is! Map) return;

    final id = decoded['id'];
    if (id is! int) return;

    final completer = _pending.remove(id);
    if (completer == null || completer.isCompleted) return;

    if (decoded['error'] != null) {
      completer.completeError(
        LinuxManagedBrowserLoginException(
          'Browser protocol request failed: ${decoded['error']}',
        ),
      );
      return;
    }

    completer.complete(decoded.cast<String, dynamic>());
  }

  void _completePendingWithError(Object error, [StackTrace? stackTrace]) {
    for (final completer in _pending.values) {
      if (!completer.isCompleted) {
        completer.completeError(error, stackTrace);
      }
    }
    _pending.clear();
  }
}

class LinuxManagedBrowserCookieParser {
  LinuxManagedBrowserCookieParser._();

  static const _requiredCookieNames = {'SESSDATA', 'bili_jct', 'DedeUserID'};

  static Map<String, String> extractBiliCookieMap(
    List<Map<String, dynamic>> cookies,
  ) {
    final cookieMap = <String, String>{};
    for (final cookie in cookies) {
      final name = cookie['name'] as String?;
      final value = _cookieValueToString(cookie['value']);
      final domain = cookie['domain'] as String?;

      if (name == null ||
          value == null ||
          !_requiredCookieNames.contains(name) ||
          !_isBiliDomain(domain)) {
        continue;
      }

      cookieMap[name] = value;
    }
    return cookieMap;
  }

  static bool _isBiliDomain(String? domain) {
    final normalized = domain?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) return false;
    return normalized == 'bilibili.com' || normalized.endsWith('.bilibili.com');
  }

  static String? _cookieValueToString(Object? value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is! Map) return value.toString();

    final type = value['type'];
    final rawValue = value['value'];
    if (rawValue == null) return null;

    if (type == 'base64') {
      try {
        return utf8.decode(base64Decode(rawValue.toString()));
      } catch (_) {
        return null;
      }
    }

    return rawValue.toString();
  }
}

class LinuxBrowserVersionParser {
  LinuxBrowserVersionParser._();

  static int? extractMajorVersion(String output) {
    final match = RegExp(r'(\d+)(?:\.\d+)+').firstMatch(output);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }
}

class FirefoxBiDiEndpointParser {
  FirefoxBiDiEndpointParser._();

  static Uri? extractEndpoint(String output) {
    final match = RegExp(
      r'(ws://127\.0\.0\.1:\d+(?:/[^\s]+)?)',
    ).firstMatch(output);
    final rawEndpoint = match?.group(1);
    if (rawEndpoint == null) return null;

    final endpoint = Uri.tryParse(rawEndpoint);
    if (endpoint == null) return null;
    if (endpoint.path.isEmpty || endpoint.path == '/') {
      return endpoint.replace(path: '/session');
    }
    return endpoint;
  }
}

class BrowserCookieResponseParser {
  BrowserCookieResponseParser._();

  static List<Map<String, dynamic>> extractCookies(
    Map<String, dynamic> response, {
    required String protocolName,
  }) {
    final result = response['result'];
    if (result is! Map) {
      throw LinuxManagedBrowserLoginException(
        '$protocolName cookie response is missing result.',
      );
    }

    final cookies = result['cookies'];
    if (cookies is! List) {
      throw LinuxManagedBrowserLoginException(
        '$protocolName cookie response is missing cookies.',
      );
    }

    return [
      for (final cookie in cookies)
        if (cookie is Map) cookie.cast<String, dynamic>(),
    ];
  }
}

Future<void> _deleteProfileDirectory(Directory profileDir) async {
  try {
    if (await profileDir.exists()) {
      await profileDir.delete(recursive: true);
    }
  } catch (e) {
    AppLogger.warning(
      'Failed to delete Linux managed browser profile: $e',
      tag: 'Auth',
    );
  }
}
