import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/utils/logger.dart';
import '../../auth/application/auth_notifier.dart';
import '../data/comment_repository.dart';
import '../data/comment_repository_impl.dart';
import '../domain/models/comment.dart';

part 'comment_notifier.freezed.dart';
part 'comment_notifier.g.dart';

/// Internal state for the comment notifier.
@freezed
class CommentState with _$CommentState {
  const factory CommentState({
    /// Resolved numeric AID for the video.
    @Default(0) int aid,

    /// Loaded comments.
    @Default([]) List<Comment> comments,

    /// Pagination cursor for the next page.
    @Default(0) int nextCursor,

    /// Whether all comments have been loaded.
    @Default(false) bool isEnd,

    /// Sort mode: 2 = popularity, 3 = time.
    @Default(2) int sortMode,

    /// Total comment count.
    @Default(0) int totalCount,

    /// Whether more comments are being loaded.
    @Default(false) bool isLoadingMore,
  }) = _CommentState;
}

/// Riverpod notifier managing the comment list for a specific video.
///
/// Family parameter is the video's `bvid` string.
@riverpod
class CommentNotifier extends _$CommentNotifier {
  late final CommentRepository _repository;

  @override
  Future<CommentState> build(String bvid) async {
    _repository = CommentRepositoryImpl(biliDio: BiliDio());

    // Resolve bvid → aid
    final aid = await _repository.getAidByBvid(bvid);

    // Fetch first page of comments
    final page = await _repository.getComments(oid: aid);

    return CommentState(
      aid: aid,
      comments: page.replies,
      nextCursor: page.next,
      isEnd: page.isEnd,
      totalCount: page.totalCount,
    );
  }

  /// Load the next page of comments.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isEnd || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final page = await _repository.getComments(
        oid: current.aid,
        mode: current.sortMode,
        next: current.nextCursor,
      );

      state = AsyncData(current.copyWith(
        comments: [...current.comments, ...page.replies],
        nextCursor: page.next,
        isEnd: page.isEnd,
        isLoadingMore: false,
      ));
    } catch (e) {
      AppLogger.error('Failed to load more comments: $e', tag: 'Comment');
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  /// Change sort mode and reload comments.
  Future<void> changeSortMode(int mode) async {
    final current = state.valueOrNull;
    if (current == null || current.sortMode == mode) return;

    state = const AsyncLoading();

    try {
      final page = await _repository.getComments(
        oid: current.aid,
        mode: mode,
      );

      state = AsyncData(CommentState(
        aid: current.aid,
        comments: page.replies,
        nextCursor: page.next,
        isEnd: page.isEnd,
        sortMode: mode,
        totalCount: page.totalCount,
      ));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  /// Post a new top-level comment.
  Future<void> addComment(String message) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final user = ref.read(authNotifierProvider).valueOrNull;
    if (user == null) throw Exception('未登录');

    try {
      final newComment = await _repository.addComment(
        oid: current.aid,
        message: message,
        csrf: user.biliJct,
      );

      state = AsyncData(current.copyWith(
        comments: [newComment, ...current.comments],
        totalCount: current.totalCount + 1,
      ));
    } catch (e) {
      AppLogger.error('Failed to add comment: $e', tag: 'Comment');
      rethrow;
    }
  }

  /// Reply to an existing comment.
  Future<void> replyToComment({
    required String message,
    required int rootRpid,
    required int parentRpid,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final user = ref.read(authNotifierProvider).valueOrNull;
    if (user == null) throw Exception('未登录');

    try {
      await _repository.addComment(
        oid: current.aid,
        message: message,
        csrf: user.biliJct,
        root: rootRpid,
        parent: parentRpid,
      );

      // Refresh the comment list to show the new reply
      ref.invalidateSelf();
    } catch (e) {
      AppLogger.error('Failed to reply: $e', tag: 'Comment');
      rethrow;
    }
  }

  /// Like or unlike a comment.
  Future<void> toggleLike(int rpid) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final user = ref.read(authNotifierProvider).valueOrNull;
    if (user == null) throw Exception('未登录');

    // Find the comment and toggle optimistically
    final idx = current.comments.indexWhere((c) => c.rpid == rpid);
    if (idx == -1) return;

    final comment = current.comments[idx];
    final newLiked = !comment.isLiked;
    final newLikeCount =
        comment.likeCount + (newLiked ? 1 : -1);

    // Optimistic update
    final updatedComments = [...current.comments];
    updatedComments[idx] = comment.copyWith(
      isLiked: newLiked,
      likeCount: newLikeCount,
    );
    state = AsyncData(current.copyWith(comments: updatedComments));

    try {
      await _repository.likeComment(
        oid: current.aid,
        rpid: rpid,
        like: newLiked,
        csrf: user.biliJct,
      );
    } catch (e) {
      // Revert on failure
      final reverted = [...updatedComments];
      reverted[idx] = comment;
      state = AsyncData(current.copyWith(comments: reverted));
      AppLogger.error('Failed to toggle like: $e', tag: 'Comment');
      rethrow;
    }
  }
}

/// Provider for the comment repository (used by ReplySheet).
final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepositoryImpl(biliDio: BiliDio());
});
