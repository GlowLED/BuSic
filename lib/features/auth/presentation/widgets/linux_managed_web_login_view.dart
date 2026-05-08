import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/utils/logger.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../data/linux_managed_browser_login_service.dart';
import '../../domain/models/bili_login_cookies.dart';

class LinuxManagedWebLoginView extends StatefulWidget {
  const LinuxManagedWebLoginView({
    super.key,
    required this.loginService,
    required this.onCookiesCaptured,
    required this.onCookieMissing,
    required this.isVerifying,
  });

  final LinuxManagedBrowserLoginService loginService;
  final Future<void> Function(
    BiliLoginCookies cookies,
    LinuxManagedBrowserLoginSession session,
  ) onCookiesCaptured;
  final VoidCallback onCookieMissing;
  final bool isVerifying;

  @override
  State<LinuxManagedWebLoginView> createState() =>
      _LinuxManagedWebLoginViewState();
}

class _LinuxManagedWebLoginViewState extends State<LinuxManagedWebLoginView> {
  LinuxManagedBrowserLoginSession? _session;
  bool _isStarting = false;
  bool _isChecking = false;
  bool _hasError = false;

  @override
  void dispose() {
    final session = _session;
    if (session != null) {
      unawaited(session.close());
    }
    super.dispose();
  }

  Future<void> _startLogin() async {
    if (_isStarting || widget.isVerifying) return;
    setState(() {
      _isStarting = true;
      _hasError = false;
    });
    try {
      final session = await widget.loginService.startLogin();
      if (!mounted) {
        await session.close();
        return;
      }
      setState(() {
        _session = session;
      });
    } catch (e, stackTrace) {
      AppLogger.error(
        'Linux managed web login failed to start',
        tag: 'Auth',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(() => _hasError = true);
      }
    } finally {
      if (mounted) {
        setState(() => _isStarting = false);
      }
    }
  }

  Future<void> _checkCookies() async {
    final session = _session;
    if (session == null || _isChecking || widget.isVerifying) return;

    setState(() {
      _isChecking = true;
      _hasError = false;
    });
    try {
      final cookies = await session.readBiliCookies();
      if (!mounted) return;
      if (cookies == null) {
        widget.onCookieMissing();
        return;
      }

      await widget.onCookiesCaptured(cookies, session);
      if (mounted && identical(_session, session)) {
        setState(() => _session = null);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Linux managed web login cookie capture failed',
        tag: 'Auth',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(() => _hasError = true);
      }
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  Future<void> _cancelLogin() async {
    final session = _session;
    setState(() {
      _session = null;
      _hasError = false;
    });
    await session?.close();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;
    final sessionStarted = _session != null;
    final busy = _isStarting || _isChecking || widget.isVerifying;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.open_in_browser,
                size: 36,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.webLoginLinuxTitle,
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      sessionStarted
                          ? l10n.webLoginLinuxWaiting
                          : l10n.webLoginLinuxDesc,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_hasError) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  size: 18,
                  color: colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.webLoginLinuxStartFailed,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          if (!sessionStarted)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: busy ? null : _startLogin,
                icon: _isStarting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.open_in_new),
                label: Text(
                  _isStarting
                      ? l10n.webLoginPreparing
                      : l10n.webLoginLinuxOpenBrowser,
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: busy ? null : _checkCookies,
                    icon: _isChecking || widget.isVerifying
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_circle_outline),
                    label: Text(
                      _isChecking || widget.isVerifying
                          ? l10n.webLoginChecking
                          : l10n.webLoginCompleted,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: busy ? null : _cancelLogin,
                  icon: const Icon(Icons.close),
                  label: Text(l10n.webLoginLinuxCancel),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
