import '../domain/models/comment.dart';
import '../domain/models/comment_page.dart';

/// Abstract repository for Bilibili comment operations.
///
/// Provides methods for fetching, posting, replying, and liking comments.
abstract class CommentRepository {
  /// Fetch the main comment list for a video.
  ///
  /// [oid] is the video's AID (numeric ID).
  /// [mode] controls sort order: 2 = by popularity, 3 = by time.
  /// [next] is the pagination cursor (starts at 0).
  Future<CommentPage> getComments({
    required int oid,
    int mode = 3,
    int next = 0,
    int ps = 20,
  });

  /// Fetch child replies (楼中楼) for a root comment.
  ///
  /// [rootRpid] is the root comment's rpid.
  /// [page] is 1-based page number.
  Future<CommentPage> getReplies({
    required int oid,
    required int rootRpid,
    int page = 1,
    int ps = 20,
  });

  /// Post a new comment or reply.
  ///
  /// Returns the newly created [Comment].
  /// For a top-level comment, omit [root] and [parent].
  /// For a reply, provide both [root] (the root comment rpid)
  /// and [parent] (the direct parent rpid being replied to).
  Future<Comment> addComment({
    required int oid,
    required String message,
    required String csrf,
    int? root,
    int? parent,
  });

  /// Like or unlike a comment.
  ///
  /// [like] = true to like, false to unlike.
  Future<void> likeComment({
    required int oid,
    required int rpid,
    required bool like,
    required String csrf,
  });

  /// Resolve a BV number to its numeric AID.
  Future<int> getAidByBvid(String bvid);
}
