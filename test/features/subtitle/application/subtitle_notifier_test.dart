import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/subtitle/application/subtitle_notifier.dart';
import 'package:busic/features/subtitle/data/subtitle_repository.dart';
import 'package:busic/features/subtitle/data/subtitle_repository_impl.dart';
import 'package:busic/features/subtitle/domain/models/subtitle_data.dart';
import 'package:busic/features/subtitle/domain/models/subtitle_line.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SubtitleNotifier', () {
    test('加载成功后会更新状态，并按播放位置高亮歌词行', () async {
      final repository = _FakeSubtitleRepository(
        result: const SubtitleData(
          lines: [
            SubtitleLine(
              startTime: 0.0,
              endTime: 2.0,
              content: '第一句',
              musicRatio: 0.0,
            ),
            SubtitleLine(
              startTime: 2.0,
              endTime: 4.0,
              content: '第二句',
              musicRatio: 0.0,
            ),
          ],
          sourceType: 'ai',
          language: 'ai-zh',
        ),
      );
      final container = ProviderContainer(
        overrides: [
          subtitleRepositoryProvider.overrideWithValue(repository),
          subtitleCurrentTrackKeyProvider.overrideWithValue((
            bvid: 'BVloaded',
            cid: 1,
          )),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        subtitleNotifierProvider('BVloaded', 1),
        (_, __) {},
      );
      addTearDown(subscription.close);

      final initial = container.read(subtitleNotifierProvider('BVloaded', 1));
      expect(initial.status, SubtitleLoadStatus.loading);

      await _settle();

      final loaded = container.read(subtitleNotifierProvider('BVloaded', 1));
      expect(loaded.status, SubtitleLoadStatus.loaded);
      expect(loaded.subtitleData?.lines, hasLength(2));

      final notifier = container.read(
        subtitleNotifierProvider('BVloaded', 1).notifier,
      );
      notifier.updatePosition(const Duration(milliseconds: 1200));
      expect(
        container
            .read(subtitleNotifierProvider('BVloaded', 1))
            .currentLineIndex,
        0,
      );

      notifier.updatePosition(const Duration(milliseconds: 4500));
      expect(
        container
            .read(subtitleNotifierProvider('BVloaded', 1))
            .currentLineIndex,
        -1,
      );
    });

    test('仓储返回 null 时标记为 notFound', () async {
      final container = ProviderContainer(
        overrides: [
          subtitleRepositoryProvider.overrideWithValue(
            _FakeSubtitleRepository(result: null),
          ),
          subtitleCurrentTrackKeyProvider.overrideWithValue((
            bvid: 'BVempty',
            cid: 2,
          )),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        subtitleNotifierProvider('BVempty', 2),
        (_, __) {},
      );
      addTearDown(subscription.close);

      container.read(subtitleNotifierProvider('BVempty', 2));
      await _settle();

      final state = container.read(subtitleNotifierProvider('BVempty', 2));
      expect(state.status, SubtitleLoadStatus.notFound);
      expect(state.subtitleData, isNull);
    });

    test('登录异常会映射为 login_required 错误码', () async {
      final container = ProviderContainer(
        overrides: [
          subtitleRepositoryProvider.overrideWithValue(
            _FakeSubtitleRepository(
              error: const SubtitleLoginRequiredException(),
            ),
          ),
          subtitleCurrentTrackKeyProvider.overrideWithValue((
            bvid: 'BVlogin',
            cid: 3,
          )),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        subtitleNotifierProvider('BVlogin', 3),
        (_, __) {},
      );
      addTearDown(subscription.close);

      container.read(subtitleNotifierProvider('BVlogin', 3));
      await _settle();

      final state = container.read(subtitleNotifierProvider('BVlogin', 3));
      expect(state.status, SubtitleLoadStatus.error);
      expect(state.errorMessage, SubtitleNotifier.loginRequiredErrorCode);
    });

    test('其他异常会映射为普通 error 状态', () async {
      final container = ProviderContainer(
        overrides: [
          subtitleRepositoryProvider.overrideWithValue(
            _FakeSubtitleRepository(error: StateError('boom')),
          ),
          subtitleCurrentTrackKeyProvider.overrideWithValue((
            bvid: 'BVerror',
            cid: 4,
          )),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        subtitleNotifierProvider('BVerror', 4),
        (_, __) {},
      );
      addTearDown(subscription.close);

      container.read(subtitleNotifierProvider('BVerror', 4));
      await _settle();

      final state = container.read(subtitleNotifierProvider('BVerror', 4));
      expect(state.status, SubtitleLoadStatus.error);
      expect(state.errorMessage, contains('boom'));
    });

    test('同一曲目重新订阅时保留终态，切歌后允许重新获取', () async {
      final repository = _FakeSubtitleRepository(result: null);
      final currentTrackProvider = StateProvider<SubtitleTrackKey?>(
        (ref) => (bvid: 'BVterminal', cid: 5),
      );
      final container = ProviderContainer(
        overrides: [
          subtitleRepositoryProvider.overrideWithValue(repository),
          subtitleCurrentTrackKeyProvider.overrideWith(
            (ref) => ref.watch(currentTrackProvider),
          ),
        ],
      );
      addTearDown(container.dispose);

      var subscription = container.listen(
        subtitleNotifierProvider('BVterminal', 5),
        (_, __) {},
      );
      await _settle();
      expect(repository.callCount, 1);
      expect(
        container.read(subtitleNotifierProvider('BVterminal', 5)).status,
        SubtitleLoadStatus.notFound,
      );

      subscription.close();
      await _settle();
      subscription = container.listen(
        subtitleNotifierProvider('BVterminal', 5),
        (_, __) {},
      );
      expect(repository.callCount, 1);
      expect(
        container.read(subtitleNotifierProvider('BVterminal', 5)).status,
        SubtitleLoadStatus.notFound,
      );

      container.read(currentTrackProvider.notifier).state = (
        bvid: 'BVother',
        cid: 6,
      );
      await _settle();
      subscription.close();
      await _settle();
      container.read(currentTrackProvider.notifier).state = (
        bvid: 'BVterminal',
        cid: 5,
      );

      subscription = container.listen(
        subtitleNotifierProvider('BVterminal', 5),
        (_, __) {},
      );
      addTearDown(subscription.close);
      await _settle();
      expect(repository.callCount, 2);
    });

    test('错误终态可显式重试并更新为成功状态', () async {
      const data = SubtitleData(
        lines: [
          SubtitleLine(
            startTime: 0,
            endTime: 1,
            content: '重试成功',
            musicRatio: 0,
          ),
        ],
        sourceType: 'cc',
        language: 'zh-Hans',
      );
      final repository = _FakeSubtitleRepository(
        outcomes: [StateError('first failure'), data],
      );
      final container = ProviderContainer(
        overrides: [
          subtitleRepositoryProvider.overrideWithValue(repository),
          subtitleCurrentTrackKeyProvider.overrideWithValue((
            bvid: 'BVretry',
            cid: 7,
          )),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        subtitleNotifierProvider('BVretry', 7),
        (_, __) {},
      );
      addTearDown(subscription.close);
      await _settle();
      expect(
        container.read(subtitleNotifierProvider('BVretry', 7)).status,
        SubtitleLoadStatus.error,
      );

      final retry = container
          .read(subtitleNotifierProvider('BVretry', 7).notifier)
          .retry();
      expect(
        container.read(subtitleNotifierProvider('BVretry', 7)).status,
        SubtitleLoadStatus.loading,
      );
      await retry;

      final state = container.read(subtitleNotifierProvider('BVretry', 7));
      expect(state.status, SubtitleLoadStatus.loaded);
      expect(state.subtitleData, data);
      expect(repository.callCount, 2);
    });
  });
}

Future<void> _settle() async {
  await Future<void>.delayed(const Duration(milliseconds: 20));
}

class _FakeSubtitleRepository implements SubtitleRepository {
  _FakeSubtitleRepository({this.result, this.error, List<Object?>? outcomes})
    : outcomes = outcomes == null ? [] : List<Object?>.of(outcomes);

  final SubtitleData? result;
  final Object? error;
  final List<Object?> outcomes;
  int callCount = 0;

  @override
  Future<void> cacheSubtitle({
    required String bvid,
    required int cid,
    required SubtitleData data,
  }) async {}

  @override
  Future<SubtitleData?> fetchSubtitleFromApi({
    required String bvid,
    required int cid,
    int maxRetries = 10,
  }) async {
    return getSubtitle(bvid: bvid, cid: cid);
  }

  @override
  Future<SubtitleData?> getCachedSubtitle({
    required String bvid,
    required int cid,
  }) async {
    return null;
  }

  @override
  Future<SubtitleData?> getSubtitle({
    required String bvid,
    required int cid,
  }) async {
    callCount++;
    if (outcomes.isNotEmpty) {
      final outcome = outcomes.removeAt(0);
      if (outcome is Exception || outcome is Error) {
        throw outcome!;
      }
      return outcome as SubtitleData?;
    }
    if (error != null) {
      throw error!;
    }
    return result;
  }
}
