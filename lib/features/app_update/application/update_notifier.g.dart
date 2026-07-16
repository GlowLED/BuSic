// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UpdateNotifier)
final updateNotifierProvider = UpdateNotifierProvider._();

final class UpdateNotifierProvider
    extends $NotifierProvider<UpdateNotifier, UpdateState> {
  UpdateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateNotifierHash();

  @$internal
  @override
  UpdateNotifier create() => UpdateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateState>(value),
    );
  }
}

String _$updateNotifierHash() => r'409e3ee92726545753f40e2681825b1e135932d8';

abstract class _$UpdateNotifier extends $Notifier<UpdateState> {
  UpdateState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<UpdateState, UpdateState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UpdateState, UpdateState>,
              UpdateState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
