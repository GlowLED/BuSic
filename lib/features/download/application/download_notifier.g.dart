// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$downloadNotifierHash() => r'bf599f7e4444a7607f7edff371d90913ea42779e';

/// State notifier managing the download task queue and status.
///
/// Copied from [DownloadNotifier].
@ProviderFor(DownloadNotifier)
final downloadNotifierProvider = AutoDisposeAsyncNotifierProvider<
    DownloadNotifier, List<DownloadTask>>.internal(
  DownloadNotifier.new,
  name: r'downloadNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$downloadNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DownloadNotifier = AutoDisposeAsyncNotifier<List<DownloadTask>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
