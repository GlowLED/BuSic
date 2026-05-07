import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../../core/utils/logger.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../data/bili_web_login_cookie_store.dart';
import '../../domain/models/bili_login_cookies.dart';

class BiliWebLoginView extends StatefulWidget {
  const BiliWebLoginView({
    super.key,
    required this.cookieStore,
    required this.webViewEnvironment,
    required this.onCookiesCaptured,
    required this.onCookieMissing,
  });

  final BiliWebLoginCookieStore cookieStore;
  final WebViewEnvironment? webViewEnvironment;
  final ValueChanged<BiliLoginCookies> onCookiesCaptured;
  final VoidCallback onCookieMissing;

  @override
  State<BiliWebLoginView> createState() => _BiliWebLoginViewState();
}

class _BiliWebLoginViewState extends State<BiliWebLoginView> {
  static final _loginUrl = WebUri('https://passport.bilibili.com/login');

  bool _isChecking = false;
  bool _hasLoadError = false;
  double _progress = 0;
  String _currentUrl = _loginUrl.toString();

  Future<void> _tryCaptureCookies({bool showMissing = false}) async {
    if (_isChecking) return;
    setState(() => _isChecking = true);
    try {
      final cookies = await widget.cookieStore.readBiliCookies();
      if (!mounted) return;
      if (cookies != null) {
        widget.onCookiesCaptured(cookies);
      } else if (showMissing) {
        widget.onCookieMissing();
      }
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.webLoginTitle,
                      style: context.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.webLoginDesc,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _isChecking
                    ? null
                    : () => _tryCaptureCookies(showMissing: true),
                icon: _isChecking
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  _isChecking ? l10n.webLoginChecking : l10n.webLoginCompleted,
                ),
              ),
            ],
          ),
        ),
        if (_progress < 1)
          LinearProgressIndicator(value: _progress == 0 ? null : _progress),
        if (_hasLoadError)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  size: 18,
                  color: colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.webLoginPageLoadFailed,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: InAppWebView(
            webViewEnvironment: widget.webViewEnvironment,
            initialUrlRequest: URLRequest(url: _loginUrl),
            initialSettings: InAppWebViewSettings(
              isInspectable: kDebugMode,
              javaScriptEnabled: true,
              javaScriptCanOpenWindowsAutomatically: true,
              sharedCookiesEnabled: false,
              thirdPartyCookiesEnabled: true,
            ),
            onLoadStart: (controller, url) {
              if (!mounted || url == null) return;
              setState(() {
                _hasLoadError = false;
                _currentUrl = url.toString();
              });
            },
            onLoadStop: (controller, url) async {
              if (!mounted) return;
              setState(() {
                _progress = 1;
                if (url != null) _currentUrl = url.toString();
              });
              await _tryCaptureCookies();
            },
            onProgressChanged: (controller, progress) {
              if (!mounted) return;
              setState(() => _progress = progress / 100);
            },
            onReceivedError: (controller, request, error) {
              if (request.isForMainFrame == false) return;
              AppLogger.warning(
                'Web login page load error: ${error.description}',
                tag: 'Auth',
              );
              if (!mounted) return;
              setState(() => _hasLoadError = true);
            },
            onReceivedHttpError: (controller, request, errorResponse) {
              if (request.isForMainFrame == false) return;
              AppLogger.warning(
                'Web login page HTTP error: ${errorResponse.statusCode}',
                tag: 'Auth',
              );
              if (!mounted) return;
              setState(() => _hasLoadError = true);
            },
            onConsoleMessage: (controller, consoleMessage) {
              AppLogger.info(
                'Web login console: ${consoleMessage.message}',
                tag: 'Auth',
              );
            },
            onUpdateVisitedHistory: (controller, url, isReload) async {
              if (!mounted || url == null) return;
              setState(() => _currentUrl = url.toString());
              await _tryCaptureCookies();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Icon(
                Icons.lock_outline,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _currentUrl,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
