// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 歌单分享功能的状态管理 Notifier
///
/// 管理歌单的导出（到剪贴板）和导入（从剪贴板）流程。

@ProviderFor(ShareNotifier)
final shareNotifierProvider = ShareNotifierProvider._();

/// 歌单分享功能的状态管理 Notifier
///
/// 管理歌单的导出（到剪贴板）和导入（从剪贴板）流程。
final class ShareNotifierProvider
    extends $NotifierProvider<ShareNotifier, ShareState> {
  /// 歌单分享功能的状态管理 Notifier
  ///
  /// 管理歌单的导出（到剪贴板）和导入（从剪贴板）流程。
  ShareNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareNotifierHash();

  @$internal
  @override
  ShareNotifier create() => ShareNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareState>(value),
    );
  }
}

String _$shareNotifierHash() => r'dae8405190d3fc3515631fada3e10d1d33ada7f3';

/// 歌单分享功能的状态管理 Notifier
///
/// 管理歌单的导出（到剪贴板）和导入（从剪贴板）流程。

abstract class _$ShareNotifier extends $Notifier<ShareState> {
  ShareState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ShareState, ShareState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ShareState, ShareState>,
              ShareState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
