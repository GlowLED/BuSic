// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier managing the BV number parsing and page selection flow.

@ProviderFor(ParseNotifier)
final parseNotifierProvider = ParseNotifierProvider._();

/// State notifier managing the BV number parsing and page selection flow.
final class ParseNotifierProvider
    extends $NotifierProvider<ParseNotifier, ParseState> {
  /// State notifier managing the BV number parsing and page selection flow.
  ParseNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'parseNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$parseNotifierHash();

  @$internal
  @override
  ParseNotifier create() => ParseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ParseState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ParseState>(value),
    );
  }
}

String _$parseNotifierHash() => r'4ea4f5ede408bdc66dabcf5ba0d7ad8441dfa247';

/// State notifier managing the BV number parsing and page selection flow.

abstract class _$ParseNotifier extends $Notifier<ParseState> {
  ParseState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ParseState, ParseState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ParseState, ParseState>,
              ParseState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
