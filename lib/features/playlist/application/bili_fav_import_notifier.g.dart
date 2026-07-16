// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bili_fav_import_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BiliFavImportNotifier)
final biliFavImportNotifierProvider = BiliFavImportNotifierProvider._();

final class BiliFavImportNotifierProvider
    extends $NotifierProvider<BiliFavImportNotifier, BiliFavImportState> {
  BiliFavImportNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biliFavImportNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biliFavImportNotifierHash();

  @$internal
  @override
  BiliFavImportNotifier create() => BiliFavImportNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BiliFavImportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BiliFavImportState>(value),
    );
  }
}

String _$biliFavImportNotifierHash() =>
    r'6029b800ef1547598db9b3cebc176f72486a260f';

abstract class _$BiliFavImportNotifier extends $Notifier<BiliFavImportState> {
  BiliFavImportState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BiliFavImportState, BiliFavImportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BiliFavImportState, BiliFavImportState>,
              BiliFavImportState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
