// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shareNotifierHash() => r'cd214b561c6677a0b346184f5c59bf8ece61ded6';

/// 歌单分享功能的状态管理 Notifier
///
/// 管理歌单的导出（到剪贴板）和导入（从剪贴板）流程。
///
/// Copied from [ShareNotifier].
@ProviderFor(ShareNotifier)
final shareNotifierProvider =
    AutoDisposeNotifierProvider<ShareNotifier, ShareState>.internal(
  ShareNotifier.new,
  name: r'shareNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shareNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShareNotifier = AutoDisposeNotifier<ShareState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
