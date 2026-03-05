import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';

/// A text input bar for posting comments.
///
/// Shows a "login to comment" prompt when [isLoggedIn] is false.
/// When replying to someone, displays "Reply to @username" with a cancel button.
class CommentInput extends StatefulWidget {
  const CommentInput({
    super.key,
    required this.onSubmit,
    required this.isLoggedIn,
    required this.onLoginTap,
    this.replyTo,
    this.onCancelReply,
  });

  /// Called when the user submits a comment.
  final Future<void> Function(String message) onSubmit;

  /// Whether the user is logged in.
  final bool isLoggedIn;

  /// Called when the user taps the login prompt.
  final VoidCallback onLoginTap;

  /// If non-null, shows "Reply to @replyTo" mode.
  final String? replyTo;

  /// Called when the user cancels reply mode.
  final VoidCallback? onCancelReply;

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    try {
      await widget.onSubmit(text);
      _controller.clear();
      _focusNode.unfocus();
    } catch (e) {
      if (mounted) {
        context.showSnackBar('${context.l10n.sendFailed}: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    if (!widget.isLoggedIn) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          border: Border(
            top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
          ),
        ),
        child: GestureDetector(
          onTap: widget.onLoginTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              l10n.loginToComment,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reply-to indicator
            if (widget.replyTo != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.replyTo(widget.replyTo!),
                        style: context.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onCancelReply,
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

            // Input row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: widget.replyTo != null
                          ? '${l10n.replyTo(widget.replyTo!)}...'
                          : l10n.writeComment,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      isDense: true,
                    ),
                    maxLines: 3,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _handleSubmit(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _isSending ? null : _handleSubmit,
                  icon: _isSending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  iconSize: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
