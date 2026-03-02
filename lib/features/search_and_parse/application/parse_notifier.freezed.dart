// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parse_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ParseState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() parsing,
    required TResult Function(BvidInfo info) success,
    required TResult Function(BvidInfo info, List<PageInfo> selectedPages)
        selectingPages,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? parsing,
    TResult? Function(BvidInfo info)? success,
    TResult? Function(BvidInfo info, List<PageInfo> selectedPages)?
        selectingPages,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? parsing,
    TResult Function(BvidInfo info)? success,
    TResult Function(BvidInfo info, List<PageInfo> selectedPages)?
        selectingPages,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Parsing value) parsing,
    required TResult Function(_Success value) success,
    required TResult Function(_SelectingPages value) selectingPages,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Parsing value)? parsing,
    TResult? Function(_Success value)? success,
    TResult? Function(_SelectingPages value)? selectingPages,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Parsing value)? parsing,
    TResult Function(_Success value)? success,
    TResult Function(_SelectingPages value)? selectingPages,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParseStateCopyWith<$Res> {
  factory $ParseStateCopyWith(
          ParseState value, $Res Function(ParseState) then) =
      _$ParseStateCopyWithImpl<$Res, ParseState>;
}

/// @nodoc
class _$ParseStateCopyWithImpl<$Res, $Val extends ParseState>
    implements $ParseStateCopyWith<$Res> {
  _$ParseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParseState
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
    extends _$ParseStateCopyWithImpl<$Res, _$IdleImpl>
    implements _$$IdleImplCopyWith<$Res> {
  __$$IdleImplCopyWithImpl(_$IdleImpl _value, $Res Function(_$IdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParseState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$IdleImpl implements _Idle {
  const _$IdleImpl();

  @override
  String toString() {
    return 'ParseState.idle()';
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
    required TResult Function() parsing,
    required TResult Function(BvidInfo info) success,
    required TResult Function(BvidInfo info, List<PageInfo> selectedPages)
        selectingPages,
    required TResult Function(String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? parsing,
    TResult? Function(BvidInfo info)? success,
    TResult? Function(BvidInfo info, List<PageInfo> selectedPages)?
        selectingPages,
    TResult? Function(String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? parsing,
    TResult Function(BvidInfo info)? success,
    TResult Function(BvidInfo info, List<PageInfo> selectedPages)?
        selectingPages,
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
    required TResult Function(_Parsing value) parsing,
    required TResult Function(_Success value) success,
    required TResult Function(_SelectingPages value) selectingPages,
    required TResult Function(_Error value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Parsing value)? parsing,
    TResult? Function(_Success value)? success,
    TResult? Function(_SelectingPages value)? selectingPages,
    TResult? Function(_Error value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Parsing value)? parsing,
    TResult Function(_Success value)? success,
    TResult Function(_SelectingPages value)? selectingPages,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class _Idle implements ParseState {
  const factory _Idle() = _$IdleImpl;
}

/// @nodoc
abstract class _$$ParsingImplCopyWith<$Res> {
  factory _$$ParsingImplCopyWith(
          _$ParsingImpl value, $Res Function(_$ParsingImpl) then) =
      __$$ParsingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ParsingImplCopyWithImpl<$Res>
    extends _$ParseStateCopyWithImpl<$Res, _$ParsingImpl>
    implements _$$ParsingImplCopyWith<$Res> {
  __$$ParsingImplCopyWithImpl(
      _$ParsingImpl _value, $Res Function(_$ParsingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParseState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ParsingImpl implements _Parsing {
  const _$ParsingImpl();

  @override
  String toString() {
    return 'ParseState.parsing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ParsingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() parsing,
    required TResult Function(BvidInfo info) success,
    required TResult Function(BvidInfo info, List<PageInfo> selectedPages)
        selectingPages,
    required TResult Function(String message) error,
  }) {
    return parsing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? parsing,
    TResult? Function(BvidInfo info)? success,
    TResult? Function(BvidInfo info, List<PageInfo> selectedPages)?
        selectingPages,
    TResult? Function(String message)? error,
  }) {
    return parsing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? parsing,
    TResult Function(BvidInfo info)? success,
    TResult Function(BvidInfo info, List<PageInfo> selectedPages)?
        selectingPages,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (parsing != null) {
      return parsing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Parsing value) parsing,
    required TResult Function(_Success value) success,
    required TResult Function(_SelectingPages value) selectingPages,
    required TResult Function(_Error value) error,
  }) {
    return parsing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Parsing value)? parsing,
    TResult? Function(_Success value)? success,
    TResult? Function(_SelectingPages value)? selectingPages,
    TResult? Function(_Error value)? error,
  }) {
    return parsing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Parsing value)? parsing,
    TResult Function(_Success value)? success,
    TResult Function(_SelectingPages value)? selectingPages,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (parsing != null) {
      return parsing(this);
    }
    return orElse();
  }
}

abstract class _Parsing implements ParseState {
  const factory _Parsing() = _$ParsingImpl;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<$Res> {
  factory _$$SuccessImplCopyWith(
          _$SuccessImpl value, $Res Function(_$SuccessImpl) then) =
      __$$SuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BvidInfo info});

  $BvidInfoCopyWith<$Res> get info;
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<$Res>
    extends _$ParseStateCopyWithImpl<$Res, _$SuccessImpl>
    implements _$$SuccessImplCopyWith<$Res> {
  __$$SuccessImplCopyWithImpl(
      _$SuccessImpl _value, $Res Function(_$SuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? info = null,
  }) {
    return _then(_$SuccessImpl(
      null == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as BvidInfo,
    ));
  }

  /// Create a copy of ParseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BvidInfoCopyWith<$Res> get info {
    return $BvidInfoCopyWith<$Res>(_value.info, (value) {
      return _then(_value.copyWith(info: value));
    });
  }
}

/// @nodoc

class _$SuccessImpl implements _Success {
  const _$SuccessImpl(this.info);

  @override
  final BvidInfo info;

  @override
  String toString() {
    return 'ParseState.success(info: $info)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl &&
            (identical(other.info, info) || other.info == info));
  }

  @override
  int get hashCode => Object.hash(runtimeType, info);

  /// Create a copy of ParseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      __$$SuccessImplCopyWithImpl<_$SuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() parsing,
    required TResult Function(BvidInfo info) success,
    required TResult Function(BvidInfo info, List<PageInfo> selectedPages)
        selectingPages,
    required TResult Function(String message) error,
  }) {
    return success(info);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? parsing,
    TResult? Function(BvidInfo info)? success,
    TResult? Function(BvidInfo info, List<PageInfo> selectedPages)?
        selectingPages,
    TResult? Function(String message)? error,
  }) {
    return success?.call(info);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? parsing,
    TResult Function(BvidInfo info)? success,
    TResult Function(BvidInfo info, List<PageInfo> selectedPages)?
        selectingPages,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(info);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Parsing value) parsing,
    required TResult Function(_Success value) success,
    required TResult Function(_SelectingPages value) selectingPages,
    required TResult Function(_Error value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Parsing value)? parsing,
    TResult? Function(_Success value)? success,
    TResult? Function(_SelectingPages value)? selectingPages,
    TResult? Function(_Error value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Parsing value)? parsing,
    TResult Function(_Success value)? success,
    TResult Function(_SelectingPages value)? selectingPages,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _Success implements ParseState {
  const factory _Success(final BvidInfo info) = _$SuccessImpl;

  BvidInfo get info;

  /// Create a copy of ParseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SelectingPagesImplCopyWith<$Res> {
  factory _$$SelectingPagesImplCopyWith(_$SelectingPagesImpl value,
          $Res Function(_$SelectingPagesImpl) then) =
      __$$SelectingPagesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BvidInfo info, List<PageInfo> selectedPages});

  $BvidInfoCopyWith<$Res> get info;
}

/// @nodoc
class __$$SelectingPagesImplCopyWithImpl<$Res>
    extends _$ParseStateCopyWithImpl<$Res, _$SelectingPagesImpl>
    implements _$$SelectingPagesImplCopyWith<$Res> {
  __$$SelectingPagesImplCopyWithImpl(
      _$SelectingPagesImpl _value, $Res Function(_$SelectingPagesImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? info = null,
    Object? selectedPages = null,
  }) {
    return _then(_$SelectingPagesImpl(
      null == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as BvidInfo,
      null == selectedPages
          ? _value._selectedPages
          : selectedPages // ignore: cast_nullable_to_non_nullable
              as List<PageInfo>,
    ));
  }

  /// Create a copy of ParseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BvidInfoCopyWith<$Res> get info {
    return $BvidInfoCopyWith<$Res>(_value.info, (value) {
      return _then(_value.copyWith(info: value));
    });
  }
}

/// @nodoc

class _$SelectingPagesImpl implements _SelectingPages {
  const _$SelectingPagesImpl(this.info, final List<PageInfo> selectedPages)
      : _selectedPages = selectedPages;

  @override
  final BvidInfo info;
  final List<PageInfo> _selectedPages;
  @override
  List<PageInfo> get selectedPages {
    if (_selectedPages is EqualUnmodifiableListView) return _selectedPages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedPages);
  }

  @override
  String toString() {
    return 'ParseState.selectingPages(info: $info, selectedPages: $selectedPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectingPagesImpl &&
            (identical(other.info, info) || other.info == info) &&
            const DeepCollectionEquality()
                .equals(other._selectedPages, _selectedPages));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, info, const DeepCollectionEquality().hash(_selectedPages));

  /// Create a copy of ParseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectingPagesImplCopyWith<_$SelectingPagesImpl> get copyWith =>
      __$$SelectingPagesImplCopyWithImpl<_$SelectingPagesImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() parsing,
    required TResult Function(BvidInfo info) success,
    required TResult Function(BvidInfo info, List<PageInfo> selectedPages)
        selectingPages,
    required TResult Function(String message) error,
  }) {
    return selectingPages(info, selectedPages);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? parsing,
    TResult? Function(BvidInfo info)? success,
    TResult? Function(BvidInfo info, List<PageInfo> selectedPages)?
        selectingPages,
    TResult? Function(String message)? error,
  }) {
    return selectingPages?.call(info, selectedPages);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? parsing,
    TResult Function(BvidInfo info)? success,
    TResult Function(BvidInfo info, List<PageInfo> selectedPages)?
        selectingPages,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (selectingPages != null) {
      return selectingPages(info, selectedPages);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Parsing value) parsing,
    required TResult Function(_Success value) success,
    required TResult Function(_SelectingPages value) selectingPages,
    required TResult Function(_Error value) error,
  }) {
    return selectingPages(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Parsing value)? parsing,
    TResult? Function(_Success value)? success,
    TResult? Function(_SelectingPages value)? selectingPages,
    TResult? Function(_Error value)? error,
  }) {
    return selectingPages?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Parsing value)? parsing,
    TResult Function(_Success value)? success,
    TResult Function(_SelectingPages value)? selectingPages,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (selectingPages != null) {
      return selectingPages(this);
    }
    return orElse();
  }
}

abstract class _SelectingPages implements ParseState {
  const factory _SelectingPages(
          final BvidInfo info, final List<PageInfo> selectedPages) =
      _$SelectingPagesImpl;

  BvidInfo get info;
  List<PageInfo> get selectedPages;

  /// Create a copy of ParseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectingPagesImplCopyWith<_$SelectingPagesImpl> get copyWith =>
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
    extends _$ParseStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParseState
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
    return 'ParseState.error(message: $message)';
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

  /// Create a copy of ParseState
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
    required TResult Function() parsing,
    required TResult Function(BvidInfo info) success,
    required TResult Function(BvidInfo info, List<PageInfo> selectedPages)
        selectingPages,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? parsing,
    TResult? Function(BvidInfo info)? success,
    TResult? Function(BvidInfo info, List<PageInfo> selectedPages)?
        selectingPages,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? parsing,
    TResult Function(BvidInfo info)? success,
    TResult Function(BvidInfo info, List<PageInfo> selectedPages)?
        selectingPages,
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
    required TResult Function(_Parsing value) parsing,
    required TResult Function(_Success value) success,
    required TResult Function(_SelectingPages value) selectingPages,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Parsing value)? parsing,
    TResult? Function(_Success value)? success,
    TResult? Function(_SelectingPages value)? selectingPages,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Parsing value)? parsing,
    TResult Function(_Success value)? success,
    TResult Function(_SelectingPages value)? selectingPages,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements ParseState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of ParseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
