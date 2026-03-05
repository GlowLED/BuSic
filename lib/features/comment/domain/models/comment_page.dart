import 'package:freezed_annotation/freezed_annotation.dart';

import 'comment.dart';

part 'comment_page.freezed.dart';

/// Paginated response for a comment list.
@freezed
class CommentPage with _$CommentPage {
  const factory CommentPage({
    /// Total number of comments.
    required int totalCount,

    /// Cursor for the next page (used in `/x/v2/reply/main`).
    required int next,

    /// Whether this is the last page.
    required bool isEnd,

    /// Comments in this page.
    required List<Comment> replies,
  }) = _CommentPage;
}
