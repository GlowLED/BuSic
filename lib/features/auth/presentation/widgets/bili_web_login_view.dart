import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../data/bili_web_login_cookie_store.dart';
import '../../domain/models/bili_login_cookies.dart';

class BiliWebLoginView extends StatefulWidget {
  const BiliWebLoginView({
    super.key,
    required this.cookieStore,
    required this.onCookiesCaptured,
    required this.onCookieMissing,
  });

  final BiliWebLoginCookieStore cookieStore;
  final ValueChanged<BiliLoginCookies> onCookiesCaptured;
  final VoidCallback onCookieMissing;

  @override
  State<BiliWebLoginView> createState() => _BiliWebLoginViewState();
}

class _BiliWebLoginViewState extends State<BiliWebLoginView> {
  static final _loginUrl = WebUri('https://passport.bilibili.com/login');

  bool _isChecking = false;
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
        Expanded(
          child: ClipRect(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: _loginUrl),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                sharedCookiesEnabled: false,
                thirdPartyCookiesEnabled: true,
                useShouldOverrideUrlLoading: true,
              ),
              onLoadStart: (controller, url) {
                if (!mounted || url == null) return;
                setState(() => _currentUrl = url.toString());
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
              onUpdateVisitedHistory: (controller, url, isReload) async {
                if (!mounted || url == null) return;
                setState(() => _currentUrl = url.toString());
                await _tryCaptureCookies();
              },
            ),
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
