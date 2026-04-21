import 'package:flutter_riverpod/flutter_riverpod.dart';
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

      final notifier =
          container.read(subtitleNotifierProvider('BVloaded', 1).notifier);
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
  });
}

Future<void> _settle() async {
  await Future<void>.delayed(const Duration(milliseconds: 20));
}

class _FakeSubtitleRepository implements SubtitleRepository {
  _FakeSubtitleRepository({
    this.result,
    this.error,
  });

  final SubtitleData? result;
  final Object? error;

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
    if (error != null) {
      throw error!;
    }
    return result;
  }
}
