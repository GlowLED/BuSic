import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_panel.dart';
import '../../auth/application/auth_notifier.dart';
import '../application/comment_notifier.dart';
import '../domain/models/comment.dart';
import 'comment_section_appearance.dart';
import 'widgets/comment_image_list.dart';
import 'widgets/comment_input.dart';

/// Bottom sheet that shows all replies (楼中楼) for a root comment.
class ReplySheet extends ConsumerStatefulWidget {
  const ReplySheet({
    super.key,
    required this.rootComment,
    required this.oid,
    required this.bvid,
    this.appearance = CommentSectionAppearance.standard,
  });

  final Comment rootComment;
  final int oid;
  final String bvid;
  final CommentSectionAppearance appearance;

  @override
  ConsumerState<ReplySheet> createState() => _ReplySheetState();
}

class _ReplySheetState extends ConsumerState<ReplySheet> {
  final List<Comment> _replies = [];
  bool _isLoading = true;
  bool _isEnd = false;
  int _currentPage = 1;
  String? _replyToUsername;
  int? _replyToRpid;

  @override
  void initState() {
    super.initState();
    _loadReplies();
  }

  Future<void> _loadReplies() async {
    try {
      final repo = ref.read(commentRepositoryProvider);
      final page = await repo.getReplies(
        oid: widget.oid,
        rootRpid: widget.rootComment.rpid,
        page: _currentPage,
      );
      if (mounted) {
        setState(() {
          _replies.addAll(page.replies);
          _isEnd = page.isEnd;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        context.showSnackBar('加载回复失败: $e');
      }
    }
  }

  Future<void> _loadMoreReplies() async {
    if (_isEnd || _isLoading) return;
    _currentPage++;
    setState(() => _isLoading = true);
    await _loadReplies();
  }

  Future<void> _handleReplySubmit(String message) async {
    final user = ref.read(authNotifierProvider).value;
    if (user == null) {
      if (mounted) {
        context.showSnackBar(context.l10n.pleaseLoginFirst);
      }
      return;
    }

    final notifier = ref.read(commentNotifierProvider(widget.bvid).notifier);
    await notifier.replyToComment(
      message: message,
      rootRpid: widget.rootComment.rpid,
      parentRpid: _replyToRpid ?? widget.rootComment.rpid,
    );

    // Refresh replies
    setState(() {
      _replies.clear();
      _currentPage = 1;
      _isLoading = true;
      _replyToUsername = null;
      _replyToRpid = null;
    });
    await _loadReplies();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).value;
    final isLoggedIn = user != null;

    final sheet = DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        final colorScheme = context.colorScheme;
        final textTheme = context.textTheme;
        final content = Column(
          children: [
            // Handle
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '回复 (${widget.rootComment.replyCount})',
                    style: textTheme.titleMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Root comment
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: widget.rootComment.avatarUrl.isNotEmpty
                        ? CachedNetworkImageProvider(
                            widget.rootComment.avatarUrl,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.rootComment.username,
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SelectionArea(
                          child: Text(
                            widget.rootComment.content,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                        if (widget.rootComment.images.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          CommentImageList(images: widget.rootComment.images),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Replies list
            Expanded(
              child: _isLoading && _replies.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification &&
                            notification.metrics.extentAfter < 100) {
                          _loadMoreReplies();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: _replies.length + (_isEnd ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index >= _replies.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final reply = _replies[index];
                          return _buildReplyTile(
                            context,
                            reply,
                            colorScheme,
                            textTheme,
                          );
                        },
                      ),
                    ),
            ),

            // Reply input
            CommentInput(
              isLoggedIn: isLoggedIn,
              onLoginTap: () {
                Navigator.pop(context);
                context.showSnackBar(context.l10n.pleaseLoginFirst);
              },
              replyTo: _replyToUsername ?? widget.rootComment.username,
              onCancelReply: () {
                setState(() {
                  _replyToUsername = null;
                  _replyToRpid = null;
                });
              },
              onSubmit: _handleReplySubmit,
            ),
          ],
        );

        if (widget.appearance == CommentSectionAppearance.standard) {
          return content;
        }
        return Padding(
          padding: EdgeInsets.fromLTRB(
            context.appSpacing.xs,
            0,
            context.appSpacing.xs,
            context.appSpacing.xs,
          ),
          child: AppPanel(
            key: const ValueKey('player-reply-panel'),
            borderRadius: context.appRadii.xLargeRadius,
            backgroundColors: [
              Colors.black.withValues(alpha: 0.74),
              Colors.black.withValues(alpha: 0.62),
            ],
            borderColor: Colors.white.withValues(alpha: 0.16),
            borderWidth: context.appDepth.outline,
            boxShadow: const [],
            blurSigma: 24,
            child: content,
          ),
        );
      },
    );

    if (widget.appearance == CommentSectionAppearance.standard) {
      return sheet;
    }
    return Theme(
      data: commentSectionTheme(context, widget.appearance),
      child: sheet,
    );
  }

  Widget _buildReplyTile(
    BuildContext context,
    Comment reply,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          _replyToUsername = reply.username;
          _replyToRpid = reply.rpid;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundImage: reply.avatarUrl.isNotEmpty
                  ? CachedNetworkImageProvider(reply.avatarUrl)
                  : null,
              child: reply.avatarUrl.isEmpty
                  ? const Icon(Icons.person, size: 16)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reply.username,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  SelectionArea(
                    child: Text(reply.content, style: textTheme.bodySmall),
                  ),
                  if (reply.images.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    CommentImageList(images: reply.images),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(reply.ctime),
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Like
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Like reply - not tracked in main notifier
                    context.showSnackBar('点赞功能仅支持主评论');
                  },
                  child: Icon(
                    reply.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    size: 14,
                    color: reply.isLiked
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                if (reply.likeCount > 0)
                  Text(
                    '${reply.likeCount}',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ],
        ),
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
    return '${diff.inDays ~/ 30}个月前';
  }
}
