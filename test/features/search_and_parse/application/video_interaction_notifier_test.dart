import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/auth/application/auth_notifier.dart';
import 'package:busic/features/auth/data/auth_repository.dart';
import 'package:busic/features/auth/domain/models/qr_poll_result.dart';
import 'package:busic/features/auth/domain/models/user.dart';
import 'package:busic/features/search_and_parse/application/video_interaction_notifier.dart';
import 'package:busic/features/search_and_parse/data/video_interaction_exception.dart';
import 'package:busic/features/search_and_parse/data/video_interaction_repository.dart';
import 'package:busic/features/search_and_parse/domain/models/video_interaction_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VideoInteractionNotifier', () {
    test('未登录时返回默认状态且不读取互动仓储', () async {
      final repository = _FakeVideoInteractionRepository();
      final container = _createContainer(
        authRepository: _FakeAuthRepository(loadSessionResult: null),
        interactionRepository: repository,
      );
      addTearDown(container.dispose);
      final provider = videoInteractionNotifierProvider(_bvid, _aid);
      final subscription = container.listen(provider, (_, __) {});
      addTearDown(subscription.close);

      final state = await container.read(provider.future);

      expect(state, const VideoInteractionState());
      expect(repository.getStateCalls, isEmpty);
    });

    test('已登录 build 会加载当前互动状态', () async {
      final repository = _FakeVideoInteractionRepository(
        initialState: const VideoInteractionState(
          isLiked: true,
          isFavorited: true,
          coinsGiven: 1,
        ),
      );
      final container = _createContainer(
        authRepository: _FakeAuthRepository.loggedIn(),
        interactionRepository: repository,
      );
      addTearDown(container.dispose);
      final provider = videoInteractionNotifierProvider(_bvid, _aid);
      final subscription = container.listen(provider, (_, __) {});
      addTearDown(subscription.close);

      final state = await container.read(provider.future);

      expect(state.isLiked, isTrue);
      expect(state.isFavorited, isTrue);
      expect(state.coinsGiven, 1);
      expect(repository.getStateCalls.single, (aid: _aid, bvid: _bvid));
    });

    test('点赞成功会更新状态并携带 csrf', () async {
      final repository = _FakeVideoInteractionRepository();
      final container = _createContainer(
        authRepository: _FakeAuthRepository.loggedIn(),
        interactionRepository: repository,
      );
      addTearDown(container.dispose);
      final provider = videoInteractionNotifierProvider(_bvid, _aid);
      final subscription = container.listen(provider, (_, __) {});
      addTearDown(subscription.close);
      await container.read(provider.future);

      final result = await container.read(provider.notifier).toggleLike();

      final state = container.read(provider).valueOrNull;
      expect(result, isTrue);
      expect(state?.isLiked, isTrue);
      expect(state?.isBusy, isFalse);
      expect(state?.lastError, isNull);
      expect(
        repository.setLikeCalls.single,
        (aid: _aid, like: true, csrf: _csrf),
      );
    });

    test('点赞失败会回滚并写入 lastError', () async {
      final repository = _FakeVideoInteractionRepository(
        initialState: const VideoInteractionState(isLiked: true),
        setLikeError: const VideoInteractionException(65004, '取消赞失败'),
      );
      final container = _createContainer(
        authRepository: _FakeAuthRepository.loggedIn(),
        interactionRepository: repository,
      );
      addTearDown(container.dispose);
      final provider = videoInteractionNotifierProvider(_bvid, _aid);
      final subscription = container.listen(provider, (_, __) {});
      addTearDown(subscription.close);
      await container.read(provider.future);

      final result = await container.read(provider.notifier).toggleLike();

      final state = container.read(provider).valueOrNull;
      expect(result, isFalse);
      expect(state?.isLiked, isTrue);
      expect(state?.isBusy, isFalse);
      expect(state?.lastError, '取消赞失败');
    });

    test('投币成功会更新投币数并同步点赞态', () async {
      final repository = _FakeVideoInteractionRepository();
      final container = _createContainer(
        authRepository: _FakeAuthRepository.loggedIn(),
        interactionRepository: repository,
      );
      addTearDown(container.dispose);
      final provider = videoInteractionNotifierProvider(_bvid, _aid);
      final subscription = container.listen(provider, (_, __) {});
      addTearDown(subscription.close);
      await container.read(provider.future);

      final result = await container
          .read(provider.notifier)
          .addCoin(multiply: 2, alsoLike: true);

      final state = container.read(provider).valueOrNull;
      expect(result, isTrue);
      expect(state?.coinsGiven, 2);
      expect(state?.isLiked, isTrue);
      expect(state?.isBusy, isFalse);
      expect(
        repository.addCoinCalls.single,
        (aid: _aid, multiply: 2, alsoLike: true, csrf: _csrf),
      );
    });

    test('收藏成功会更新收藏态', () async {
      final repository = _FakeVideoInteractionRepository();
      final container = _createContainer(
        authRepository: _FakeAuthRepository.loggedIn(),
        interactionRepository: repository,
      );
      addTearDown(container.dispose);
      final provider = videoInteractionNotifierProvider(_bvid, _aid);
      final subscription = container.listen(provider, (_, __) {});
      addTearDown(subscription.close);
      await container.read(provider.future);

      final result =
          await container.read(provider.notifier).addToFavoriteFolder(789);

      final state = container.read(provider).valueOrNull;
      expect(result, isTrue);
      expect(state?.isFavorited, isTrue);
      expect(state?.isBusy, isFalse);
      expect(
        repository.addFavoriteCalls.single,
        (aid: _aid, mediaId: 789, csrf: _csrf),
      );
    });

    test('分享记录失败不抛出并保留错误态', () async {
      final repository = _FakeVideoInteractionRepository(
        recordShareError: const VideoInteractionException(-101, '账号未登录'),
      );
      final container = _createContainer(
        authRepository: _FakeAuthRepository.loggedIn(),
        interactionRepository: repository,
      );
      addTearDown(container.dispose);
      final provider = videoInteractionNotifierProvider(_bvid, _aid);
      final subscription = container.listen(provider, (_, __) {});
      addTearDown(subscription.close);
      await container.read(provider.future);

      final result = await container.read(provider.notifier).recordShare();

      final state = container.read(provider).valueOrNull;
      expect(result, isFalse);
      expect(state?.isBusy, isFalse);
      expect(state?.lastError, '账号未登录');
      expect(
        repository.recordShareCalls.single,
        (aid: _aid, bvid: _bvid, csrf: _csrf),
      );
    });
  });
}

const _aid = 123456;
const _bvid = 'BV1xx411c7mD';
const _csrf = 'csrf-token';
const _user = User(
  userId: '42',
  nickname: '测试用户',
  sessdata: 'sess-token',
  biliJct: _csrf,
  isLoggedIn: true,
);

ProviderContainer _createContainer({
  required AuthRepository authRepository,
  required VideoInteractionRepository interactionRepository,
}) {
  return ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      videoInteractionRepositoryProvider.overrideWithValue(
        interactionRepository,
      ),
    ],
  );
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    required this.loadSessionResult,
    List<User?> refreshResults = const [],
  }) : refreshResults = List.of(refreshResults);

  _FakeAuthRepository.loggedIn()
      : loadSessionResult = _user,
        refreshResults = [_user];

  final User? loadSessionResult;
  final List<User?> refreshResults;

  @override
  Future<void> clearSession() async {}

  @override
  Future<({String qrUrl, String qrKey})> generateQrCode() async {
    return (qrUrl: 'https://example.com/qr', qrKey: 'qr-key');
  }

  @override
  Future<User?> loadSession() async {
    return loadSessionResult;
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

class _FakeVideoInteractionRepository implements VideoInteractionRepository {
  _FakeVideoInteractionRepository({
    this.initialState = const VideoInteractionState(),
    this.setLikeError,
    this.recordShareError,
  });

  final VideoInteractionState initialState;
  final Object? setLikeError;
  final Object? recordShareError;

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
    if (recordShareError != null) throw recordShareError!;
  }

  @override
  Future<void> setLike({
    required int aid,
    required bool like,
    required String csrf,
  }) async {
    setLikeCalls.add((aid: aid, like: like, csrf: csrf));
    if (setLikeError != null) throw setLikeError!;
  }
}
