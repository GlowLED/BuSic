import '../domain/models/video_interaction_state.dart';

/// Repository for Bilibili video interaction operations.
abstract class VideoInteractionRepository {
  /// Read the current user's interaction state for a video.
  Future<VideoInteractionState> getInteractionState({
    required int aid,
    required String bvid,
  });

  /// Like or unlike a video.
  Future<void> setLike({
    required int aid,
    required bool like,
    required String csrf,
  });

  /// Add coins to a video.
  Future<void> addCoin({
    required int aid,
    required int multiply,
    required bool alsoLike,
    required String csrf,
  });

  /// Add a video to a Bilibili favorite folder.
  Future<void> addToFavoriteFolder({
    required int aid,
    required int mediaId,
    required String csrf,
  });

  /// Record a Bilibili share action.
  Future<void> recordShare({
    required int aid,
    required String bvid,
    required String csrf,
  });
}
