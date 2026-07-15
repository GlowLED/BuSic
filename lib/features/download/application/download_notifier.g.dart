// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier managing the download task queue and status.
///
/// Keep-alive so the [watchAllTasks] listener stays active even when the
/// download screen is not visible. This ensures [downloadChangeSignalProvider]
/// fires when downloads complete in the background, allowing playlist views
/// to refresh their download status indicators.

@ProviderFor(DownloadNotifier)
final downloadNotifierProvider = DownloadNotifierProvider._();

/// State notifier managing the download task queue and status.
///
/// Keep-alive so the [watchAllTasks] listener stays active even when the
/// download screen is not visible. This ensures [downloadChangeSignalProvider]
/// fires when downloads complete in the background, allowing playlist views
/// to refresh their download status indicators.
final class DownloadNotifierProvider
    extends $AsyncNotifierProvider<DownloadNotifier, List<DownloadTask>> {
  /// State notifier managing the download task queue and status.
  ///
  /// Keep-alive so the [watchAllTasks] listener stays active even when the
  /// download screen is not visible. This ensures [downloadChangeSignalProvider]
  /// fires when downloads complete in the background, allowing playlist views
  /// to refresh their download status indicators.
  DownloadNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadNotifierProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadNotifierHash();

  @$internal
  @override
  DownloadNotifier create() => DownloadNotifier();
}

String _$downloadNotifierHash() => r'144219dd4109ea0c457389db4773e8cb5c23198d';

/// State notifier managing the download task queue and status.
///
/// Keep-alive so the [watchAllTasks] listener stays active even when the
/// download screen is not visible. This ensures [downloadChangeSignalProvider]
/// fires when downloads complete in the background, allowing playlist views
/// to refresh their download status indicators.

abstract class _$DownloadNotifier extends $AsyncNotifier<List<DownloadTask>> {
  FutureOr<List<DownloadTask>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<DownloadTask>>, List<DownloadTask>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<DownloadTask>>, List<DownloadTask>>,
              AsyncValue<List<DownloadTask>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
