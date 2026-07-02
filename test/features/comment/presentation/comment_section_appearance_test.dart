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
import 'package:busic/features/comment/presentation/comment_section.dart';
import 'package:busic/features/player/presentation/widgets/player_comment_panel.dart';
import 'package:busic/shared/widgets/app_panel.dart';

import '../../../test_helpers/test_app.dart';

void main() {
  group('独占播放器评论外观', () {
    testWidgets('深色毛玻璃面板承载简洁评论行', (tester) async {
      await _pumpComments(
        tester,
        const PlayerCommentPanel(bvid: _bvid),
      );

      expect(
        find.byKey(const ValueKey('player-comment-panel')),
        findsOneWidget,
      );
      expect(find.byType(AppPanel), findsOneWidget);
      expect(find.text(_rootCommentContent), findsOneWidget);

      final commentText = tester.widget<Text>(find.text(_rootCommentContent));
      expect(
        commentText.style?.color,
        Colors.white.withValues(alpha: 0.90),
      );
      final popularText = tester.widget<Text>(find.text('Popular'));
      expect(
        popularText.style?.color,
        Colors.black.withValues(alpha: 0.88),
      );
    });

    testWidgets('楼中楼回复弹层延续独占玻璃外观', (tester) async {
      await _pumpComments(
        tester,
        const PlayerCommentPanel(bvid: _bvid),
      );

      await tester.tap(find.text('1条回复'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('player-reply-panel')),
        findsOneWidget,
      );
      expect(find.text(_replyContent), findsOneWidget);
    });

    testWidgets('通用评论区默认不启用独占面板', (tester) async {
      await _pumpComments(
        tester,
        const SizedBox(
          width: 520,
          height: 640,
          child: CommentSection(bvid: _bvid),
        ),
      );

      expect(
        find.byKey(const ValueKey('player-comment-panel')),
        findsNothing,
      );
      expect(find.byType(AppPanel), findsNothing);
      expect(find.text(_rootCommentContent), findsOneWidget);
    });
  });
}

Future<void> _pumpComments(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(const _FakeAuthRepository()),
        commentRepositoryProvider.overrideWithValue(
          const _FakeCommentRepository(),
        ),
        commentNotifierProvider(_bvid).overrideWith(
          () => _FakeCommentNotifier(_commentState),
        ),
      ],
      child: buildTestApp(
        Center(
          child: SizedBox(
            width: 520,
            height: 640,
            child: child,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

const _bvid = 'BV1overlay';
const _rootCommentContent = 'Overlay root comment';
const _replyContent = 'Overlay child reply';

const _rootComment = Comment(
  rpid: 1001,
  mid: 2001,
  username: 'Root User',
  avatarUrl: '',
  content: _rootCommentContent,
  ctime: 1710000000,
  likeCount: 7,
  replyCount: 1,
);

const _reply = Comment(
  rpid: 1002,
  mid: 2002,
  username: 'Reply User',
  avatarUrl: '',
  content: _replyContent,
  ctime: 1710000010,
  likeCount: 1,
  replyCount: 0,
);

const _commentState = CommentState(
  aid: 123456,
  comments: [_rootComment],
  isEnd: true,
  totalCount: 1,
);

class _FakeCommentNotifier extends CommentNotifier {
  _FakeCommentNotifier(this.commentState);

  final CommentState commentState;

  @override
  Future<CommentState> build(String bvid) async => commentState;
}

class _FakeAuthRepository implements AuthRepository {
  const _FakeAuthRepository();

  @override
  Future<void> clearSession() async {}

  @override
  Future<({String qrUrl, String qrKey})> generateQrCode() async {
    return (qrUrl: 'https://example.com/qr', qrKey: 'qr-key');
  }

  @override
  Future<User?> loadSession() async => null;

  @override
  Future<QrPollResult> pollQrStatus(String qrKey) async {
    return const QrPollResult(code: 86101, message: 'not scanned');
  }

  @override
  Future<User?> refreshSession() async => null;

  @override
  Future<User?> loginWithCookies({
    required String sessdata,
    required String biliJct,
    String? dedeUserId,
  }) async {
    return null;
  }

  @override
  Future<void> saveSession(User user) async {}
}

class _FakeCommentRepository implements CommentRepository {
  const _FakeCommentRepository();

  @override
  Future<Comment> addComment({
    required int oid,
    required String message,
    required String csrf,
    int? root,
    int? parent,
  }) async {
    return _reply.copyWith(content: message);
  }

  @override
  Future<int> getAidByBvid(String bvid) async => 123456;

  @override
  Future<CommentPage> getComments({
    required int oid,
    int mode = 3,
    int next = 0,
    int ps = 20,
  }) async {
    return const CommentPage(
      totalCount: 1,
      next: 0,
      isEnd: true,
      replies: [_rootComment],
    );
  }

  @override
  Future<CommentPage> getReplies({
    required int oid,
    required int rootRpid,
    int page = 1,
    int ps = 20,
  }) async {
    return const CommentPage(
      totalCount: 1,
      next: 0,
      isEnd: true,
      replies: [_reply],
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
