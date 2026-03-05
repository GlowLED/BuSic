// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$downloadNotifierHash() => r'a1ff35b15e0c855a4eb965ed9083562ebd757469';

/// State notifier managing the download task queue and status.
///
/// Keep-alive so the [watchAllTasks] listener stays active even when the
/// download screen is not visible. This ensures [downloadChangeSignalProvider]
/// fires when downloads complete in the background, allowing playlist views
/// to refresh their download status indicators.
///
/// Copied from [DownloadNotifier].
@ProviderFor(DownloadNotifier)
final downloadNotifierProvider =
    AsyncNotifierProvider<DownloadNotifier, List<DownloadTask>>.internal(
  DownloadNotifier.new,
  name: r'downloadNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$downloadNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DownloadNotifier = AsyncNotifier<List<DownloadTask>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
