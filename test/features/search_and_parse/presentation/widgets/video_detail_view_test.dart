import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/auth/application/auth_notifier.dart';
import 'package:busic/features/auth/data/auth_repository.dart';
import 'package:busic/features/auth/domain/models/qr_poll_result.dart';
import 'package:busic/features/auth/domain/models/user.dart';
import 'package:busic/features/comment/application/comment_notifier.dart';
import 'package:busic/features/comment/domain/models/comment.dart';
import 'package:busic/features/search_and_parse/application/parse_notifier.dart';
import 'package:busic/features/search_and_parse/application/video_favorite_folders_provider.dart';
import 'package:busic/features/search_and_parse/application/video_interaction_notifier.dart';
import 'package:busic/features/search_and_parse/data/video_interaction_repository.dart';
import 'package:busic/features/search_and_parse/domain/models/bili_fav_folder.dart';
import 'package:busic/features/search_and_parse/domain/models/bvid_info.dart';
import 'package:busic/features/search_and_parse/domain/models/page_info.dart';
import 'package:busic/features/search_and_parse/domain/models/video_interaction_state.dart';
import 'package:busic/features/search_and_parse/domain/models/video_rights.dart';
import 'package:busic/features/search_and_parse/domain/models/video_stats.dart';
import 'package:busic/features/search_and_parse/domain/models/video_tag.dart';
import 'package:busic/features/search_and_parse/presentation/widgets/video_detail_view.dart';

import '../../../../test_helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VideoDetailView', () {
    testWidgets('makes video text and comment content selectable',
        (tester) async {
      _setDesktopViewport(tester);

      await _pumpVideoDetail(
        tester,
        interactionRepository: _FakeVideoInteractionRepository(),
        parseState: const ParseState.success(_video),
        commentState: _commentStateWithItems,
      );

      _expectTextInSelectionArea(_video.title);
      _expectTextInSelectionArea(_video.description);
      _expectTextInInkWell(_video.bvid);

      final commentTab = find.descendant(
        of: find.byType(TabBar),
        matching: find.text('Comments 17'),
      );

      await tester.tap(commentTab);
      await tester.pumpAndSettle();

      _expectTextInSelectionArea('Comment 0');
    });

    testWidgets('桌面布局下封面收窄且随简介滚动上移', (tester) async {
      _setDesktopViewport(tester);

      await _pumpVideoDetail(
        tester,
        interactionRepository: _FakeVideoInteractionRepository(),
        parseState: const ParseState.success(_video),
      );

      final cover = find.byKey(const ValueKey('video-detail-cover'));
      final initialTop = tester.getTopLeft(cover).dy;
      final coverSize = tester.getSize(cover);

      expect(coverSize.width, lessThanOrEqualTo(680));
      expect(coverSize.height, lessThan(390));

      await tester.drag(find.byType(NestedScrollView), const Offset(0, -180));
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(cover).dy, lessThan(initialTop));
    });

    testWidgets('评论页滚动时封面也会跟随上移', (tester) async {
      _setDesktopViewport(tester);

      await _pumpVideoDetail(
        tester,
        interactionRepository: _FakeVideoInteractionRepository(),
        parseState: const ParseState.success(_video),
        commentState: _commentStateWithItems,
      );

      final cover = find.byKey(const ValueKey('video-detail-cover'));
      final initialTop = tester.getTopLeft(cover).dy;
      final commentTab = find.descendant(
        of: find.byType(TabBar),
        matching: find.text('Comments 17'),
      );

      await tester.tap(commentTab);
      await tester.pumpAndSettle();
      await tester.drag(find.text('Comment 0'), const Offset(0, -180));
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(cover).dy, lessThan(initialTop));
    });

    testWidgets('桌面布局下返回按钮位于封面外侧左上角', (tester) async {
      _setDesktopViewport(tester);
      var didBack = false;

      await _pumpVideoDetail(
        tester,
        interactionRepository: _FakeVideoInteractionRepository(),
        parseState: const ParseState.success(_video),
        showBackButton: true,
        onBack: () => didBack = true,
      );

      final cover = find.byKey(const ValueKey('video-detail-cover'));
      final backButton = find.widgetWithIcon(
        IconButton,
        Icons.arrow_back_rounded,
      );
      final coverRect = tester.getRect(cover);
      final backRect = tester.getRect(backButton);

      expect(backButton, findsOneWidget);
      expect(backRect.right, lessThan(coverRect.left));
      expect((backRect.top - coverRect.top).abs(), lessThanOrEqualTo(1));

      await tester.tap(backButton);
      expect(didBack, isTrue);

      final initialTop = backRect.top;
      await tester.drag(find.byType(NestedScrollView), const Offset(0, -180));
      await tester.pumpAndSettle();

      expect(tester.getRect(backButton).top, lessThan(initialTop));
    });

    testWidgets('渲染 B 站式简介页结构和返回按钮', (tester) async {
      var didBack = false;
      final repository = _FakeVideoInteractionRepository(
        initialState: const VideoInteractionState(
          isLiked: true,
          coinsGiven: 1,
        ),
      );

      await _pumpVideoDetail(
        tester,
        interactionRepository: repository,
        parseState: const ParseState.success(_video),
        showBackButton: true,
        onBack: () => didBack = true,
      );

      expect(find.text('Intro'), findsOneWidget);
      expect(find.text('Comments 17'), findsAtLeastNWidgets(1));
      expect(find.text(_video.title), findsOneWidget);
      expect(find.text('BuSic UP'), findsOneWidget);
      expect(find.text('UID 42 / Music'), findsOneWidget);
      expect(find.text('vocal'), findsOneWidget);
      expect(find.text('Liked'), findsOneWidget);
      expect(find.text('1 coined'), findsOneWidget);

      await tester.tap(
        find.widgetWithIcon(IconButton, Icons.arrow_back_rounded),
      );
      expect(didBack, isTrue);
    });

    testWidgets('多 P 状态展示分 P 选择和已选数量', (tester) async {
      await _pumpVideoDetail(
        tester,
        interactionRepository: _FakeVideoInteractionRepository(),
        parseState: ParseState.selectingPages(
          _multiPageVideo,
          [_multiPageVideo.pages.first],
        ),
      );

      expect(find.text('Select Pages'), findsOneWidget);
      expect(find.text('Selected 1/2 pages'), findsOneWidget);
      expect(find.text('P1 Opening'), findsOneWidget);
      expect(find.text('P2 Ending'), findsOneWidget);
    });

    testWidgets('收藏按钮选择 B 站收藏夹并调用互动 Notifier', (tester) async {
      final repository = _FakeVideoInteractionRepository();

      await _pumpVideoDetail(
        tester,
        interactionRepository: repository,
        parseState: const ParseState.success(_video),
        favoriteFolders: const [
          BiliFavFolder(id: 789, title: 'Stage Folder', mediaCount: 12),
        ],
      );

      await tester.drag(find.byType(NestedScrollView), const Offset(0, -420));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Favorite'));
      await tester.pumpAndSettle();

      expect(find.text('Stage Folder'), findsOneWidget);

      await tester.tap(find.text('Stage Folder'));
      await tester.pumpAndSettle();

      expect(repository.addFavoriteCalls.single,
          (aid: _aid, mediaId: 789, csrf: _csrf));
    });
  });
}

Future<void> _pumpVideoDetail(
  WidgetTester tester, {
  required _FakeVideoInteractionRepository interactionRepository,
  required ParseState parseState,
  bool showBackButton = false,
  VoidCallback? onBack,
  List<BiliFavFolder>? favoriteFolders,
  CommentState? commentState,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: _overrides(
        interactionRepository: interactionRepository,
        favoriteFolders: favoriteFolders,
        commentState: commentState,
      ),
      child: buildTestApp(
        VideoDetailView(
          parseState: parseState,
          showBackButton: showBackButton,
          onBack: onBack,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void _setDesktopViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1000, 800);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
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

void _expectTextInInkWell(String text) {
  final textFinder = find.text(text);

  expect(textFinder, findsOneWidget);
  expect(
    find.ancestor(
      of: textFinder,
      matching: find.byType(InkWell),
    ),
    findsOneWidget,
  );
}

const _aid = 123456;
const _bvid = 'BV1xx411c7mD';
const _csrf = 'csrf-token';

const _page = PageInfo(
  cid: 1001,
  page: 1,
  partTitle: 'Main',
  duration: 245,
);

const _video = BvidInfo(
  bvid: _bvid,
  aid: _aid,
  title: 'Night Drive Live Performance',
  description: 'A long description for the parsed Bilibili video.',
  pubdate: 1710000000,
  tname: 'Music',
  owner: 'BuSic UP',
  ownerUid: 42,
  pages: [_page],
  duration: 245,
  stats: VideoStats(
    view: 1234,
    danmaku: 56,
    reply: 17,
    favorite: 8,
    coin: 9,
    share: 10,
    like: 11,
  ),
  rights: VideoRights(noReprint: true),
  tags: [VideoTag(id: 1, name: 'vocal')],
);

const _multiPageVideo = BvidInfo(
  bvid: _bvid,
  aid: _aid,
  title: 'Concert Set',
  owner: 'BuSic UP',
  pages: [
    PageInfo(cid: 2001, page: 1, partTitle: 'Opening', duration: 90),
    PageInfo(cid: 2002, page: 2, partTitle: 'Ending', duration: 120),
  ],
  duration: 210,
);

final _commentStateWithItems = CommentState(
  aid: _aid,
  comments: List.generate(
    24,
    (index) => Comment(
      rpid: 10000 + index,
      mid: 20000 + index,
      username: 'User $index',
      avatarUrl: '',
      content: 'Comment $index',
      ctime: 1710000000,
      likeCount: index,
      replyCount: 0,
    ),
  ),
  isEnd: true,
  totalCount: 24,
);

List<Override> _overrides({
  required _FakeVideoInteractionRepository interactionRepository,
  List<BiliFavFolder>? favoriteFolders,
  CommentState? commentState,
}) {
  return [
    authRepositoryProvider.overrideWithValue(_FakeAuthRepository.loggedIn()),
    videoInteractionRepositoryProvider.overrideWithValue(interactionRepository),
    commentNotifierProvider(_bvid).overrideWith(
      () => _FakeCommentNotifier(commentState ?? const CommentState()),
    ),
    if (favoriteFolders != null)
      videoFavoriteFoldersProvider.overrideWith((ref) async => favoriteFolders),
  ];
}

const _user = User(
  userId: '42',
  nickname: '测试用户',
  sessdata: 'sess-token',
  biliJct: _csrf,
  isLoggedIn: true,
);

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository.loggedIn() : refreshResults = [_user];

  final List<User?> refreshResults;

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
    return const QrPollResult(code: 86101, message: '未扫码');
  }

  @override
  Future<User?> refreshSession() async {
    if (refreshResults.isEmpty) return null;
    return refreshResults.removeAt(0);
  }

  @override
  Future<void> saveSession(User user) async {}
}

class _FakeCommentNotifier extends CommentNotifier {
  _FakeCommentNotifier(this.commentState);

  final CommentState commentState;

  @override
  Future<CommentState> build(String bvid) async {
    return commentState;
  }
}

class _FakeVideoInteractionRepository implements VideoInteractionRepository {
  _FakeVideoInteractionRepository({
    this.initialState = const VideoInteractionState(),
  });

  final VideoInteractionState initialState;

  final List<({int aid, String bvid})> getStateCalls = [];
  final List<({int aid, bool like, String csrf})> setLikeCalls = [];
  final List<({int aid, int multiply, bool alsoLike, String csrf})>
      addCoinCalls = [];
  final List<({int aid, int mediaId, String csrf})> addFavoriteCalls = [];
  final List<({int aid, String bvid, String csrf})> recordShareCalls = [];

  @override
  Future<void> addCoin({
    required int aid,
    required int multiply,
    required bool alsoLike,
    required String csrf,
  }) async {
    addCoinCalls.add((
      aid: aid,
      multiply: multiply,
      alsoLike: alsoLike,
      csrf: csrf,
    ));
  }

  @override
  Future<void> addToFavoriteFolder({
    required int aid,
    required int mediaId,
    required String csrf,
  }) async {
    addFavoriteCalls.add((aid: aid, mediaId: mediaId, csrf: csrf));
  }

  @override
  Future<VideoInteractionState> getInteractionState({
    required int aid,
    required String bvid,
  }) async {
    getStateCalls.add((aid: aid, bvid: bvid));
    return initialState;
  }

  @override
  Future<void> recordShare({
    required int aid,
    required String bvid,
    required String csrf,
  }) async {
    recordShareCalls.add((aid: aid, bvid: bvid, csrf: csrf));
  }

  @override
  Future<void> setLike({
    required int aid,
    required bool like,
    required String csrf,
  }) async {
    setLikeCalls.add((aid: aid, like: like, csrf: csrf));
  }
}
