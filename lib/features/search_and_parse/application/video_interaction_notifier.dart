import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/utils/logger.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/domain/models/user.dart';
import '../data/video_interaction_exception.dart';
import '../data/video_interaction_repository.dart';
import '../data/video_interaction_repository_impl.dart';
import '../domain/models/video_interaction_state.dart';

part 'video_interaction_notifier.g.dart';

final videoInteractionRepositoryProvider =
    Provider<VideoInteractionRepository>((ref) {
  return VideoInteractionRepositoryImpl(biliDio: BiliDio());
});

/// Manages Bilibili interaction state for a parsed video detail page.
@riverpod
class VideoInteractionNotifier extends _$VideoInteractionNotifier {
  late VideoInteractionRepository _repository;

  @override
  Future<VideoInteractionState> build(String bvid, int aid) async {
    _repository = ref.read(videoInteractionRepositoryProvider);

    final user = await ref.watch(authNotifierProvider.future);
    if (!_hasValidLogin(user)) {
      return const VideoInteractionState();
    }

    return _repository.getInteractionState(aid: aid, bvid: bvid);
  }

  /// Like or unlike the current video with optimistic UI state.
  Future<bool> toggleLike() async {
    final link = ref.keepAlive();
    VideoInteractionState? rollbackState;
    try {
      final current = state.valueOrNull;
      if (current == null || current.isBusy) return false;
      rollbackState = current;

      final user = await ref.read(authNotifierProvider.future);
      if (!_hasValidLogin(user)) {
        state = AsyncData(current.copyWith(lastError: 'pleaseLoginFirst'));
        return false;
      }

      final nextLiked = !current.isLiked;
      state = AsyncData(
        current.copyWith(
          isLiked: nextLiked,
          isBusy: true,
          lastError: null,
        ),
      );

      await _repository.setLike(
        aid: aid,
        like: nextLiked,
        csrf: user!.biliJct,
      );

      state = AsyncData(
        current.copyWith(
          isLiked: nextLiked,
          isBusy: false,
          lastError: null,
        ),
      );
      return true;
    } catch (error, stackTrace) {
      final fallback = rollbackState?.copyWith(
            isBusy: false,
            lastError: _messageFor(error),
          ) ??
          VideoInteractionState(lastError: _messageFor(error));
      state = AsyncData(fallback);
      AppLogger.error(
        'Failed to toggle video like',
        tag: 'VideoInteraction',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    } finally {
      link.close();
    }
  }

  /// Add one or two coins to the current video.
  Future<bool> addCoin({
    required int multiply,
    required bool alsoLike,
  }) async {
    final link = ref.keepAlive();
    try {
      final current = state.valueOrNull;
      if (current == null || current.isBusy) return false;

      final user = await ref.read(authNotifierProvider.future);
      if (!_hasValidLogin(user)) {
        state = AsyncData(current.copyWith(lastError: 'pleaseLoginFirst'));
        return false;
      }

      state = AsyncData(current.copyWith(isBusy: true, lastError: null));
      await _repository.addCoin(
        aid: aid,
        multiply: multiply,
        alsoLike: alsoLike,
        csrf: user!.biliJct,
      );

      state = AsyncData(
        current.copyWith(
          isLiked: current.isLiked || alsoLike,
          coinsGiven: (current.coinsGiven + multiply).clamp(0, 2).toInt(),
          isBusy: false,
          lastError: null,
        ),
      );
      return true;
    } catch (error, stackTrace) {
      _setOperationError(error, stackTrace, 'Failed to add video coin');
      return false;
    } finally {
      link.close();
    }
  }

  /// Add the current video to a Bilibili favorite folder.
  Future<bool> addToFavoriteFolder(int mediaId) async {
    final link = ref.keepAlive();
    try {
      final current = state.valueOrNull;
      if (current == null || current.isBusy) return false;

      final user = await ref.read(authNotifierProvider.future);
      if (!_hasValidLogin(user)) {
        state = AsyncData(current.copyWith(lastError: 'pleaseLoginFirst'));
        return false;
      }

      state = AsyncData(current.copyWith(isBusy: true, lastError: null));
      await _repository.addToFavoriteFolder(
        aid: aid,
        mediaId: mediaId,
        csrf: user!.biliJct,
      );

      state = AsyncData(
        current.copyWith(
          isFavorited: true,
          isBusy: false,
          lastError: null,
        ),
      );
      return true;
    } catch (error, stackTrace) {
      _setOperationError(
        error,
        stackTrace,
        'Failed to add video to favorite folder',
      );
      return false;
    } finally {
      link.close();
    }
  }

  /// Record a Bilibili share action.
  Future<bool> recordShare() async {
    final link = ref.keepAlive();
    try {
      final current = state.valueOrNull;
      if (current == null || current.isBusy) return false;

      final user = await ref.read(authNotifierProvider.future);
      if (!_hasValidLogin(user)) {
        state = AsyncData(current.copyWith(lastError: 'pleaseLoginFirst'));
        return false;
      }

      state = AsyncData(current.copyWith(isBusy: true, lastError: null));
      await _repository.recordShare(
        aid: aid,
        bvid: bvid,
        csrf: user!.biliJct,
      );

      state = AsyncData(current.copyWith(isBusy: false, lastError: null));
      return true;
    } catch (error, stackTrace) {
      _setOperationError(error, stackTrace, 'Failed to record video share');
      return false;
    } finally {
      link.close();
    }
  }

  /// Clear the last presentation-facing interaction error.
  void clearError() {
    final current = state.valueOrNull;
    if (current == null || current.lastError == null) return;
    state = AsyncData(current.copyWith(lastError: null));
  }

  bool _hasValidLogin(User? user) {
    return user != null && user.isLoggedIn && user.biliJct.isNotEmpty;
  }

  void _setOperationError(
    Object error,
    StackTrace stackTrace,
    String logMessage,
  ) {
    final current = state.valueOrNull;
    state = AsyncData(
      (current ?? const VideoInteractionState()).copyWith(
        isBusy: false,
        lastError: _messageFor(error),
      ),
    );
    AppLogger.error(
      logMessage,
      tag: 'VideoInteraction',
      error: error,
      stackTrace: stackTrace,
    );
  }

  String _messageFor(Object error) {
    if (error is VideoInteractionException) {
      return error.message;
    }
    return error.toString();
  }
}
