import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Login screen with QR code display for Bilibili authentication.
///
/// Shows:
/// - A QR code image for the user to scan with the Bilibili mobile app
/// - Status text indicating scanning progress
/// - A refresh button if the QR code expires
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement QR code login UI
    // - Watch authNotifierProvider for status updates
    // - Display QR code using qr_flutter package
    // - Show scanning/confirming/expired status
    return const Scaffold(
      body: Center(
        child: Text('TODO: LoginScreen'),
      ),
    );
  }
}
