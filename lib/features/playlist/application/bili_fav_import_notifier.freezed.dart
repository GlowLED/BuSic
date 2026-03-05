// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bili_fav_import_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BiliFavImportState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loadingFolders,
    required TResult Function(List<BiliFavFolder> folders) foldersLoaded,
    required TResult Function(String folderName, int fetched, int total)
        loadingItems,
    required TResult Function(String folderName, List<BiliFavItem> items)
        itemsLoaded,
    required TResult Function(int current, int total) importing,
    required TResult Function(int playlistId, int imported, int reused,
            int failed, List<String> failedBvids)
        completed,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loadingFolders,
    TResult? Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult? Function(String folderName, int fetched, int total)? loadingItems,
    TResult? Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult? Function(int current, int total)? importing,
    TResult? Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loadingFolders,
    TResult Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult Function(String folderName, int fetched, int total)? loadingItems,
    TResult Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult Function(int current, int total)? importing,
    TResult Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_LoadingFolders value) loadingFolders,
    required TResult Function(_FoldersLoaded value) foldersLoaded,
    required TResult Function(_LoadingItems value) loadingItems,
    required TResult Function(_ItemsLoaded value) itemsLoaded,
    required TResult Function(_Importing value) importing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_LoadingFolders value)? loadingFolders,
    TResult? Function(_FoldersLoaded value)? foldersLoaded,
    TResult? Function(_LoadingItems value)? loadingItems,
    TResult? Function(_ItemsLoaded value)? itemsLoaded,
    TResult? Function(_Importing value)? importing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_LoadingFolders value)? loadingFolders,
    TResult Function(_FoldersLoaded value)? foldersLoaded,
    TResult Function(_LoadingItems value)? loadingItems,
    TResult Function(_ItemsLoaded value)? itemsLoaded,
    TResult Function(_Importing value)? importing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BiliFavImportStateCopyWith<$Res> {
  factory $BiliFavImportStateCopyWith(
          BiliFavImportState value, $Res Function(BiliFavImportState) then) =
      _$BiliFavImportStateCopyWithImpl<$Res, BiliFavImportState>;
}

/// @nodoc
class _$BiliFavImportStateCopyWithImpl<$Res, $Val extends BiliFavImportState>
    implements $BiliFavImportStateCopyWith<$Res> {
  _$BiliFavImportStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$IdleImplCopyWith<$Res> {
  factory _$$IdleImplCopyWith(
          _$IdleImpl value, $Res Function(_$IdleImpl) then) =
      __$$IdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$IdleImplCopyWithImpl<$Res>
    extends _$BiliFavImportStateCopyWithImpl<$Res, _$IdleImpl>
    implements _$$IdleImplCopyWith<$Res> {
  __$$IdleImplCopyWithImpl(_$IdleImpl _value, $Res Function(_$IdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$IdleImpl implements _Idle {
  const _$IdleImpl();

  @override
  String toString() {
    return 'BiliFavImportState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$IdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loadingFolders,
    required TResult Function(List<BiliFavFolder> folders) foldersLoaded,
    required TResult Function(String folderName, int fetched, int total)
        loadingItems,
    required TResult Function(String folderName, List<BiliFavItem> items)
        itemsLoaded,
    required TResult Function(int current, int total) importing,
    required TResult Function(int playlistId, int imported, int reused,
            int failed, List<String> failedBvids)
        completed,
    required TResult Function(String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loadingFolders,
    TResult? Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult? Function(String folderName, int fetched, int total)? loadingItems,
    TResult? Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult? Function(int current, int total)? importing,
    TResult? Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult? Function(String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loadingFolders,
    TResult Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult Function(String folderName, int fetched, int total)? loadingItems,
    TResult Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult Function(int current, int total)? importing,
    TResult Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_LoadingFolders value) loadingFolders,
    required TResult Function(_FoldersLoaded value) foldersLoaded,
    required TResult Function(_LoadingItems value) loadingItems,
    required TResult Function(_ItemsLoaded value) itemsLoaded,
    required TResult Function(_Importing value) importing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_LoadingFolders value)? loadingFolders,
    TResult? Function(_FoldersLoaded value)? foldersLoaded,
    TResult? Function(_LoadingItems value)? loadingItems,
    TResult? Function(_ItemsLoaded value)? itemsLoaded,
    TResult? Function(_Importing value)? importing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_LoadingFolders value)? loadingFolders,
    TResult Function(_FoldersLoaded value)? foldersLoaded,
    TResult Function(_LoadingItems value)? loadingItems,
    TResult Function(_ItemsLoaded value)? itemsLoaded,
    TResult Function(_Importing value)? importing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class _Idle implements BiliFavImportState {
  const factory _Idle() = _$IdleImpl;
}

/// @nodoc
abstract class _$$LoadingFoldersImplCopyWith<$Res> {
  factory _$$LoadingFoldersImplCopyWith(_$LoadingFoldersImpl value,
          $Res Function(_$LoadingFoldersImpl) then) =
      __$$LoadingFoldersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingFoldersImplCopyWithImpl<$Res>
    extends _$BiliFavImportStateCopyWithImpl<$Res, _$LoadingFoldersImpl>
    implements _$$LoadingFoldersImplCopyWith<$Res> {
  __$$LoadingFoldersImplCopyWithImpl(
      _$LoadingFoldersImpl _value, $Res Function(_$LoadingFoldersImpl) _then)
      : super(_value, _then);

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingFoldersImpl implements _LoadingFolders {
  const _$LoadingFoldersImpl();

  @override
  String toString() {
    return 'BiliFavImportState.loadingFolders()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingFoldersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loadingFolders,
    required TResult Function(List<BiliFavFolder> folders) foldersLoaded,
    required TResult Function(String folderName, int fetched, int total)
        loadingItems,
    required TResult Function(String folderName, List<BiliFavItem> items)
        itemsLoaded,
    required TResult Function(int current, int total) importing,
    required TResult Function(int playlistId, int imported, int reused,
            int failed, List<String> failedBvids)
        completed,
    required TResult Function(String message) error,
  }) {
    return loadingFolders();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loadingFolders,
    TResult? Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult? Function(String folderName, int fetched, int total)? loadingItems,
    TResult? Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult? Function(int current, int total)? importing,
    TResult? Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult? Function(String message)? error,
  }) {
    return loadingFolders?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loadingFolders,
    TResult Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult Function(String folderName, int fetched, int total)? loadingItems,
    TResult Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult Function(int current, int total)? importing,
    TResult Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loadingFolders != null) {
      return loadingFolders();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_LoadingFolders value) loadingFolders,
    required TResult Function(_FoldersLoaded value) foldersLoaded,
    required TResult Function(_LoadingItems value) loadingItems,
    required TResult Function(_ItemsLoaded value) itemsLoaded,
    required TResult Function(_Importing value) importing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return loadingFolders(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_LoadingFolders value)? loadingFolders,
    TResult? Function(_FoldersLoaded value)? foldersLoaded,
    TResult? Function(_LoadingItems value)? loadingItems,
    TResult? Function(_ItemsLoaded value)? itemsLoaded,
    TResult? Function(_Importing value)? importing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return loadingFolders?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_LoadingFolders value)? loadingFolders,
    TResult Function(_FoldersLoaded value)? foldersLoaded,
    TResult Function(_LoadingItems value)? loadingItems,
    TResult Function(_ItemsLoaded value)? itemsLoaded,
    TResult Function(_Importing value)? importing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loadingFolders != null) {
      return loadingFolders(this);
    }
    return orElse();
  }
}

abstract class _LoadingFolders implements BiliFavImportState {
  const factory _LoadingFolders() = _$LoadingFoldersImpl;
}

/// @nodoc
abstract class _$$FoldersLoadedImplCopyWith<$Res> {
  factory _$$FoldersLoadedImplCopyWith(
          _$FoldersLoadedImpl value, $Res Function(_$FoldersLoadedImpl) then) =
      __$$FoldersLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<BiliFavFolder> folders});
}

/// @nodoc
class __$$FoldersLoadedImplCopyWithImpl<$Res>
    extends _$BiliFavImportStateCopyWithImpl<$Res, _$FoldersLoadedImpl>
    implements _$$FoldersLoadedImplCopyWith<$Res> {
  __$$FoldersLoadedImplCopyWithImpl(
      _$FoldersLoadedImpl _value, $Res Function(_$FoldersLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? folders = null,
  }) {
    return _then(_$FoldersLoadedImpl(
      null == folders
          ? _value._folders
          : folders // ignore: cast_nullable_to_non_nullable
              as List<BiliFavFolder>,
    ));
  }
}

/// @nodoc

class _$FoldersLoadedImpl implements _FoldersLoaded {
  const _$FoldersLoadedImpl(final List<BiliFavFolder> folders)
      : _folders = folders;

  final List<BiliFavFolder> _folders;
  @override
  List<BiliFavFolder> get folders {
    if (_folders is EqualUnmodifiableListView) return _folders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_folders);
  }

  @override
  String toString() {
    return 'BiliFavImportState.foldersLoaded(folders: $folders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoldersLoadedImpl &&
            const DeepCollectionEquality().equals(other._folders, _folders));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_folders));

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoldersLoadedImplCopyWith<_$FoldersLoadedImpl> get copyWith =>
      __$$FoldersLoadedImplCopyWithImpl<_$FoldersLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loadingFolders,
    required TResult Function(List<BiliFavFolder> folders) foldersLoaded,
    required TResult Function(String folderName, int fetched, int total)
        loadingItems,
    required TResult Function(String folderName, List<BiliFavItem> items)
        itemsLoaded,
    required TResult Function(int current, int total) importing,
    required TResult Function(int playlistId, int imported, int reused,
            int failed, List<String> failedBvids)
        completed,
    required TResult Function(String message) error,
  }) {
    return foldersLoaded(folders);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loadingFolders,
    TResult? Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult? Function(String folderName, int fetched, int total)? loadingItems,
    TResult? Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult? Function(int current, int total)? importing,
    TResult? Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult? Function(String message)? error,
  }) {
    return foldersLoaded?.call(folders);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loadingFolders,
    TResult Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult Function(String folderName, int fetched, int total)? loadingItems,
    TResult Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult Function(int current, int total)? importing,
    TResult Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (foldersLoaded != null) {
      return foldersLoaded(folders);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_LoadingFolders value) loadingFolders,
    required TResult Function(_FoldersLoaded value) foldersLoaded,
    required TResult Function(_LoadingItems value) loadingItems,
    required TResult Function(_ItemsLoaded value) itemsLoaded,
    required TResult Function(_Importing value) importing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return foldersLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_LoadingFolders value)? loadingFolders,
    TResult? Function(_FoldersLoaded value)? foldersLoaded,
    TResult? Function(_LoadingItems value)? loadingItems,
    TResult? Function(_ItemsLoaded value)? itemsLoaded,
    TResult? Function(_Importing value)? importing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return foldersLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_LoadingFolders value)? loadingFolders,
    TResult Function(_FoldersLoaded value)? foldersLoaded,
    TResult Function(_LoadingItems value)? loadingItems,
    TResult Function(_ItemsLoaded value)? itemsLoaded,
    TResult Function(_Importing value)? importing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (foldersLoaded != null) {
      return foldersLoaded(this);
    }
    return orElse();
  }
}

abstract class _FoldersLoaded implements BiliFavImportState {
  const factory _FoldersLoaded(final List<BiliFavFolder> folders) =
      _$FoldersLoadedImpl;

  List<BiliFavFolder> get folders;

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoldersLoadedImplCopyWith<_$FoldersLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadingItemsImplCopyWith<$Res> {
  factory _$$LoadingItemsImplCopyWith(
          _$LoadingItemsImpl value, $Res Function(_$LoadingItemsImpl) then) =
      __$$LoadingItemsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String folderName, int fetched, int total});
}

/// @nodoc
class __$$LoadingItemsImplCopyWithImpl<$Res>
    extends _$BiliFavImportStateCopyWithImpl<$Res, _$LoadingItemsImpl>
    implements _$$LoadingItemsImplCopyWith<$Res> {
  __$$LoadingItemsImplCopyWithImpl(
      _$LoadingItemsImpl _value, $Res Function(_$LoadingItemsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? folderName = null,
    Object? fetched = null,
    Object? total = null,
  }) {
    return _then(_$LoadingItemsImpl(
      folderName: null == folderName
          ? _value.folderName
          : folderName // ignore: cast_nullable_to_non_nullable
              as String,
      fetched: null == fetched
          ? _value.fetched
          : fetched // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$LoadingItemsImpl implements _LoadingItems {
  const _$LoadingItemsImpl(
      {required this.folderName, required this.fetched, required this.total});

  @override
  final String folderName;
  @override
  final int fetched;
  @override
  final int total;

  @override
  String toString() {
    return 'BiliFavImportState.loadingItems(folderName: $folderName, fetched: $fetched, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadingItemsImpl &&
            (identical(other.folderName, folderName) ||
                other.folderName == folderName) &&
            (identical(other.fetched, fetched) || other.fetched == fetched) &&
            (identical(other.total, total) || other.total == total));
  }

  @override
  int get hashCode => Object.hash(runtimeType, folderName, fetched, total);

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadingItemsImplCopyWith<_$LoadingItemsImpl> get copyWith =>
      __$$LoadingItemsImplCopyWithImpl<_$LoadingItemsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loadingFolders,
    required TResult Function(List<BiliFavFolder> folders) foldersLoaded,
    required TResult Function(String folderName, int fetched, int total)
        loadingItems,
    required TResult Function(String folderName, List<BiliFavItem> items)
        itemsLoaded,
    required TResult Function(int current, int total) importing,
    required TResult Function(int playlistId, int imported, int reused,
            int failed, List<String> failedBvids)
        completed,
    required TResult Function(String message) error,
  }) {
    return loadingItems(folderName, fetched, total);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loadingFolders,
    TResult? Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult? Function(String folderName, int fetched, int total)? loadingItems,
    TResult? Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult? Function(int current, int total)? importing,
    TResult? Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult? Function(String message)? error,
  }) {
    return loadingItems?.call(folderName, fetched, total);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loadingFolders,
    TResult Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult Function(String folderName, int fetched, int total)? loadingItems,
    TResult Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult Function(int current, int total)? importing,
    TResult Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loadingItems != null) {
      return loadingItems(folderName, fetched, total);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_LoadingFolders value) loadingFolders,
    required TResult Function(_FoldersLoaded value) foldersLoaded,
    required TResult Function(_LoadingItems value) loadingItems,
    required TResult Function(_ItemsLoaded value) itemsLoaded,
    required TResult Function(_Importing value) importing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return loadingItems(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_LoadingFolders value)? loadingFolders,
    TResult? Function(_FoldersLoaded value)? foldersLoaded,
    TResult? Function(_LoadingItems value)? loadingItems,
    TResult? Function(_ItemsLoaded value)? itemsLoaded,
    TResult? Function(_Importing value)? importing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return loadingItems?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_LoadingFolders value)? loadingFolders,
    TResult Function(_FoldersLoaded value)? foldersLoaded,
    TResult Function(_LoadingItems value)? loadingItems,
    TResult Function(_ItemsLoaded value)? itemsLoaded,
    TResult Function(_Importing value)? importing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loadingItems != null) {
      return loadingItems(this);
    }
    return orElse();
  }
}

abstract class _LoadingItems implements BiliFavImportState {
  const factory _LoadingItems(
      {required final String folderName,
      required final int fetched,
      required final int total}) = _$LoadingItemsImpl;

  String get folderName;
  int get fetched;
  int get total;

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadingItemsImplCopyWith<_$LoadingItemsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ItemsLoadedImplCopyWith<$Res> {
  factory _$$ItemsLoadedImplCopyWith(
          _$ItemsLoadedImpl value, $Res Function(_$ItemsLoadedImpl) then) =
      __$$ItemsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String folderName, List<BiliFavItem> items});
}

/// @nodoc
class __$$ItemsLoadedImplCopyWithImpl<$Res>
    extends _$BiliFavImportStateCopyWithImpl<$Res, _$ItemsLoadedImpl>
    implements _$$ItemsLoadedImplCopyWith<$Res> {
  __$$ItemsLoadedImplCopyWithImpl(
      _$ItemsLoadedImpl _value, $Res Function(_$ItemsLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? folderName = null,
    Object? items = null,
  }) {
    return _then(_$ItemsLoadedImpl(
      folderName: null == folderName
          ? _value.folderName
          : folderName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<BiliFavItem>,
    ));
  }
}

/// @nodoc

class _$ItemsLoadedImpl implements _ItemsLoaded {
  const _$ItemsLoadedImpl(
      {required this.folderName, required final List<BiliFavItem> items})
      : _items = items;

  @override
  final String folderName;
  final List<BiliFavItem> _items;
  @override
  List<BiliFavItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'BiliFavImportState.itemsLoaded(folderName: $folderName, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemsLoadedImpl &&
            (identical(other.folderName, folderName) ||
                other.folderName == folderName) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, folderName, const DeepCollectionEquality().hash(_items));

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemsLoadedImplCopyWith<_$ItemsLoadedImpl> get copyWith =>
      __$$ItemsLoadedImplCopyWithImpl<_$ItemsLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loadingFolders,
    required TResult Function(List<BiliFavFolder> folders) foldersLoaded,
    required TResult Function(String folderName, int fetched, int total)
        loadingItems,
    required TResult Function(String folderName, List<BiliFavItem> items)
        itemsLoaded,
    required TResult Function(int current, int total) importing,
    required TResult Function(int playlistId, int imported, int reused,
            int failed, List<String> failedBvids)
        completed,
    required TResult Function(String message) error,
  }) {
    return itemsLoaded(folderName, items);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loadingFolders,
    TResult? Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult? Function(String folderName, int fetched, int total)? loadingItems,
    TResult? Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult? Function(int current, int total)? importing,
    TResult? Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult? Function(String message)? error,
  }) {
    return itemsLoaded?.call(folderName, items);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loadingFolders,
    TResult Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult Function(String folderName, int fetched, int total)? loadingItems,
    TResult Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult Function(int current, int total)? importing,
    TResult Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (itemsLoaded != null) {
      return itemsLoaded(folderName, items);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_LoadingFolders value) loadingFolders,
    required TResult Function(_FoldersLoaded value) foldersLoaded,
    required TResult Function(_LoadingItems value) loadingItems,
    required TResult Function(_ItemsLoaded value) itemsLoaded,
    required TResult Function(_Importing value) importing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return itemsLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_LoadingFolders value)? loadingFolders,
    TResult? Function(_FoldersLoaded value)? foldersLoaded,
    TResult? Function(_LoadingItems value)? loadingItems,
    TResult? Function(_ItemsLoaded value)? itemsLoaded,
    TResult? Function(_Importing value)? importing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return itemsLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_LoadingFolders value)? loadingFolders,
    TResult Function(_FoldersLoaded value)? foldersLoaded,
    TResult Function(_LoadingItems value)? loadingItems,
    TResult Function(_ItemsLoaded value)? itemsLoaded,
    TResult Function(_Importing value)? importing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (itemsLoaded != null) {
      return itemsLoaded(this);
    }
    return orElse();
  }
}

abstract class _ItemsLoaded implements BiliFavImportState {
  const factory _ItemsLoaded(
      {required final String folderName,
      required final List<BiliFavItem> items}) = _$ItemsLoadedImpl;

  String get folderName;
  List<BiliFavItem> get items;

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemsLoadedImplCopyWith<_$ItemsLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ImportingImplCopyWith<$Res> {
  factory _$$ImportingImplCopyWith(
          _$ImportingImpl value, $Res Function(_$ImportingImpl) then) =
      __$$ImportingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int current, int total});
}

/// @nodoc
class __$$ImportingImplCopyWithImpl<$Res>
    extends _$BiliFavImportStateCopyWithImpl<$Res, _$ImportingImpl>
    implements _$$ImportingImplCopyWith<$Res> {
  __$$ImportingImplCopyWithImpl(
      _$ImportingImpl _value, $Res Function(_$ImportingImpl) _then)
      : super(_value, _then);

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? total = null,
  }) {
    return _then(_$ImportingImpl(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ImportingImpl implements _Importing {
  const _$ImportingImpl({required this.current, required this.total});

  @override
  final int current;
  @override
  final int total;

  @override
  String toString() {
    return 'BiliFavImportState.importing(current: $current, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImportingImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.total, total) || other.total == total));
  }

  @override
  int get hashCode => Object.hash(runtimeType, current, total);

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImportingImplCopyWith<_$ImportingImpl> get copyWith =>
      __$$ImportingImplCopyWithImpl<_$ImportingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loadingFolders,
    required TResult Function(List<BiliFavFolder> folders) foldersLoaded,
    required TResult Function(String folderName, int fetched, int total)
        loadingItems,
    required TResult Function(String folderName, List<BiliFavItem> items)
        itemsLoaded,
    required TResult Function(int current, int total) importing,
    required TResult Function(int playlistId, int imported, int reused,
            int failed, List<String> failedBvids)
        completed,
    required TResult Function(String message) error,
  }) {
    return importing(current, total);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loadingFolders,
    TResult? Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult? Function(String folderName, int fetched, int total)? loadingItems,
    TResult? Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult? Function(int current, int total)? importing,
    TResult? Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult? Function(String message)? error,
  }) {
    return importing?.call(current, total);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loadingFolders,
    TResult Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult Function(String folderName, int fetched, int total)? loadingItems,
    TResult Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult Function(int current, int total)? importing,
    TResult Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (importing != null) {
      return importing(current, total);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_LoadingFolders value) loadingFolders,
    required TResult Function(_FoldersLoaded value) foldersLoaded,
    required TResult Function(_LoadingItems value) loadingItems,
    required TResult Function(_ItemsLoaded value) itemsLoaded,
    required TResult Function(_Importing value) importing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return importing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_LoadingFolders value)? loadingFolders,
    TResult? Function(_FoldersLoaded value)? foldersLoaded,
    TResult? Function(_LoadingItems value)? loadingItems,
    TResult? Function(_ItemsLoaded value)? itemsLoaded,
    TResult? Function(_Importing value)? importing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return importing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_LoadingFolders value)? loadingFolders,
    TResult Function(_FoldersLoaded value)? foldersLoaded,
    TResult Function(_LoadingItems value)? loadingItems,
    TResult Function(_ItemsLoaded value)? itemsLoaded,
    TResult Function(_Importing value)? importing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (importing != null) {
      return importing(this);
    }
    return orElse();
  }
}

abstract class _Importing implements BiliFavImportState {
  const factory _Importing(
      {required final int current, required final int total}) = _$ImportingImpl;

  int get current;
  int get total;

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImportingImplCopyWith<_$ImportingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CompletedImplCopyWith<$Res> {
  factory _$$CompletedImplCopyWith(
          _$CompletedImpl value, $Res Function(_$CompletedImpl) then) =
      __$$CompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int playlistId,
      int imported,
      int reused,
      int failed,
      List<String> failedBvids});
}

/// @nodoc
class __$$CompletedImplCopyWithImpl<$Res>
    extends _$BiliFavImportStateCopyWithImpl<$Res, _$CompletedImpl>
    implements _$$CompletedImplCopyWith<$Res> {
  __$$CompletedImplCopyWithImpl(
      _$CompletedImpl _value, $Res Function(_$CompletedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playlistId = null,
    Object? imported = null,
    Object? reused = null,
    Object? failed = null,
    Object? failedBvids = null,
  }) {
    return _then(_$CompletedImpl(
      playlistId: null == playlistId
          ? _value.playlistId
          : playlistId // ignore: cast_nullable_to_non_nullable
              as int,
      imported: null == imported
          ? _value.imported
          : imported // ignore: cast_nullable_to_non_nullable
              as int,
      reused: null == reused
          ? _value.reused
          : reused // ignore: cast_nullable_to_non_nullable
              as int,
      failed: null == failed
          ? _value.failed
          : failed // ignore: cast_nullable_to_non_nullable
              as int,
      failedBvids: null == failedBvids
          ? _value._failedBvids
          : failedBvids // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$CompletedImpl implements _Completed {
  const _$CompletedImpl(
      {required this.playlistId,
      required this.imported,
      required this.reused,
      required this.failed,
      required final List<String> failedBvids})
      : _failedBvids = failedBvids;

  @override
  final int playlistId;
  @override
  final int imported;
  @override
  final int reused;
  @override
  final int failed;
  final List<String> _failedBvids;
  @override
  List<String> get failedBvids {
    if (_failedBvids is EqualUnmodifiableListView) return _failedBvids;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_failedBvids);
  }

  @override
  String toString() {
    return 'BiliFavImportState.completed(playlistId: $playlistId, imported: $imported, reused: $reused, failed: $failed, failedBvids: $failedBvids)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletedImpl &&
            (identical(other.playlistId, playlistId) ||
                other.playlistId == playlistId) &&
            (identical(other.imported, imported) ||
                other.imported == imported) &&
            (identical(other.reused, reused) || other.reused == reused) &&
            (identical(other.failed, failed) || other.failed == failed) &&
            const DeepCollectionEquality()
                .equals(other._failedBvids, _failedBvids));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playlistId, imported, reused,
      failed, const DeepCollectionEquality().hash(_failedBvids));

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletedImplCopyWith<_$CompletedImpl> get copyWith =>
      __$$CompletedImplCopyWithImpl<_$CompletedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loadingFolders,
    required TResult Function(List<BiliFavFolder> folders) foldersLoaded,
    required TResult Function(String folderName, int fetched, int total)
        loadingItems,
    required TResult Function(String folderName, List<BiliFavItem> items)
        itemsLoaded,
    required TResult Function(int current, int total) importing,
    required TResult Function(int playlistId, int imported, int reused,
            int failed, List<String> failedBvids)
        completed,
    required TResult Function(String message) error,
  }) {
    return completed(playlistId, imported, reused, failed, failedBvids);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loadingFolders,
    TResult? Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult? Function(String folderName, int fetched, int total)? loadingItems,
    TResult? Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult? Function(int current, int total)? importing,
    TResult? Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult? Function(String message)? error,
  }) {
    return completed?.call(playlistId, imported, reused, failed, failedBvids);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loadingFolders,
    TResult Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult Function(String folderName, int fetched, int total)? loadingItems,
    TResult Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult Function(int current, int total)? importing,
    TResult Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(playlistId, imported, reused, failed, failedBvids);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_LoadingFolders value) loadingFolders,
    required TResult Function(_FoldersLoaded value) foldersLoaded,
    required TResult Function(_LoadingItems value) loadingItems,
    required TResult Function(_ItemsLoaded value) itemsLoaded,
    required TResult Function(_Importing value) importing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_LoadingFolders value)? loadingFolders,
    TResult? Function(_FoldersLoaded value)? foldersLoaded,
    TResult? Function(_LoadingItems value)? loadingItems,
    TResult? Function(_ItemsLoaded value)? itemsLoaded,
    TResult? Function(_Importing value)? importing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_LoadingFolders value)? loadingFolders,
    TResult Function(_FoldersLoaded value)? foldersLoaded,
    TResult Function(_LoadingItems value)? loadingItems,
    TResult Function(_ItemsLoaded value)? itemsLoaded,
    TResult Function(_Importing value)? importing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class _Completed implements BiliFavImportState {
  const factory _Completed(
      {required final int playlistId,
      required final int imported,
      required final int reused,
      required final int failed,
      required final List<String> failedBvids}) = _$CompletedImpl;

  int get playlistId;
  int get imported;
  int get reused;
  int get failed;
  List<String> get failedBvids;

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompletedImplCopyWith<_$CompletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$BiliFavImportStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'BiliFavImportState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loadingFolders,
    required TResult Function(List<BiliFavFolder> folders) foldersLoaded,
    required TResult Function(String folderName, int fetched, int total)
        loadingItems,
    required TResult Function(String folderName, List<BiliFavItem> items)
        itemsLoaded,
    required TResult Function(int current, int total) importing,
    required TResult Function(int playlistId, int imported, int reused,
            int failed, List<String> failedBvids)
        completed,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loadingFolders,
    TResult? Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult? Function(String folderName, int fetched, int total)? loadingItems,
    TResult? Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult? Function(int current, int total)? importing,
    TResult? Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loadingFolders,
    TResult Function(List<BiliFavFolder> folders)? foldersLoaded,
    TResult Function(String folderName, int fetched, int total)? loadingItems,
    TResult Function(String folderName, List<BiliFavItem> items)? itemsLoaded,
    TResult Function(int current, int total)? importing,
    TResult Function(int playlistId, int imported, int reused, int failed,
            List<String> failedBvids)?
        completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_LoadingFolders value) loadingFolders,
    required TResult Function(_FoldersLoaded value) foldersLoaded,
    required TResult Function(_LoadingItems value) loadingItems,
    required TResult Function(_ItemsLoaded value) itemsLoaded,
    required TResult Function(_Importing value) importing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_LoadingFolders value)? loadingFolders,
    TResult? Function(_FoldersLoaded value)? foldersLoaded,
    TResult? Function(_LoadingItems value)? loadingItems,
    TResult? Function(_ItemsLoaded value)? itemsLoaded,
    TResult? Function(_Importing value)? importing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_LoadingFolders value)? loadingFolders,
    TResult Function(_FoldersLoaded value)? foldersLoaded,
    TResult Function(_LoadingItems value)? loadingItems,
    TResult Function(_ItemsLoaded value)? itemsLoaded,
    TResult Function(_Importing value)? importing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements BiliFavImportState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of BiliFavImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
