import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../application/auth_notifier.dart';
import '../../../shared/extensions/context_extensions.dart';

/// Login screen with QR code display for Bilibili authentication.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String? _qrUrl;
  String _statusText = '';
  bool _isLoading = false;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    _generateQrCode();
  }

  Future<void> _generateQrCode() async {
    setState(() {
      _isLoading = true;
      _isExpired = false;
      _statusText = context.l10n.scanToLogin;
    });
    try {
      final url = await ref.read(authNotifierProvider.notifier).login();
      setState(() {
        _qrUrl = url;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusText = context.l10n.loginFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final colorScheme = context.colorScheme;

    // If logged in, navigate back
    ref.listen(authNotifierProvider, (prev, next) {
      next.whenData((user) {
        if (user != null) {
          if (context.mounted) {
            context.showSnackBar(context.l10n.loginSuccess);
            context.go('/');
          }
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(context.l10n.login),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.music_note, size: 48, color: colorScheme.primary),
                const SizedBox(height: 16),
                Text('BuSic', style: context.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary, fontWeight: FontWeight.bold,
                )),
                const SizedBox(height: 32),
                if (_isLoading)
                  const SizedBox(
                    width: 200, height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_qrUrl != null && !_isExpired)
                  QrImageView(
                    data: _qrUrl!,
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                  )
                else
                  SizedBox(
                    width: 200, height: 200,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh, size: 48, color: colorScheme.error),
                          const SizedBox(height: 8),
                          Text(context.l10n.loginFailed),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Text(_statusText, style: context.textTheme.bodyLarge),
                const SizedBox(height: 16),
                if (_isExpired || (!_isLoading && _qrUrl == null))
                  FilledButton.icon(
                    onPressed: _generateQrCode,
                    icon: const Icon(Icons.refresh),
                    label: Text(context.l10n.reset),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
