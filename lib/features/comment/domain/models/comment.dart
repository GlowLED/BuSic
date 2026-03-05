import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';

/// Domain model representing a single Bilibili comment.
@freezed
class Comment with _$Comment {
  const factory Comment({
    /// Comment ID (rpid).
    required int rpid,

    /// Commenter's user ID.
    required int mid,

    /// Commenter's display name.
    required String username,

    /// Commenter's avatar URL.
    required String avatarUrl,

    /// Comment text content.
    required String content,

    /// Unix timestamp in seconds.
    required int ctime,

    /// Number of likes.
    required int likeCount,

    /// Number of replies (child comments).
    required int replyCount,

    /// Whether the current user has liked this comment.
    @Default(false) bool isLiked,

    /// Preview of child replies (usually 0-3 from the main list).
    @Default([]) List<Comment> replies,
  }) = _Comment;
}
