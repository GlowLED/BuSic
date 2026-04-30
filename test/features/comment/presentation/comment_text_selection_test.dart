import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/auth/application/auth_notifier.dart';
import 'package:busic/features/auth/data/auth_repository.dart';
import 'package:busic/features/auth/domain/models/qr_poll_result.dart';
import 'package:busic/features/auth/domain/models/user.dart';
import 'package:busic/features/comment/application/comment_notifier.dart';
import 'package:busic/features/comment/data/comment_repository.dart';
import 'package:busic/features/comment/domain/models/comment.dart';
import 'package:busic/features/comment/domain/models/comment_page.dart';
import 'package:busic/features/comment/presentation/reply_sheet.dart';
import 'package:busic/features/comment/presentation/widgets/comment_tile.dart';

import '../../../test_helpers/test_app.dart';

void main() {
  group('comment text selection', () {
    testWidgets('makes main comment and preview reply content selectable',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CommentTile(
            comment: _rootComment,
            isLoggedIn: true,
            onLike: () {},
            onReply: () {},
            onViewReplies: () {},
          ),
        ),
      );

      _expectTextInSelectionArea(_rootComment.content);
      _expectTextInSelectionAreaContaining(_previewReply.content);
    });

    testWidgets('makes reply sheet root and child reply content selectable',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
            commentRepositoryProvider.overrideWithValue(
              const _FakeCommentRepository(replies: [_sheetReply]),
            ),
          ],
          child: buildTestApp(
            const ReplySheet(
              rootComment: _rootComment,
              oid: 123456,
              bvid: 'BV1selectable',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      _expectTextInSelectionArea(_rootComment.content);
      _expectTextInSelectionArea(_sheetReply.content);
    });
  });
}

void _expectTextInSelectionArea(String text) {
  final textFinder = find.text(text);

  expect(textFinder, findsOneWidget);
  expect(
    find.ancestor(
      of: textFinder,
      matching: find.byType(SelectionArea),
    ),
    findsOneWidget,
  );
}

void _expectTextInSelectionAreaContaining(String text) {
  final textFinder = find.textContaining(text);

  expect(textFinder, findsOneWidget);
  expect(
    find.ancestor(
      of: textFinder,
      matching: find.byType(SelectionArea),
    ),
    findsOneWidget,
  );
}

const _previewReply = Comment(
  rpid: 2002,
  mid: 3002,
  username: 'Preview User',
  avatarUrl: '',
  content: 'Preview reply body',
  ctime: 1710000010,
  likeCount: 0,
  replyCount: 0,
);

const _rootComment = Comment(
  rpid: 1001,
  mid: 3001,
  username: 'Root User',
  avatarUrl: '',
  content: 'Root comment body',
  ctime: 1710000000,
  likeCount: 7,
  replyCount: 1,
  replies: [_previewReply],
);

const _sheetReply = Comment(
  rpid: 2003,
  mid: 3003,
  username: 'Sheet User',
  avatarUrl: '',
  content: 'Reply sheet body',
  ctime: 1710000020,
  likeCount: 1,
  replyCount: 0,
);

const _user = User(
  userId: '42',
  nickname: 'Test User',
  sessdata: 'sess-token',
  biliJct: 'csrf-token',
  isLoggedIn: true,
);

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<void> clearSession() async {}

  @override
  Future<({String qrUrl, String qrKey})> generateQrCode() async {
    return (qrUrl: 'https://example.com/qr', qrKey: 'qr-key');
  }

  @override
  Future<User?> loadSession() async {
    return _user;
  }

  @override
  Future<QrPollResult> pollQrStatus(String qrKey) async {
    return const QrPollResult(code: 86101, message: 'not scanned');
  }

  @override
  Future<User?> refreshSession() async {
    return _user;
  }

  @override
  Future<void> saveSession(User user) async {}
}

class _FakeCommentRepository implements CommentRepository {
  const _FakeCommentRepository({required this.replies});

  final List<Comment> replies;

  @override
  Future<Comment> addComment({
    required int oid,
    required String message,
    required String csrf,
    int? root,
    int? parent,
  }) async {
    return _sheetReply.copyWith(content: message);
  }

  @override
  Future<int> getAidByBvid(String bvid) async {
    return 123456;
  }

  @override
  Future<CommentPage> getComments({
    required int oid,
    int mode = 3,
    int next = 0,
    int ps = 20,
  }) async {
    return const CommentPage(
      totalCount: 0,
      next: 0,
      isEnd: true,
      replies: [],
    );
  }

  @override
  Future<CommentPage> getReplies({
    required int oid,
    required int rootRpid,
    int page = 1,
    int ps = 20,
  }) async {
    return CommentPage(
      totalCount: replies.length,
      next: 0,
      isEnd: true,
      replies: replies,
    );
  }

  @override
  Future<void> likeComment({
    required int oid,
    required int rpid,
    required bool like,
    required String csrf,
  }) async {}
}
