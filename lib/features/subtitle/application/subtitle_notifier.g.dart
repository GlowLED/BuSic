// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtitle_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier for subtitle/lyrics data of a specific video.
///
/// Uses family parameters `(bvid, cid)` so each video gets its own
/// independent subtitle instance with automatic disposal.

@ProviderFor(SubtitleNotifier)
final subtitleNotifierProvider = SubtitleNotifierFamily._();

/// State notifier for subtitle/lyrics data of a specific video.
///
/// Uses family parameters `(bvid, cid)` so each video gets its own
/// independent subtitle instance with automatic disposal.
final class SubtitleNotifierProvider
    extends
        $NotifierProvider<
          SubtitleNotifier,
          ({
            int currentLineIndex,
            String? errorMessage,
            SubtitleLoadStatus status,
            SubtitleData? subtitleData,
          })
        > {
  /// State notifier for subtitle/lyrics data of a specific video.
  ///
  /// Uses family parameters `(bvid, cid)` so each video gets its own
  /// independent subtitle instance with automatic disposal.
  SubtitleNotifierProvider._({
    required SubtitleNotifierFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'subtitleNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$subtitleNotifierHash();

  @override
  String toString() {
    return r'subtitleNotifierProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SubtitleNotifier create() => SubtitleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    ({
      int currentLineIndex,
      String? errorMessage,
      SubtitleLoadStatus status,
      SubtitleData? subtitleData,
    })
    value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            ({
              int currentLineIndex,
              String? errorMessage,
              SubtitleLoadStatus status,
              SubtitleData? subtitleData,
            })
          >(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SubtitleNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subtitleNotifierHash() => r'5735560c0d9e05bb028f8dd93bc738cc113e9de3';

/// State notifier for subtitle/lyrics data of a specific video.
///
/// Uses family parameters `(bvid, cid)` so each video gets its own
/// independent subtitle instance with automatic disposal.

final class SubtitleNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          SubtitleNotifier,
          ({
            int currentLineIndex,
            String? errorMessage,
            SubtitleLoadStatus status,
            SubtitleData? subtitleData,
          }),
          ({
            int currentLineIndex,
            String? errorMessage,
            SubtitleLoadStatus status,
            SubtitleData? subtitleData,
          }),
          ({
            int currentLineIndex,
            String? errorMessage,
            SubtitleLoadStatus status,
            SubtitleData? subtitleData,
          }),
          (String, int)
        > {
  SubtitleNotifierFamily._()
    : super(
        retry: null,
        name: r'subtitleNotifierProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// State notifier for subtitle/lyrics data of a specific video.
  ///
  /// Uses family parameters `(bvid, cid)` so each video gets its own
  /// independent subtitle instance with automatic disposal.

  SubtitleNotifierProvider call(String bvid, int cid) =>
      SubtitleNotifierProvider._(argument: (bvid, cid), from: this);

  @override
  String toString() => r'subtitleNotifierProvider';
}

/// State notifier for subtitle/lyrics data of a specific video.
///
/// Uses family parameters `(bvid, cid)` so each video gets its own
/// independent subtitle instance with automatic disposal.

abstract class _$SubtitleNotifier
    extends
        $Notifier<
          ({
            int currentLineIndex,
            String? errorMessage,
            SubtitleLoadStatus status,
            SubtitleData? subtitleData,
          })
        > {
  late final _$args = ref.$arg as (String, int);
  String get bvid => _$args.$1;
  int get cid => _$args.$2;

  ({
    int currentLineIndex,
    String? errorMessage,
    SubtitleLoadStatus status,
    SubtitleData? subtitleData,
  })
  build(String bvid, int cid);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              ({
                int currentLineIndex,
                String? errorMessage,
                SubtitleLoadStatus status,
                SubtitleData? subtitleData,
              }),
              ({
                int currentLineIndex,
                String? errorMessage,
                SubtitleLoadStatus status,
                SubtitleData? subtitleData,
              })
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ({
                  int currentLineIndex,
                  String? errorMessage,
                  SubtitleLoadStatus status,
                  SubtitleData? subtitleData,
                }),
                ({
                  int currentLineIndex,
                  String? errorMessage,
                  SubtitleLoadStatus status,
                  SubtitleData? subtitleData,
                })
              >,
              ({
                int currentLineIndex,
                String? errorMessage,
                SubtitleLoadStatus status,
                SubtitleData? subtitleData,
              }),
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
