// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 数据同步功能的状态管理 Notifier
///
/// 管理完整数据的文件导出和导入流程。

@ProviderFor(SyncNotifier)
final syncNotifierProvider = SyncNotifierProvider._();

/// 数据同步功能的状态管理 Notifier
///
/// 管理完整数据的文件导出和导入流程。
final class SyncNotifierProvider
    extends $NotifierProvider<SyncNotifier, SyncState> {
  /// 数据同步功能的状态管理 Notifier
  ///
  /// 管理完整数据的文件导出和导入流程。
  SyncNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncNotifierHash();

  @$internal
  @override
  SyncNotifier create() => SyncNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncState>(value),
    );
  }
}

String _$syncNotifierHash() => r'9001c98bfbe42175a07a3ffd8a3aca869e008146';

/// 数据同步功能的状态管理 Notifier
///
/// 管理完整数据的文件导出和导入流程。

abstract class _$SyncNotifier extends $Notifier<SyncState> {
  SyncState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SyncState, SyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncState, SyncState>,
              SyncState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
