// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier managing user preferences / settings.
///
/// Persists preferences to local storage and provides reactive
/// access for theme, locale, and other app-wide settings.

@ProviderFor(SettingsNotifier)
final settingsNotifierProvider = SettingsNotifierProvider._();

/// State notifier managing user preferences / settings.
///
/// Persists preferences to local storage and provides reactive
/// access for theme, locale, and other app-wide settings.
final class SettingsNotifierProvider
    extends $NotifierProvider<SettingsNotifier, UserPreferences> {
  /// State notifier managing user preferences / settings.
  ///
  /// Persists preferences to local storage and provides reactive
  /// access for theme, locale, and other app-wide settings.
  SettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsNotifierHash();

  @$internal
  @override
  SettingsNotifier create() => SettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserPreferences>(value),
    );
  }
}

String _$settingsNotifierHash() => r'c22cd80078b9655d6e292f6faa0fba07f0faf95c';

/// State notifier managing user preferences / settings.
///
/// Persists preferences to local storage and provides reactive
/// access for theme, locale, and other app-wide settings.

abstract class _$SettingsNotifier extends $Notifier<UserPreferences> {
  UserPreferences build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<UserPreferences, UserPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserPreferences, UserPreferences>,
              UserPreferences,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
