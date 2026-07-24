import 'dart:async';
import 'dart:math';

typedef PlaybackVolumeSetter = Future<void> Function(double volume);
typedef PlaybackFadeDelay = Future<void> Function(Duration duration);

enum PlaybackFadePhase { idle, fadeIn, fadeOut }

/// Applies cancellable volume ramps without changing the user's target volume.
class PlaybackFadeController {
  PlaybackFadeController({
    required PlaybackVolumeSetter setVolume,
    double initialVolume = 1,
    this.tickInterval = const Duration(milliseconds: 50),
    PlaybackFadeDelay? delay,
  }) : _setVolume = setVolume,
       _effectiveVolume = initialVolume.clamp(0, 1).toDouble(),
       _delay = delay ?? Future<void>.delayed;

  final PlaybackVolumeSetter _setVolume;
  final PlaybackFadeDelay _delay;
  final Duration tickInterval;

  double _effectiveVolume;
  int _generation = 0;
  bool _disposed = false;
  PlaybackFadePhase _phase = PlaybackFadePhase.idle;
  Future<void> _volumeWriteTail = Future<void>.value();

  double get effectiveVolume => _effectiveVolume;
  PlaybackFadePhase get phase => _phase;

  /// Cancels any active ramp. The current effective volume is preserved.
  void cancel() {
    _generation++;
    _phase = PlaybackFadePhase.idle;
  }

  Future<bool> setImmediate(double volume) async {
    if (_disposed) return false;

    final generation = ++_generation;
    _phase = PlaybackFadePhase.idle;
    final normalized = volume.clamp(0, 1).toDouble();
    return _writeVolume(generation, normalized);
  }

  /// Fades from the current effective volume to [target].
  ///
  /// [targetProvider] lets fade-in follow a user volume change without
  /// exposing intermediate values through PlayerState or platform controls.
  Future<bool> fadeTo({
    required double target,
    required Duration duration,
    required PlaybackFadePhase phase,
    double Function()? targetProvider,
  }) async {
    if (_disposed) return false;

    final generation = ++_generation;
    _phase = phase;
    await _volumeWriteTail;
    if (!_isCurrent(generation)) return false;

    final startVolume = _effectiveVolume;
    final durationMs = max(0, duration.inMilliseconds);
    final tickMs = max(1, tickInterval.inMilliseconds);
    final steps = max(1, (durationMs / tickMs).ceil());
    final stepDuration = durationMs == 0
        ? Duration.zero
        : Duration(microseconds: (duration.inMicroseconds / steps).round());

    try {
      for (var step = 1; step <= steps; step++) {
        if (!_isCurrent(generation)) return false;
        if (stepDuration > Duration.zero) {
          await _delay(stepDuration);
        }
        if (!_isCurrent(generation)) return false;

        final currentTarget = (targetProvider?.call() ?? target)
            .clamp(0, 1)
            .toDouble();
        final progress = step / steps;
        final volume = startVolume + ((currentTarget - startVolume) * progress);
        if (!await _writeVolume(generation, volume)) return false;
      }

      if (_isCurrent(generation)) {
        _phase = PlaybackFadePhase.idle;
        return true;
      }
      return false;
    } catch (_) {
      if (_isCurrent(generation)) {
        _phase = PlaybackFadePhase.idle;
      }
      rethrow;
    }
  }

  void dispose() {
    _disposed = true;
    cancel();
  }

  bool _isCurrent(int generation) {
    return !_disposed && generation == _generation;
  }

  Future<bool> _writeVolume(int generation, double volume) async {
    final previousWrite = _volumeWriteTail;
    final writeCompleted = Completer<void>();
    _volumeWriteTail = writeCompleted.future;

    try {
      await previousWrite;
      if (!_isCurrent(generation)) return false;

      await _setVolume(volume);
      // The setter completed, so this is now the actual underlying volume even
      // if another command cancelled this generation while the write was in
      // flight. A newer write waits for this one before applying its value.
      _effectiveVolume = volume;
      return _isCurrent(generation);
    } finally {
      writeCompleted.complete();
    }
  }
}
