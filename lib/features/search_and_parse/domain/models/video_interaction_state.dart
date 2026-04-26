import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_interaction_state.freezed.dart';

/// Runtime state for Bilibili video interaction actions.
@freezed
class VideoInteractionState with _$VideoInteractionState {
  const factory VideoInteractionState({
    /// Whether the current user has liked the video.
    @Default(false) bool isLiked,

    /// Whether the current user has added the video to a favorite folder.
    @Default(false) bool isFavorited,

    /// Number of coins the current user has given to the video.
    @Default(0) int coinsGiven,

    /// Whether an interaction request is in progress.
    @Default(false) bool isBusy,

    /// Last interaction error for presentation feedback.
    String? lastError,
  }) = _VideoInteractionState;
}
