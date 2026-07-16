// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod notifier managing the comment list for a specific video.
///
/// Family parameter is the video's `bvid` string.

@ProviderFor(CommentNotifier)
final commentNotifierProvider = CommentNotifierFamily._();

/// Riverpod notifier managing the comment list for a specific video.
///
/// Family parameter is the video's `bvid` string.
final class CommentNotifierProvider
    extends $AsyncNotifierProvider<CommentNotifier, CommentState> {
  /// Riverpod notifier managing the comment list for a specific video.
  ///
  /// Family parameter is the video's `bvid` string.
  CommentNotifierProvider._({
    required CommentNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'commentNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$commentNotifierHash();

  @override
  String toString() {
    return r'commentNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CommentNotifier create() => CommentNotifier();

  @override
  bool operator ==(Object other) {
    return other is CommentNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$commentNotifierHash() => r'00cb1f93414ca0875112efd3df3692c420398934';

/// Riverpod notifier managing the comment list for a specific video.
///
/// Family parameter is the video's `bvid` string.

final class CommentNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CommentNotifier,
          AsyncValue<CommentState>,
          CommentState,
          FutureOr<CommentState>,
          String
        > {
  CommentNotifierFamily._()
    : super(
        retry: null,
        name: r'commentNotifierProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Riverpod notifier managing the comment list for a specific video.
  ///
  /// Family parameter is the video's `bvid` string.

  CommentNotifierProvider call(String bvid) =>
      CommentNotifierProvider._(argument: bvid, from: this);

  @override
  String toString() => r'commentNotifierProvider';
}

/// Riverpod notifier managing the comment list for a specific video.
///
/// Family parameter is the video's `bvid` string.

abstract class _$CommentNotifier extends $AsyncNotifier<CommentState> {
  late final _$args = ref.$arg as String;
  String get bvid => _$args;

  FutureOr<CommentState> build(String bvid);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CommentState>, CommentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CommentState>, CommentState>,
              AsyncValue<CommentState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
