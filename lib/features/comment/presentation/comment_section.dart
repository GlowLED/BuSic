import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../auth/application/auth_notifier.dart';
import '../application/comment_notifier.dart';
import '../domain/models/comment.dart';
import 'reply_sheet.dart';
import 'widgets/comment_input.dart';
import 'widgets/comment_tile.dart';

enum ScrollEdge { top, bottom }

typedef ScrollToEdgeCallback = void Function(ScrollEdge edge);

/// A reusable comment section widget that displays comments for a given video.
///
/// Pass in a [bvid] and the widget handles loading, pagination, sorting,
/// posting, replying, and liking.
class CommentSection extends ConsumerStatefulWidget {
  const CommentSection({
    super.key,
    required this.bvid,
    this.onScrollToEdge,
    this.usePrimaryScrollController = false,
  });

  final ScrollToEdgeCallback? onScrollToEdge;
  final bool usePrimaryScrollController;

  /// The BV number of the video whose comments to show.
  final String bvid;

  @override
  ConsumerState<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends ConsumerState<CommentSection> {
  final _scrollController = ScrollController();
  String? _replyToUsername;
  int? _replyToRootRpid;
  int? _replyToParentRpid;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;

    final metrics = notification.metrics;
    if (metrics.extentAfter < 200) {
      ref.read(commentNotifierProvider(widget.bvid).notifier).loadMore();
    }
    _notifyScrollEdge(metrics);
    return false;
  }

  void _notifyScrollEdge(ScrollMetrics metrics) {
    final callback = widget.onScrollToEdge;
    if (callback == null) return;

    if (metrics.pixels <= metrics.minScrollExtent) {
      callback(ScrollEdge.top);
    } else if (metrics.pixels >= metrics.maxScrollExtent) {
      callback(ScrollEdge.bottom);
    }
  }

  void _onReply(Comment comment) {
    setState(() {
      _replyToUsername = comment.username;
      _replyToRootRpid = comment.rpid;
      _replyToParentRpid = comment.rpid;
    });
  }

  void _cancelReply() {
    setState(() {
      _replyToUsername = null;
      _replyToRootRpid = null;
      _replyToParentRpid = null;
    });
  }

  Future<void> _handleSubmit(String message) async {
    final user = ref.read(authNotifierProvider).valueOrNull;
    if (user == null) {
      if (mounted) {
        context.showSnackBar(context.l10n.pleaseLoginFirst);
      }
      return;
    }

    final notifier = ref.read(commentNotifierProvider(widget.bvid).notifier);
    if (_replyToRootRpid != null) {
      await notifier.replyToComment(
        message: message,
        rootRpid: _replyToRootRpid!,
        parentRpid: _replyToParentRpid!,
      );
      _cancelReply();
    } else {
      await notifier.addComment(message);
    }
  }

  void _showReplySheet(Comment comment) {
    final commentState =
        ref.read(commentNotifierProvider(widget.bvid)).valueOrNull;
    if (commentState == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReplySheet(
        rootComment: comment,
        oid: commentState.aid,
        bvid: widget.bvid,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final commentAsync = ref.watch(commentNotifierProvider(widget.bvid));
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final isLoggedIn = user != null;
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return Column(
      children: [
        // Comment list
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: _onScrollNotification,
            child: commentAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline,
                        size: 48, color: colorScheme.error),
                    const SizedBox(height: 8),
                    Text(
                      l10n.loadCommentsFailed,
                      style: TextStyle(color: colorScheme.error),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: () =>
                          ref.invalidate(commentNotifierProvider(widget.bvid)),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
              data: (state) {
                if (state.comments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: colorScheme.outlineVariant,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.noComments,
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  );
                }

                return CustomScrollView(
                  primary: widget.usePrimaryScrollController ? true : null,
                  controller: widget.usePrimaryScrollController
                      ? null
                      : _scrollController,
                  slivers: [
                    // Header: count + sort
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Row(
                          children: [
                            Text(
                              l10n.commentCount(state.totalCount),
                              style: context.textTheme.titleSmall,
                            ),
                            const Spacer(),
                            _SortChip(
                              label: l10n.popular,
                              isSelected: state.sortMode == 3,
                              onTap: () => ref
                                  .read(
                                    commentNotifierProvider(widget.bvid)
                                        .notifier,
                                  )
                                  .changeSortMode(3),
                            ),
                            const SizedBox(width: 8),
                            _SortChip(
                              label: l10n.latest,
                              isSelected: state.sortMode == 2,
                              onTap: () => ref
                                  .read(
                                    commentNotifierProvider(widget.bvid)
                                        .notifier,
                                  )
                                  .changeSortMode(2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Comment list
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= state.comments.length) {
                            if (state.isEnd) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Center(
                                  child: Text(
                                    '— ${l10n.allCommentsLoaded} —',
                                    style:
                                        context.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final comment = state.comments[index];
                          return CommentTile(
                            comment: comment,
                            isLoggedIn: isLoggedIn,
                            onLike: () {
                              if (!isLoggedIn) {
                                context.showSnackBar(l10n.loginToLike);
                                return;
                              }
                              ref
                                  .read(
                                    commentNotifierProvider(widget.bvid)
                                        .notifier,
                                  )
                                  .toggleLike(comment.rpid);
                            },
                            onReply: () {
                              if (!isLoggedIn) {
                                context.showSnackBar(l10n.loginToReply);
                                return;
                              }
                              _onReply(comment);
                            },
                            onViewReplies: () => _showReplySheet(comment),
                          );
                        },
                        childCount: state.comments.length +
                            (state.isLoadingMore || !state.isEnd ? 1 : 0),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // Input bar
        CommentInput(
          isLoggedIn: isLoggedIn,
          onLoginTap: () => context.push(AppRoutes.login),
          replyTo: _replyToUsername,
          onCancelReply: _cancelReply,
          onSubmit: _handleSubmit,
        ),
      ],
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
