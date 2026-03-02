/// Playback mode enumeration.
enum PlayMode {
  /// Play tracks in order, stop after the last one.
  sequential,

  /// Play tracks in order, loop back to the beginning.
  repeatAll,

  /// Repeat the current track indefinitely.
  repeatOne,

  /// Shuffle the queue randomly.
  shuffle,
}
