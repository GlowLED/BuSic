// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_interaction_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages Bilibili interaction state for a parsed video detail page.

@ProviderFor(VideoInteractionNotifier)
final videoInteractionNotifierProvider = VideoInteractionNotifierFamily._();

/// Manages Bilibili interaction state for a parsed video detail page.
final class VideoInteractionNotifierProvider
    extends
        $AsyncNotifierProvider<
          VideoInteractionNotifier,
          VideoInteractionState
        > {
  /// Manages Bilibili interaction state for a parsed video detail page.
  VideoInteractionNotifierProvider._({
    required VideoInteractionNotifierFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'videoInteractionNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$videoInteractionNotifierHash();

  @override
  String toString() {
    return r'videoInteractionNotifierProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  VideoInteractionNotifier create() => VideoInteractionNotifier();

  @override
  bool operator ==(Object other) {
    return other is VideoInteractionNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$videoInteractionNotifierHash() =>
    r'f5d7637f3728f0efff30d65ed8729f17fcd560b1';

/// Manages Bilibili interaction state for a parsed video detail page.

final class VideoInteractionNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          VideoInteractionNotifier,
          AsyncValue<VideoInteractionState>,
          VideoInteractionState,
          FutureOr<VideoInteractionState>,
          (String, int)
        > {
  VideoInteractionNotifierFamily._()
    : super(
        retry: null,
        name: r'videoInteractionNotifierProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Manages Bilibili interaction state for a parsed video detail page.

  VideoInteractionNotifierProvider call(String bvid, int aid) =>
      VideoInteractionNotifierProvider._(argument: (bvid, aid), from: this);

  @override
  String toString() => r'videoInteractionNotifierProvider';
}

/// Manages Bilibili interaction state for a parsed video detail page.

abstract class _$VideoInteractionNotifier
    extends $AsyncNotifier<VideoInteractionState> {
  late final _$args = ref.$arg as (String, int);
  String get bvid => _$args.$1;
  int get aid => _$args.$2;

  FutureOr<VideoInteractionState> build(String bvid, int aid);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<VideoInteractionState>, VideoInteractionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<VideoInteractionState>,
                VideoInteractionState
              >,
              AsyncValue<VideoInteractionState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
