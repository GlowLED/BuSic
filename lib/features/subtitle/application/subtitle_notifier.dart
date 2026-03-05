import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/utils/logger.dart';
import '../../auth/application/auth_notifier.dart';
import '../data/subtitle_repository_impl.dart';
import '../domain/models/subtitle_data.dart';

part 'subtitle_notifier.g.dart';

/// Loading status for subtitle data.
enum SubtitleLoadStatus {
  /// Idle / not yet requested.
  idle,

  /// Currently fetching subtitles.
  loading,

  /// Subtitles loaded successfully.
  loaded,

  /// No subtitles available (retries exhausted or video has none).
  notFound,

  /// An error occurred during fetching.
  error,
}

/// State notifier for subtitle/lyrics data of a specific video.
///
/// Uses family parameters `(bvid, cid)` so each video gets its own
/// independent subtitle instance with automatic disposal.
@riverpod
class SubtitleNotifier extends _$SubtitleNotifier {
  static const String loginRequiredErrorCode = 'login_required';

  @override
  ({
    SubtitleData? subtitleData,
    int currentLineIndex,
    SubtitleLoadStatus status,
    String? errorMessage,
  }) build(String bvid, int cid) {
    // Trigger async loading
    _loadSubtitle();
    return (
      subtitleData: null,
      currentLineIndex: -1,
      status: SubtitleLoadStatus.loading,
      errorMessage: null,
    );
  }

  Future<void> _loadSubtitle() async {
    final link = ref.keepAlive();
    try {
      final repo = SubtitleRepositoryImpl(
        biliDio: BiliDio(),
        db: ref.read(databaseProvider),
      );

      final data = await repo.getSubtitle(bvid: bvid, cid: cid);
      if (data != null) {
        state = (
          subtitleData: data,
          currentLineIndex: -1,
          status: SubtitleLoadStatus.loaded,
          errorMessage: null,
        );
      } else {
        state = (
          subtitleData: null,
          currentLineIndex: -1,
          status: SubtitleLoadStatus.notFound,
          errorMessage: null,
        );
      }
    } on SubtitleLoginRequiredException {
      state = (
        subtitleData: null,
        currentLineIndex: -1,
        status: SubtitleLoadStatus.error,
        errorMessage: loginRequiredErrorCode,
      );
    } catch (e) {
      AppLogger.error(
        'Failed to load subtitle for $bvid:$cid',
        tag: 'Subtitle',
        error: e,
      );
      state = (
        subtitleData: null,
        currentLineIndex: -1,
        status: SubtitleLoadStatus.error,
        errorMessage: e.toString(),
      );
    } finally {
      link.close();
    }
  }

  /// Update the currently highlighted line based on playback position.
  ///
  /// Should be called by the UI whenever the player position changes.
  void updatePosition(Duration position) {
    final data = state.subtitleData;
    if (data == null) return;

    final posSeconds = position.inMilliseconds / 1000.0;
    final lines = data.lines;

    // Linear scan (lines are sorted, count is small, ~50–200)
    var index = -1;
    for (var i = 0; i < lines.length; i++) {
      if (posSeconds >= lines[i].startTime &&
          posSeconds < lines[i].endTime) {
        index = i;
        break;
      }
    }

    if (index != state.currentLineIndex) {
      state = (
        subtitleData: state.subtitleData,
        currentLineIndex: index,
        status: state.status,
        errorMessage: state.errorMessage,
      );
    }
  }
}
