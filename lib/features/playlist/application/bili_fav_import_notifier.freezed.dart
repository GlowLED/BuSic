// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bili_fav_import_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BiliFavImportState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BiliFavImportState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BiliFavImportState()';
}


}

/// @nodoc
class $BiliFavImportStateCopyWith<$Res>  {
$BiliFavImportStateCopyWith(BiliFavImportState _, $Res Function(BiliFavImportState) __);
}


/// Adds pattern-matching-related methods to [BiliFavImportState].
extension BiliFavImportStatePatterns on BiliFavImportState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Idle value)?  idle,TResult Function( _LoadingFolders value)?  loadingFolders,TResult Function( _FoldersLoaded value)?  foldersLoaded,TResult Function( _LoadingItems value)?  loadingItems,TResult Function( _ItemsLoaded value)?  itemsLoaded,TResult Function( _Importing value)?  importing,TResult Function( _Completed value)?  completed,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case _LoadingFolders() when loadingFolders != null:
return loadingFolders(_that);case _FoldersLoaded() when foldersLoaded != null:
return foldersLoaded(_that);case _LoadingItems() when loadingItems != null:
return loadingItems(_that);case _ItemsLoaded() when itemsLoaded != null:
return itemsLoaded(_that);case _Importing() when importing != null:
return importing(_that);case _Completed() when completed != null:
return completed(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Idle value)  idle,required TResult Function( _LoadingFolders value)  loadingFolders,required TResult Function( _FoldersLoaded value)  foldersLoaded,required TResult Function( _LoadingItems value)  loadingItems,required TResult Function( _ItemsLoaded value)  itemsLoaded,required TResult Function( _Importing value)  importing,required TResult Function( _Completed value)  completed,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Idle():
return idle(_that);case _LoadingFolders():
return loadingFolders(_that);case _FoldersLoaded():
return foldersLoaded(_that);case _LoadingItems():
return loadingItems(_that);case _ItemsLoaded():
return itemsLoaded(_that);case _Importing():
return importing(_that);case _Completed():
return completed(_that);case _Error():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Idle value)?  idle,TResult? Function( _LoadingFolders value)?  loadingFolders,TResult? Function( _FoldersLoaded value)?  foldersLoaded,TResult? Function( _LoadingItems value)?  loadingItems,TResult? Function( _ItemsLoaded value)?  itemsLoaded,TResult? Function( _Importing value)?  importing,TResult? Function( _Completed value)?  completed,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case _LoadingFolders() when loadingFolders != null:
return loadingFolders(_that);case _FoldersLoaded() when foldersLoaded != null:
return foldersLoaded(_that);case _LoadingItems() when loadingItems != null:
return loadingItems(_that);case _ItemsLoaded() when itemsLoaded != null:
return itemsLoaded(_that);case _Importing() when importing != null:
return importing(_that);case _Completed() when completed != null:
return completed(_that);case _Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  loadingFolders,TResult Function( List<BiliFavFolder> createdFolders,  List<BiliFavFolder> collectedFolders)?  foldersLoaded,TResult Function( String folderName,  int fetched,  int total)?  loadingItems,TResult Function( String folderName,  List<BiliFavItem> items)?  itemsLoaded,TResult Function( int current,  int total)?  importing,TResult Function( int playlistId,  int imported,  int reused,  int failed,  List<String> failedBvids)?  completed,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case _LoadingFolders() when loadingFolders != null:
return loadingFolders();case _FoldersLoaded() when foldersLoaded != null:
return foldersLoaded(_that.createdFolders,_that.collectedFolders);case _LoadingItems() when loadingItems != null:
return loadingItems(_that.folderName,_that.fetched,_that.total);case _ItemsLoaded() when itemsLoaded != null:
return itemsLoaded(_that.folderName,_that.items);case _Importing() when importing != null:
return importing(_that.current,_that.total);case _Completed() when completed != null:
return completed(_that.playlistId,_that.imported,_that.reused,_that.failed,_that.failedBvids);case _Error() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  loadingFolders,required TResult Function( List<BiliFavFolder> createdFolders,  List<BiliFavFolder> collectedFolders)  foldersLoaded,required TResult Function( String folderName,  int fetched,  int total)  loadingItems,required TResult Function( String folderName,  List<BiliFavItem> items)  itemsLoaded,required TResult Function( int current,  int total)  importing,required TResult Function( int playlistId,  int imported,  int reused,  int failed,  List<String> failedBvids)  completed,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Idle():
return idle();case _LoadingFolders():
return loadingFolders();case _FoldersLoaded():
return foldersLoaded(_that.createdFolders,_that.collectedFolders);case _LoadingItems():
return loadingItems(_that.folderName,_that.fetched,_that.total);case _ItemsLoaded():
return itemsLoaded(_that.folderName,_that.items);case _Importing():
return importing(_that.current,_that.total);case _Completed():
return completed(_that.playlistId,_that.imported,_that.reused,_that.failed,_that.failedBvids);case _Error():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  loadingFolders,TResult? Function( List<BiliFavFolder> createdFolders,  List<BiliFavFolder> collectedFolders)?  foldersLoaded,TResult? Function( String folderName,  int fetched,  int total)?  loadingItems,TResult? Function( String folderName,  List<BiliFavItem> items)?  itemsLoaded,TResult? Function( int current,  int total)?  importing,TResult? Function( int playlistId,  int imported,  int reused,  int failed,  List<String> failedBvids)?  completed,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case _LoadingFolders() when loadingFolders != null:
return loadingFolders();case _FoldersLoaded() when foldersLoaded != null:
return foldersLoaded(_that.createdFolders,_that.collectedFolders);case _LoadingItems() when loadingItems != null:
return loadingItems(_that.folderName,_that.fetched,_that.total);case _ItemsLoaded() when itemsLoaded != null:
return itemsLoaded(_that.folderName,_that.items);case _Importing() when importing != null:
return importing(_that.current,_that.total);case _Completed() when completed != null:
return completed(_that.playlistId,_that.imported,_that.reused,_that.failed,_that.failedBvids);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Idle implements BiliFavImportState {
  const _Idle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Idle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BiliFavImportState.idle()';
}


}




/// @nodoc


class _LoadingFolders implements BiliFavImportState {
  const _LoadingFolders();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadingFolders);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BiliFavImportState.loadingFolders()';
}


}




/// @nodoc


class _FoldersLoaded implements BiliFavImportState {
  const _FoldersLoaded(final  List<BiliFavFolder> createdFolders, final  List<BiliFavFolder> collectedFolders): _createdFolders = createdFolders,_collectedFolders = collectedFolders;
  

 final  List<BiliFavFolder> _createdFolders;
 List<BiliFavFolder> get createdFolders {
  if (_createdFolders is EqualUnmodifiableListView) return _createdFolders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_createdFolders);
}

 final  List<BiliFavFolder> _collectedFolders;
 List<BiliFavFolder> get collectedFolders {
  if (_collectedFolders is EqualUnmodifiableListView) return _collectedFolders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_collectedFolders);
}


/// Create a copy of BiliFavImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoldersLoadedCopyWith<_FoldersLoaded> get copyWith => __$FoldersLoadedCopyWithImpl<_FoldersLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoldersLoaded&&const DeepCollectionEquality().equals(other._createdFolders, _createdFolders)&&const DeepCollectionEquality().equals(other._collectedFolders, _collectedFolders));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_createdFolders),const DeepCollectionEquality().hash(_collectedFolders));

@override
String toString() {
  return 'BiliFavImportState.foldersLoaded(createdFolders: $createdFolders, collectedFolders: $collectedFolders)';
}


}

/// @nodoc
abstract mixin class _$FoldersLoadedCopyWith<$Res> implements $BiliFavImportStateCopyWith<$Res> {
  factory _$FoldersLoadedCopyWith(_FoldersLoaded value, $Res Function(_FoldersLoaded) _then) = __$FoldersLoadedCopyWithImpl;
@useResult
$Res call({
 List<BiliFavFolder> createdFolders, List<BiliFavFolder> collectedFolders
});




}
/// @nodoc
class __$FoldersLoadedCopyWithImpl<$Res>
    implements _$FoldersLoadedCopyWith<$Res> {
  __$FoldersLoadedCopyWithImpl(this._self, this._then);

  final _FoldersLoaded _self;
  final $Res Function(_FoldersLoaded) _then;

/// Create a copy of BiliFavImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? createdFolders = null,Object? collectedFolders = null,}) {
  return _then(_FoldersLoaded(
null == createdFolders ? _self._createdFolders : createdFolders // ignore: cast_nullable_to_non_nullable
as List<BiliFavFolder>,null == collectedFolders ? _self._collectedFolders : collectedFolders // ignore: cast_nullable_to_non_nullable
as List<BiliFavFolder>,
  ));
}


}

/// @nodoc


class _LoadingItems implements BiliFavImportState {
  const _LoadingItems({required this.folderName, required this.fetched, required this.total});
  

 final  String folderName;
 final  int fetched;
 final  int total;

/// Create a copy of BiliFavImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadingItemsCopyWith<_LoadingItems> get copyWith => __$LoadingItemsCopyWithImpl<_LoadingItems>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadingItems&&(identical(other.folderName, folderName) || other.folderName == folderName)&&(identical(other.fetched, fetched) || other.fetched == fetched)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,folderName,fetched,total);

@override
String toString() {
  return 'BiliFavImportState.loadingItems(folderName: $folderName, fetched: $fetched, total: $total)';
}


}

/// @nodoc
abstract mixin class _$LoadingItemsCopyWith<$Res> implements $BiliFavImportStateCopyWith<$Res> {
  factory _$LoadingItemsCopyWith(_LoadingItems value, $Res Function(_LoadingItems) _then) = __$LoadingItemsCopyWithImpl;
@useResult
$Res call({
 String folderName, int fetched, int total
});




}
/// @nodoc
class __$LoadingItemsCopyWithImpl<$Res>
    implements _$LoadingItemsCopyWith<$Res> {
  __$LoadingItemsCopyWithImpl(this._self, this._then);

  final _LoadingItems _self;
  final $Res Function(_LoadingItems) _then;

/// Create a copy of BiliFavImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? folderName = null,Object? fetched = null,Object? total = null,}) {
  return _then(_LoadingItems(
folderName: null == folderName ? _self.folderName : folderName // ignore: cast_nullable_to_non_nullable
as String,fetched: null == fetched ? _self.fetched : fetched // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _ItemsLoaded implements BiliFavImportState {
  const _ItemsLoaded({required this.folderName, required final  List<BiliFavItem> items}): _items = items;
  

 final  String folderName;
 final  List<BiliFavItem> _items;
 List<BiliFavItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of BiliFavImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemsLoadedCopyWith<_ItemsLoaded> get copyWith => __$ItemsLoadedCopyWithImpl<_ItemsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemsLoaded&&(identical(other.folderName, folderName) || other.folderName == folderName)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,folderName,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'BiliFavImportState.itemsLoaded(folderName: $folderName, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ItemsLoadedCopyWith<$Res> implements $BiliFavImportStateCopyWith<$Res> {
  factory _$ItemsLoadedCopyWith(_ItemsLoaded value, $Res Function(_ItemsLoaded) _then) = __$ItemsLoadedCopyWithImpl;
@useResult
$Res call({
 String folderName, List<BiliFavItem> items
});




}
/// @nodoc
class __$ItemsLoadedCopyWithImpl<$Res>
    implements _$ItemsLoadedCopyWith<$Res> {
  __$ItemsLoadedCopyWithImpl(this._self, this._then);

  final _ItemsLoaded _self;
  final $Res Function(_ItemsLoaded) _then;

/// Create a copy of BiliFavImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? folderName = null,Object? items = null,}) {
  return _then(_ItemsLoaded(
folderName: null == folderName ? _self.folderName : folderName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BiliFavItem>,
  ));
}


}

/// @nodoc


class _Importing implements BiliFavImportState {
  const _Importing({required this.current, required this.total});
  

 final  int current;
 final  int total;

/// Create a copy of BiliFavImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportingCopyWith<_Importing> get copyWith => __$ImportingCopyWithImpl<_Importing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Importing&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,current,total);

@override
String toString() {
  return 'BiliFavImportState.importing(current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class _$ImportingCopyWith<$Res> implements $BiliFavImportStateCopyWith<$Res> {
  factory _$ImportingCopyWith(_Importing value, $Res Function(_Importing) _then) = __$ImportingCopyWithImpl;
@useResult
$Res call({
 int current, int total
});




}
/// @nodoc
class __$ImportingCopyWithImpl<$Res>
    implements _$ImportingCopyWith<$Res> {
  __$ImportingCopyWithImpl(this._self, this._then);

  final _Importing _self;
  final $Res Function(_Importing) _then;

/// Create a copy of BiliFavImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? current = null,Object? total = null,}) {
  return _then(_Importing(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _Completed implements BiliFavImportState {
  const _Completed({required this.playlistId, required this.imported, required this.reused, required this.failed, required final  List<String> failedBvids}): _failedBvids = failedBvids;
  

 final  int playlistId;
 final  int imported;
 final  int reused;
 final  int failed;
 final  List<String> _failedBvids;
 List<String> get failedBvids {
  if (_failedBvids is EqualUnmodifiableListView) return _failedBvids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failedBvids);
}


/// Create a copy of BiliFavImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompletedCopyWith<_Completed> get copyWith => __$CompletedCopyWithImpl<_Completed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Completed&&(identical(other.playlistId, playlistId) || other.playlistId == playlistId)&&(identical(other.imported, imported) || other.imported == imported)&&(identical(other.reused, reused) || other.reused == reused)&&(identical(other.failed, failed) || other.failed == failed)&&const DeepCollectionEquality().equals(other._failedBvids, _failedBvids));
}


@override
int get hashCode => Object.hash(runtimeType,playlistId,imported,reused,failed,const DeepCollectionEquality().hash(_failedBvids));

@override
String toString() {
  return 'BiliFavImportState.completed(playlistId: $playlistId, imported: $imported, reused: $reused, failed: $failed, failedBvids: $failedBvids)';
}


}

/// @nodoc
abstract mixin class _$CompletedCopyWith<$Res> implements $BiliFavImportStateCopyWith<$Res> {
  factory _$CompletedCopyWith(_Completed value, $Res Function(_Completed) _then) = __$CompletedCopyWithImpl;
@useResult
$Res call({
 int playlistId, int imported, int reused, int failed, List<String> failedBvids
});




}
/// @nodoc
class __$CompletedCopyWithImpl<$Res>
    implements _$CompletedCopyWith<$Res> {
  __$CompletedCopyWithImpl(this._self, this._then);

  final _Completed _self;
  final $Res Function(_Completed) _then;

/// Create a copy of BiliFavImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playlistId = null,Object? imported = null,Object? reused = null,Object? failed = null,Object? failedBvids = null,}) {
  return _then(_Completed(
playlistId: null == playlistId ? _self.playlistId : playlistId // ignore: cast_nullable_to_non_nullable
as int,imported: null == imported ? _self.imported : imported // ignore: cast_nullable_to_non_nullable
as int,reused: null == reused ? _self.reused : reused // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,failedBvids: null == failedBvids ? _self._failedBvids : failedBvids // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class _Error implements BiliFavImportState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of BiliFavImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BiliFavImportState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $BiliFavImportStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of BiliFavImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
