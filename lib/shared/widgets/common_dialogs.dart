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
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel ?? '取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel ?? '确认'),
          ),
        ],
      ),
    );
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
    final controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(cancelLabel ?? '取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(confirmLabel ?? '确认'),
          ),
        ],
      ),
    );
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
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('关闭'),
          ),
          if (showRetry)
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('重试'),
            ),
        ],
      ),
    );
  }
}
