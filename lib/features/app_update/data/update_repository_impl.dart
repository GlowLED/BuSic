import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:yaml/yaml.dart';

import '../../../core/utils/logger.dart';
import '../../../core/utils/platform_utils.dart';
import '../domain/models/app_version.dart';
import '../domain/models/download_channel.dart';
import '../domain/models/update_info.dart';
import '../domain/models/version_manifest.dart';
import 'lanzou_resolver.dart';
import 'proxy_prober.dart';
import 'update_repository.dart';

const _kTag = 'UpdateRepo';
const _kOwner = 'GlowLED';
const _kRepo = 'BuSic';

/// Map platform to release asset name.
String _platformAssetName() {
  if (PlatformUtils.isAndroid) return 'busic-android.apk';
  if (PlatformUtils.isWindows) return 'busic-windows-x64.zip';
  if (PlatformUtils.isLinux) return 'busic-linux-x64.tar.gz';
  if (PlatformUtils.isMacOS) return 'busic-macos.zip';
  return 'busic-unknown';
}

/// Current platform key used in manifest assets map.
String _platformKey() {
  if (PlatformUtils.isAndroid) return 'android';
  if (PlatformUtils.isWindows) return 'windows';
  if (PlatformUtils.isLinux) return 'linux';
  if (PlatformUtils.isMacOS) return 'macos';
  return 'unknown';
}

class UpdateRepositoryImpl implements UpdateRepository {
  final Dio _dio;
  final ProxyProber _prober;
  final LanzouResolver _lanzouResolver;

  UpdateRepositoryImpl({Dio? dio, ProxyProber? prober, LanzouResolver? lanzouResolver})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 30),
            )),
        _prober = prober ?? ProxyProber(),
        _lanzouResolver = lanzouResolver ?? LanzouResolver();

  // ── Manifest fetching (V2 primary) ───────────────────────────────

  /// Fetch versions-manifest.json by racing concurrent GET requests.
  Future<VersionManifest> _fetchManifestJson() async {
    AppLogger.info(
      'Fetching manifest JSON (racing ${kManifestUrls.length} sources) …',
      tag: _kTag,
    );

    final completer = Completer<VersionManifest>();
    var failCount = 0;
    final total = kManifestUrls.length;
    Object? lastError;

    for (final url in kManifestUrls) {
      () async {
        try {
          final response = await _dio.get<String>(
            url,
            options: Options(
              sendTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              followRedirects: true,
              validateStatus: (status) => status != null && status < 400,
            ),
          );
          final body = response.data;
          if (body == null || body.trim().isEmpty) {
            throw const FormatException('Manifest response is empty');
          }
          if (!completer.isCompleted) {
            AppLogger.info('Manifest JSON fetched from $url', tag: _kTag);
            final jsonData = json.decode(body) as Map<String, dynamic>;
            completer.complete(VersionManifest.fromJson(jsonData));
          }
        } catch (e) {
          AppLogger.warning(
            'Manifest JSON fetch failed for $url: $e',
            tag: _kTag,
          );
          lastError = e;
          failCount++;
          if (failCount >= total && !completer.isCompleted) {
            completer.completeError(Exception(
              'Failed to fetch manifest JSON from all '
              '${kManifestUrls.length} sources. Last error: $lastError',
            ));
          }
        }
      }();
    }

    return completer.future;
  }

  /// Fetch pubspec.yaml by racing concurrent GET requests (fallback).
  Future<YamlMap> _fetchManifestYaml() async {
    AppLogger.info(
      'Fetching manifest YAML fallback (racing ${kMetadataUrls.length} sources) …',
      tag: _kTag,
    );

    final completer = Completer<YamlMap>();
    var failCount = 0;
    final total = kMetadataUrls.length;
    Object? lastError;

    for (final url in kMetadataUrls) {
      () async {
        try {
          final response = await _dio.get<String>(
            url,
            options: Options(
              sendTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              followRedirects: true,
              validateStatus: (status) => status != null && status < 400,
            ),
          );
          final body = response.data;
          if (body == null || body.trim().isEmpty) {
            throw const FormatException('Manifest response is empty');
          }
          if (!completer.isCompleted) {
            AppLogger.info('Manifest YAML fetched from $url', tag: _kTag);
            completer.complete(loadYaml(body) as YamlMap);
          }
        } catch (e) {
          AppLogger.warning(
            'Manifest YAML fetch failed for $url: $e',
            tag: _kTag,
          );
          lastError = e;
          failCount++;
          if (failCount >= total && !completer.isCompleted) {
            completer.completeError(Exception(
              'Failed to fetch manifest YAML from all '
              '${kMetadataUrls.length} sources. Last error: $lastError',
            ));
          }
        }
      }();
    }

    return completer.future;
  }

  @override
  Future<VersionManifest> fetchManifest() => _fetchManifestJson();

  @override
  Future<void> probeProxies() async {
    await _prober.probe(
      kReleaseProxies,
      testPath: '/$_kOwner/$_kRepo/releases',
    );
  }

  @override
  Future<UpdateInfo> checkForUpdate() async {
    // 1. Get local version
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = AppVersion.parse(
      '${packageInfo.version}+${packageInfo.buildNumber}',
    );

    // 2. Try manifest JSON first, fallback to pubspec.yaml
    try {
      final manifest = await _fetchManifestJson();
      return _buildUpdateInfoFromManifest(manifest, currentVersion);
    } catch (e) {
      AppLogger.warning(
        'Manifest JSON unavailable, falling back to pubspec.yaml: $e',
        tag: _kTag,
      );
    }

    // 3. Fallback: pubspec.yaml + GitHub Releases API
    return _checkForUpdateFallback(currentVersion);
  }

  /// Build UpdateInfo from the manifest JSON (V2 path).
  Future<UpdateInfo> _buildUpdateInfoFromManifest(
    VersionManifest manifest,
    AppVersion currentVersion,
  ) async {
    final latestVersion = AppVersion.parse(manifest.latest);
    final minSupported = AppVersion.parse(manifest.minSupported);
    final isForceUpdate = currentVersion < minSupported;

    // Find the latest version entry
    final latestEntry = manifest.versions.firstWhere(
      (v) => v.version == manifest.latest,
      orElse: () => manifest.versions.first,
    );

    final assetName = _platformAssetName();
    final platformKey = _platformKey();
    final platformAssets = latestEntry.assets[platformKey];

    // Build download URLs map
    final downloadUrls = <DownloadChannel, String>{};
    String? lanzouPassword;

    if (platformAssets != null) {
      if (platformAssets.github != null) {
        // Apply proxy to GitHub URL
        final releaseProxy = await _prober.probe(
          kReleaseProxies,
          testPath: '/$_kOwner/$_kRepo/releases',
        );
        var githubUrl = platformAssets.github!;
        if (releaseProxy != 'https://github.com') {
          githubUrl = githubUrl.replaceFirst(
            'https://github.com',
            releaseProxy,
          );
        }
        downloadUrls[DownloadChannel.github] = githubUrl;
      }
      if (platformAssets.lanzou != null) {
        downloadUrls[DownloadChannel.lanzou] = platformAssets.lanzou!.url;
        lanzouPassword = platformAssets.lanzou!.password;
      }
    }

    // Fallback GitHub URL if none found in manifest
    if (!downloadUrls.containsKey(DownloadChannel.github)) {
      final releaseProxy = await _prober.probe(
        kReleaseProxies,
        testPath: '/$_kOwner/$_kRepo/releases',
      );
      downloadUrls[DownloadChannel.github] =
          '$releaseProxy/$_kOwner/$_kRepo/releases/download/v${latestVersion.semver}/$assetName';
    }

    // Try to get rich release notes from GitHub API
    var changelog = latestEntry.changelog;
    try {
      final releaseApiUrl =
          'https://api.github.com/repos/$_kOwner/$_kRepo/releases/tags/v${latestVersion.semver}';
      final releaseResponse = await _dio.get<Map<String, dynamic>>(
        releaseApiUrl,
        options: Options(
          headers: {'Accept': 'application/vnd.github.v3+json'},
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      final body = releaseResponse.data?['body'] as String?;
      if (body != null && body.isNotEmpty) {
        changelog = body;
      }
    } catch (_) {
      // Use manifest changelog
    }

    return UpdateInfo(
      latestVersion: latestVersion,
      currentVersion: currentVersion,
      changelog: changelog,
      isForceUpdate: isForceUpdate,
      assetName: assetName,
      downloadUrls: downloadUrls,
      lanzouPassword: lanzouPassword,
    );
  }

  /// Fallback: check for update using pubspec.yaml + GitHub Releases API.
  Future<UpdateInfo> _checkForUpdateFallback(AppVersion currentVersion) async {
    final yamlDoc = await _fetchManifestYaml();
    final remoteVersionStr = yamlDoc['version'] as String;
    final remoteVersion = AppVersion.parse(remoteVersionStr);

    final xUpdate = yamlDoc['x_update'] as YamlMap?;
    final minSupportedStr = xUpdate?['min_supported'] as String? ?? '0.0.0';
    final minSupported = AppVersion.parse(minSupportedStr);
    var changelog = xUpdate?['changelog'] as String? ?? '';
    final releaseNotesUrl = xUpdate?['release_notes_url'] as String?;

    final isForceUpdate = currentVersion < minSupported;

    String? downloadUrl;
    try {
      final releaseApiUrl =
          'https://api.github.com/repos/$_kOwner/$_kRepo/releases/tags/v${remoteVersion.semver}';
      final releaseResponse = await _dio.get<Map<String, dynamic>>(
        releaseApiUrl,
        options: Options(
          headers: {'Accept': 'application/vnd.github.v3+json'},
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      final releaseData = releaseResponse.data!;
      final body = releaseData['body'] as String?;
      if (body != null && body.isNotEmpty) {
        changelog = body;
      }

      final assets = releaseData['assets'] as List<dynamic>? ?? [];
      final assetName = _platformAssetName();
      for (final asset in assets) {
        if (asset['name'] == assetName) {
          downloadUrl = asset['browser_download_url'] as String;
          break;
        }
      }
    } catch (e) {
      AppLogger.warning(
        'Failed to fetch release info from API, using fallback URL: $e',
        tag: _kTag,
      );
    }

    final assetName = _platformAssetName();
    final releaseProxy = await _prober.probe(
      kReleaseProxies,
      testPath: '/$_kOwner/$_kRepo/releases',
    );

    if (downloadUrl == null) {
      downloadUrl =
          '$releaseProxy/$_kOwner/$_kRepo/releases/download/v${remoteVersion.semver}/$assetName';
    } else if (releaseProxy != 'https://github.com') {
      downloadUrl = downloadUrl.replaceFirst(
        'https://github.com',
        releaseProxy,
      );
    }

    return UpdateInfo(
      latestVersion: remoteVersion,
      currentVersion: currentVersion,
      changelog: changelog,
      isForceUpdate: isForceUpdate,
      assetName: assetName,
      downloadUrls: {DownloadChannel.github: downloadUrl},
      releaseNotesUrl:
          releaseNotesUrl?.isNotEmpty == true ? releaseNotesUrl : null,
    );
  }

  @override
  Future<UpdateInfo> getVersionInfo(String version) async {
    final manifest = await _fetchManifestJson();
    final entry = manifest.versions.firstWhere(
      (v) => v.version == version,
      orElse: () => throw Exception('Version $version not found in manifest'),
    );

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = AppVersion.parse(
      '${packageInfo.version}+${packageInfo.buildNumber}',
    );

    final targetVersion = AppVersion.parse('${entry.version}+${entry.build}');
    final minSupported = AppVersion.parse(manifest.minSupported);

    final assetName = _platformAssetName();
    final platformKey = _platformKey();
    final platformAssets = entry.assets[platformKey];

    final downloadUrls = <DownloadChannel, String>{};
    String? lanzouPassword;

    if (platformAssets != null) {
      if (platformAssets.github != null) {
        final releaseProxy = await _prober.probe(
          kReleaseProxies,
          testPath: '/$_kOwner/$_kRepo/releases',
        );
        var githubUrl = platformAssets.github!;
        if (releaseProxy != 'https://github.com') {
          githubUrl = githubUrl.replaceFirst(
            'https://github.com',
            releaseProxy,
          );
        }
        downloadUrls[DownloadChannel.github] = githubUrl;
      }
      if (platformAssets.lanzou != null) {
        downloadUrls[DownloadChannel.lanzou] = platformAssets.lanzou!.url;
        lanzouPassword = platformAssets.lanzou!.password;
      }
    }

    if (!downloadUrls.containsKey(DownloadChannel.github)) {
      final releaseProxy = await _prober.probe(
        kReleaseProxies,
        testPath: '/$_kOwner/$_kRepo/releases',
      );
      downloadUrls[DownloadChannel.github] =
          '$releaseProxy/$_kOwner/$_kRepo/releases/download/v${entry.version}/$assetName';
    }

    return UpdateInfo(
      latestVersion: targetVersion,
      currentVersion: currentVersion,
      changelog: entry.changelog,
      isForceUpdate: currentVersion < minSupported,
      assetName: assetName,
      downloadUrls: downloadUrls,
      lanzouPassword: lanzouPassword,
    );
  }

  @override
  Future<String> downloadUpdate({
    required String url,
    required String savePath,
    required void Function(double progress, double speed) onProgress,
    CancelToken? cancelToken,
    int startByte = 0,
  }) async {
    AppLogger.info('Downloading update from $url (startByte: $startByte)', tag: _kTag);

    int lastReceivedBytes = startByte;
    int lastTimestamp = DateTime.now().millisecondsSinceEpoch;

    final headers = <String, dynamic>{
      'User-Agent': 'BuSic-Updater',
    };
    if (startByte > 0) {
      headers['Range'] = 'bytes=$startByte-';
    }

    await _dio.download(
      url,
      savePath,
      cancelToken: cancelToken,
      deleteOnError: startByte == 0,
      options: Options(headers: headers),
      onReceiveProgress: (received, total) {
        if (total <= 0) return;
        final totalWithOffset = total + startByte;
        final receivedWithOffset = received + startByte;
        final progress = receivedWithOffset / totalWithOffset;
        final now = DateTime.now().millisecondsSinceEpoch;
        final elapsed = now - lastTimestamp;
        double speed = 0;
        if (elapsed > 200) {
          speed = (receivedWithOffset - lastReceivedBytes) / (elapsed / 1000.0);
          lastReceivedBytes = receivedWithOffset;
          lastTimestamp = now;
        }
        onProgress(progress, speed);
      },
    );

    AppLogger.info('Download complete: $savePath', tag: _kTag);
    return savePath;
  }

  @override
  Future<String> resolveLanzouUrl(String shareUrl, {String? password}) async {
    return _lanzouResolver.resolve(shareUrl, password: password);
  }

  /// Verify SHA-256 checksum of a downloaded file against the checksums file.
  ///
  /// Returns `true` if verified or if checksum file is unavailable.
  Future<bool> verifyChecksum(
    String filePath,
    String assetName,
    String version,
  ) async {
    try {
      final releaseProxy = await _prober.probe(
        kReleaseProxies,
        testPath: '/$_kOwner/$_kRepo/releases',
      );

      final checksumUrl =
          '$releaseProxy/$_kOwner/$_kRepo/releases/download/v$version/checksums.sha256';

      final response = await _dio.get<String>(
        checksumUrl,
        options: Options(receiveTimeout: const Duration(seconds: 10)),
      );

      final lines = response.data?.split('\n') ?? [];
      String? expectedHash;
      for (final line in lines) {
        if (line.contains(assetName)) {
          expectedHash = line.split(RegExp(r'\s+')).first.trim();
          break;
        }
      }

      if (expectedHash == null) {
        AppLogger.warning(
          'No checksum found for $assetName, skipping verification',
          tag: _kTag,
        );
        return true;
      }

      final fileBytes = await File(filePath).readAsBytes();
      final actualHash = sha256.convert(fileBytes).toString();

      if (actualHash == expectedHash) {
        AppLogger.info('Checksum verified for $assetName', tag: _kTag);
        return true;
      } else {
        AppLogger.error(
          'Checksum mismatch! Expected: $expectedHash, Got: $actualHash',
          tag: _kTag,
        );
        return false;
      }
    } catch (e) {
      AppLogger.warning(
        'Checksum verification skipped (unavailable): $e',
        tag: _kTag,
      );
      return true;
    }
  }

  @override
  Future<void> applyUpdate(String localPath) async {
    if (PlatformUtils.isAndroid) {
      await _applyAndroid(localPath);
    } else if (PlatformUtils.isWindows) {
      await _applyWindows(localPath);
    } else if (PlatformUtils.isLinux) {
      await _applyLinux(localPath);
    } else if (PlatformUtils.isMacOS) {
      await _applyMacOS(localPath);
    } else {
      throw UnsupportedError(
        'Auto-update is not supported on this platform.',
      );
    }
  }

  // ── Platform-specific install logic ──────────────────────────────

  Future<void> _applyAndroid(String apkPath) async {
    AppLogger.info('Installing APK: $apkPath', tag: _kTag);

    const channel = MethodChannel('com.busic.busic/apk_installer');
    try {
      await channel.invokeMethod('installApk', {'filePath': apkPath});
    } on PlatformException catch (e) {
      AppLogger.error(
        'Failed to launch installer: ${e.message}',
        tag: _kTag,
      );
      throw Exception('Failed to launch APK installer: ${e.message}');
    }
  }

  Future<void> _applyWindows(String zipPath) async {
    AppLogger.info('Applying Windows update from: $zipPath', tag: _kTag);

    final tempDir = await getTemporaryDirectory();
    final extractDir = Directory(p.join(tempDir.path, 'busic_update'));
    if (await extractDir.exists()) {
      await extractDir.delete(recursive: true);
    }
    await extractDir.create(recursive: true);

    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive) {
      final filePath = p.join(extractDir.path, file.name);
      if (file.isFile) {
        final outFile = File(filePath);
        await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content as List<int>);
      } else {
        await Directory(filePath).create(recursive: true);
      }
    }

    final exePath = Platform.resolvedExecutable;
    final installDir = p.dirname(exePath);

    final batPath = p.join(tempDir.path, 'busic_update.bat');
    final batContent = '@echo off\r\n'
        'timeout /t 2 /nobreak >nul\r\n'
        'xcopy /s /y /q "${extractDir.path}\\*" "$installDir\\"\r\n'
        'start "" "$installDir\\busic.exe"\r\n'
        'rd /s /q "${extractDir.path}"\r\n'
        'del "%~f0"\r\n';

    await File(batPath).writeAsString(batContent);

    await Process.start(
      'cmd',
      ['/c', batPath],
      mode: ProcessStartMode.detached,
    );
    exit(0);
  }

  Future<void> _applyLinux(String tarPath) async {
    AppLogger.info('Applying Linux update from: $tarPath', tag: _kTag);

    final tempDir = await getTemporaryDirectory();
    final extractDir = Directory(p.join(tempDir.path, 'busic_update'));
    if (await extractDir.exists()) {
      await extractDir.delete(recursive: true);
    }
    await extractDir.create(recursive: true);

    await Process.run('tar', ['xzf', tarPath, '-C', extractDir.path]);

    final exePath = Platform.resolvedExecutable;
    final installDir = p.dirname(exePath);

    // Check if install directory is writable
    final testFile = File(p.join(installDir, '.busic_write_test'));
    try {
      await testFile.writeAsString('test');
      await testFile.delete();
    } catch (_) {
      AppLogger.warning(
        'Install directory is read-only, cannot auto-update',
        tag: _kTag,
      );
      throw Exception(
        'Install directory is read-only. Please update manually.',
      );
    }

    // Generate update shell script
    final shPath = p.join(tempDir.path, 'busic_update.sh');
    final shContent = '#!/bin/bash\n'
        'sleep 2\n'
        'cp -rf "${extractDir.path}/"* "$installDir/"\n'
        'chmod +x "$installDir/busic"\n'
        'nohup "$installDir/busic" &\n'
        'rm -rf "${extractDir.path}"\n'
        'rm -f "$shPath"\n';

    await File(shPath).writeAsString(shContent);
    await Process.run('chmod', ['+x', shPath]);

    await Process.start(
      'bash',
      [shPath],
      mode: ProcessStartMode.detached,
    );
    exit(0);
  }

  Future<void> _applyMacOS(String zipPath) async {
    AppLogger.info('Applying macOS update from: $zipPath', tag: _kTag);

    final tempDir = await getTemporaryDirectory();
    final extractDir = Directory(p.join(tempDir.path, 'busic_update'));
    if (await extractDir.exists()) {
      await extractDir.delete(recursive: true);
    }
    await extractDir.create(recursive: true);

    // Unzip
    await Process.run('unzip', ['-o', zipPath, '-d', extractDir.path]);

    // Replace .app bundle
    const appBundlePath = '/Applications/busic.app';
    final shPath = p.join(tempDir.path, 'busic_update.sh');
    final shContent = '#!/bin/bash\n'
        'sleep 2\n'
        'rm -rf "$appBundlePath"\n'
        'cp -R "${extractDir.path}/busic.app" "$appBundlePath"\n'
        'open "$appBundlePath"\n'
        'rm -rf "${extractDir.path}"\n'
        'rm -f "$shPath"\n';

    await File(shPath).writeAsString(shContent);
    await Process.run('chmod', ['+x', shPath]);

    await Process.start(
      'bash',
      [shPath],
      mode: ProcessStartMode.detached,
    );
    exit(0);
  }
}
