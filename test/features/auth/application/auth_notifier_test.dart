import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/auth/application/auth_notifier.dart';
import 'package:busic/features/auth/data/auth_repository.dart';
import 'package:busic/features/auth/domain/models/qr_poll_result.dart';
import 'package:busic/features/auth/domain/models/user.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthNotifier', () {
    test('build 在有本地会话时会先加载再刷新', () async {
      final repository = _FakeAuthRepository(
        loadSessionResult: const User(
          userId: '1',
          nickname: '本地用户',
          sessdata: 'sess',
          biliJct: 'csrf',
          isLoggedIn: true,
        ),
        refreshResults: [
          const User(
            userId: '1',
            nickname: '刷新用户',
            sessdata: 'sess',
            biliJct: 'csrf',
            isLoggedIn: true,
          ),
        ],
      );
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final subscription = _listenAuth(container);
      addTearDown(subscription.close);

      final user = await container.read(authNotifierProvider.future);

      expect(user?.nickname, '刷新用户');
      expect(repository.loadSessionCallCount, 1);
      expect(repository.refreshSessionCallCount, 1);
    });

    test('build 在没有本地会话时返回 null', () async {
      final repository = _FakeAuthRepository(loadSessionResult: null);
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final subscription = _listenAuth(container);
      addTearDown(subscription.close);

      final user = await container.read(authNotifierProvider.future);

      expect(user, isNull);
      expect(repository.refreshSessionCallCount, 0);
    });

    test('loginWithCookie 成功时会保存并暴露刷新后的用户', () async {
      final repository = _FakeAuthRepository(
        loadSessionResult: null,
        refreshResults: [
          const User(
            userId: '42',
            nickname: '刷新成功',
            sessdata: 'sess-cookie',
            biliJct: 'csrf-cookie',
            isLoggedIn: true,
          ),
        ],
      );
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final subscription = _listenAuth(container);
      addTearDown(subscription.close);

      await container.read(authNotifierProvider.future);
      await container.read(authNotifierProvider.notifier).loginWithCookie(
            sessdata: 'sess-cookie',
            biliJct: 'csrf-cookie',
            dedeUserId: '42',
          );

      expect(repository.savedSessions, hasLength(1));
      expect(repository.savedSessions.single.userId, '42');
      expect(
        container.read(authNotifierProvider).valueOrNull?.nickname,
        '刷新成功',
      );
    });

    test('loginWithCookie 失败时会清理会话并抛错', () async {
      final repository = _FakeAuthRepository(
        loadSessionResult: null,
        refreshResults: [null],
      );
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final subscription = _listenAuth(container);
      addTearDown(subscription.close);

      await container.read(authNotifierProvider.future);

      await expectLater(
        () => container.read(authNotifierProvider.notifier).loginWithCookie(
              sessdata: 'bad-sess',
              biliJct: 'bad-csrf',
              dedeUserId: '404',
            ),
        throwsException,
      );
      expect(repository.clearSessionCallCount, 1);
    });

    test('login 轮询到 86090 和 86038 时会触发扫码与过期回调', () async {
      final repository = _FakeAuthRepository(
        loadSessionResult: null,
        pollResults: [
          const QrPollResult(code: 86090, message: '已扫码'),
          const QrPollResult(code: 86038, message: '二维码失效'),
        ],
      );
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final subscription = _listenAuth(container);
      addTearDown(subscription.close);

      await container.read(authNotifierProvider.future);

      var scannedCount = 0;
      var expiredCount = 0;
      final qrUrl = await container.read(authNotifierProvider.notifier).login(
            onScanned: () => scannedCount++,
            onExpired: () => expiredCount++,
          );
      await _waitForPolling();

      expect(qrUrl, 'https://example.com/qr');
      expect(scannedCount, 1);
      expect(expiredCount, 1);
      expect(container.read(authNotifierProvider).valueOrNull, isNull);
    });

    test('login 轮询成功后会解析 URL、保存会话并更新状态', () async {
      final repository = _FakeAuthRepository(
        loadSessionResult: null,
        pollResults: [
          const QrPollResult(
            code: 0,
            message: '成功',
            url:
                'https://passport.example.com/callback?DedeUserID=99&SESSDATA=saved-sess&bili_jct=saved-csrf',
          ),
        ],
        refreshResults: [
          const User(
            userId: '99',
            nickname: '扫码登录成功',
            sessdata: 'saved-sess',
            biliJct: 'saved-csrf',
            isLoggedIn: true,
          ),
        ],
      );
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final subscription = _listenAuth(container);
      addTearDown(subscription.close);

      await container.read(authNotifierProvider.future);
      await container.read(authNotifierProvider.notifier).login();
      await _waitForPolling();

      expect(repository.savedSessions, hasLength(1));
      expect(repository.savedSessions.single.userId, '99');
      expect(repository.savedSessions.single.sessdata, 'saved-sess');
      expect(
        container.read(authNotifierProvider).valueOrNull?.nickname,
        '扫码登录成功',
      );
    });

    test('logout 会清理仓储并把状态重置为 null', () async {
      final repository = _FakeAuthRepository(
        loadSessionResult: const User(
          userId: '7',
          nickname: '待退出用户',
          sessdata: 'sess',
          biliJct: 'csrf',
          isLoggedIn: true,
        ),
        refreshResults: [
          const User(
            userId: '7',
            nickname: '待退出用户',
            sessdata: 'sess',
            biliJct: 'csrf',
            isLoggedIn: true,
          ),
        ],
      );
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final subscription = _listenAuth(container);
      addTearDown(subscription.close);

      await container.read(authNotifierProvider.future);
      await container.read(authNotifierProvider.notifier).logout();

      expect(repository.clearSessionCallCount, 1);
      expect(container.read(authNotifierProvider).valueOrNull, isNull);
    });

    test('checkSession 刷新成功时会更新当前用户', () async {
      final repository = _FakeAuthRepository(
        loadSessionResult: const User(
          userId: '8',
          nickname: '旧昵称',
          sessdata: 'sess',
          biliJct: 'csrf',
          isLoggedIn: true,
        ),
        refreshResults: [
          const User(
            userId: '8',
            nickname: '构建刷新',
            sessdata: 'sess',
            biliJct: 'csrf',
            isLoggedIn: true,
          ),
          const User(
            userId: '8',
            nickname: 'checkSession 刷新',
            sessdata: 'sess',
            biliJct: 'csrf',
            isLoggedIn: true,
          ),
        ],
      );
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final subscription = _listenAuth(container);
      addTearDown(subscription.close);

      await container.read(authNotifierProvider.future);
      await container.read(authNotifierProvider.notifier).checkSession();

      expect(
        container.read(authNotifierProvider).valueOrNull?.nickname,
        'checkSession 刷新',
      );
    });

    test('checkSession 失败时会把状态清空', () async {
      final repository = _FakeAuthRepository(
        loadSessionResult: const User(
          userId: '9',
          nickname: '旧用户',
          sessdata: 'sess',
          biliJct: 'csrf',
          isLoggedIn: true,
        ),
        refreshResults: [
          const User(
            userId: '9',
            nickname: '构建刷新',
            sessdata: 'sess',
            biliJct: 'csrf',
            isLoggedIn: true,
          ),
          null,
        ],
      );
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final subscription = _listenAuth(container);
      addTearDown(subscription.close);

      await container.read(authNotifierProvider.future);
      await container.read(authNotifierProvider.notifier).checkSession();

      expect(container.read(authNotifierProvider).valueOrNull, isNull);
    });
  });
}

ProviderContainer _createContainer(_FakeAuthRepository repository) {
  return ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(repository),
      authQrPollIntervalProvider.overrideWithValue(
        const Duration(milliseconds: 10),
      ),
    ],
  );
}

Future<void> _waitForPolling() async {
  await Future<void>.delayed(const Duration(milliseconds: 150));
}

ProviderSubscription<AsyncValue<User?>> _listenAuth(
  ProviderContainer container,
) {
  return container.listen(authNotifierProvider, (_, __) {});
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    required this.loadSessionResult,
    this.refreshResults = const [],
    this.pollResults = const [],
  });

  final User? loadSessionResult;
  final List<User?> refreshResults;
  final List<QrPollResult> pollResults;

  int loadSessionCallCount = 0;
  int refreshSessionCallCount = 0;
  int clearSessionCallCount = 0;
  final List<User> savedSessions = [];

  @override
  Future<void> clearSession() async {
    clearSessionCallCount++;
  }

  @override
  Future<({String qrUrl, String qrKey})> generateQrCode() async {
    return (
      qrUrl: 'https://example.com/qr',
      qrKey: 'qr-key',
    );
  }

  @override
  Future<User?> loadSession() async {
    loadSessionCallCount++;
    return loadSessionResult;
  }

  @override
  Future<QrPollResult> pollQrStatus(String qrKey) async {
    if (pollResults.isEmpty) {
      return const QrPollResult(code: 86101, message: '未扫码');
    }
    return pollResults.removeAt(0);
  }

  @override
  Future<User?> refreshSession() async {
    refreshSessionCallCount++;
    if (refreshResults.isEmpty) return null;
    return refreshResults.removeAt(0);
  }

  @override
  Future<void> saveSession(User user) async {
    savedSessions.add(user);
  }
}
