import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../domain/models/comment.dart';

/// Displays a single comment with avatar, username, content, and actions.
class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.comment,
    required this.onLike,
    required this.onReply,
    required this.onViewReplies,
    this.isLoggedIn = false,
  });

  final Comment comment;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final VoidCallback onViewReplies;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: colorScheme.surfaceContainerHighest,
            backgroundImage: comment.avatarUrl.isNotEmpty
                ? CachedNetworkImageProvider(comment.avatarUrl)
                : null,
            child: comment.avatarUrl.isEmpty
                ? Icon(Icons.person, size: 20, color: colorScheme.onSurfaceVariant)
                : null,
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username + time
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment.username,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _formatTime(comment.ctime),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Comment content
                Text(
                  comment.content,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),

                // Actions row
                Row(
                  children: [
                    // Like button
                    _ActionButton(
                      icon: comment.isLiked
                          ? Icons.thumb_up
                          : Icons.thumb_up_outlined,
                      label: comment.likeCount > 0
                          ? _formatCount(comment.likeCount)
                          : '',
                      isActive: comment.isLiked,
                      onTap: onLike,
                      activeColor: colorScheme.primary,
                    ),
                    const SizedBox(width: 16),

                    // Reply button
                    _ActionButton(
                      icon: Icons.comment_outlined,
                      label: '',
                      onTap: onReply,
                    ),

                    // View replies
                    if (comment.replyCount > 0) ...[
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: onViewReplies,
                        child: Text(
                          '${comment.replyCount}条回复',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Preview replies
                if (comment.replies.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final reply in comment.replies.take(3))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${reply.username}：',
                                    style: textTheme.labelMedium?.copyWith(
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: reply.content,
                                    style: textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (comment.replyCount > 3)
                          GestureDetector(
                            onTap: onViewReplies,
                            child: Text(
                              '查看全部${comment.replyCount}条回复 >',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int ctime) {
    final now = DateTime.now();
    final time = DateTime.fromMillisecondsSinceEpoch(ctime * 1000);
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inHours < 1) return '${diff.inMinutes}分钟前';
    if (diff.inDays < 1) return '${diff.inHours}小时前';
    if (diff.inDays < 30) return '${diff.inDays}天前';
    if (diff.inDays < 365) return '${diff.inDays ~/ 30}个月前';
    return '${diff.inDays ~/ 365}年前';
  }

  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}万';
    }
    return '$count';
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.activeColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? (activeColor ?? context.colorScheme.primary)
        : context.colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }
}
