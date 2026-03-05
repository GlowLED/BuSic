import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Provides [PackageInfo] at runtime.
///
/// The version and build number are read from the values that Flutter embeds
/// into the native layer based on `pubspec.yaml`'s `version` field
/// (format: `x.y.z+buildNumber`).
///
/// Usage:
/// ```dart
/// final info = await ref.watch(appInfoProvider.future);
/// Text('v${info.version}+${info.buildNumber}');
/// ```
final appInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return PackageInfo.fromPlatform();
});

/// Convenience getter – returns a display string like `"0.2.1+3"`.
///
/// Returns `null` while the future is still loading.
String? appVersionString(Ref<Object?> ref) {
  final info = ref.watch(appInfoProvider).valueOrNull;
  if (info == null) return null;
  return '${info.version}+${info.buildNumber}';
}
