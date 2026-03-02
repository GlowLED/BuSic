import 'package:flutter/material.dart';

/// Collection of reusable dialog helpers.
///
/// All dialogs return a [Future] that resolves when the dialog is dismissed.
class CommonDialogs {
  CommonDialogs._();

  /// Show a confirmation dialog with [title] and [message].
  ///
  /// Returns `true` if the user confirmed, `false` or `null` if cancelled.
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmLabel,
    String? cancelLabel,
  }) async {
    // TODO: implement Material confirm dialog
    throw UnimplementedError();
  }

  /// Show a text input dialog.
  ///
  /// Returns the entered text if confirmed, `null` if cancelled.
  static Future<String?> showInputDialog(
    BuildContext context, {
    required String title,
    String? hint,
    String? initialValue,
    String? confirmLabel,
    String? cancelLabel,
  }) async {
    // TODO: implement Material input dialog
    throw UnimplementedError();
  }

  /// Show an error dialog with a retry option.
  ///
  /// Returns `true` if the user chose to retry, `false` or `null` otherwise.
  static Future<bool?> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    bool showRetry = false,
  }) async {
    // TODO: implement Material error dialog
    throw UnimplementedError();
  }
}
