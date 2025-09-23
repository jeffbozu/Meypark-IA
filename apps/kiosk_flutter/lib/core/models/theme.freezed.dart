// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppTheme _$AppThemeFromJson(Map<String, dynamic> json) {
  return _AppTheme.fromJson(json);
}

/// @nodoc
mixin _$AppTheme {
  String get id => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get scope =>
      throw _privateConstructorUsedError; // 'initial_screen' or 'default_ui'
  Map<String, dynamic> get colorsJson => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AppTheme to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppTheme
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppThemeCopyWith<AppTheme> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppThemeCopyWith<$Res> {
  factory $AppThemeCopyWith(AppTheme value, $Res Function(AppTheme) then) =
      _$AppThemeCopyWithImpl<$Res, AppTheme>;
  @useResult
  $Res call(
      {String id,
      String companyId,
      String scope,
      Map<String, dynamic> colorsJson,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$AppThemeCopyWithImpl<$Res, $Val extends AppTheme>
    implements $AppThemeCopyWith<$Res> {
  _$AppThemeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppTheme
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? scope = null,
    Object? colorsJson = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String,
      colorsJson: null == colorsJson
          ? _value.colorsJson
          : colorsJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppThemeImplCopyWith<$Res>
    implements $AppThemeCopyWith<$Res> {
  factory _$$AppThemeImplCopyWith(
          _$AppThemeImpl value, $Res Function(_$AppThemeImpl) then) =
      __$$AppThemeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String companyId,
      String scope,
      Map<String, dynamic> colorsJson,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$AppThemeImplCopyWithImpl<$Res>
    extends _$AppThemeCopyWithImpl<$Res, _$AppThemeImpl>
    implements _$$AppThemeImplCopyWith<$Res> {
  __$$AppThemeImplCopyWithImpl(
      _$AppThemeImpl _value, $Res Function(_$AppThemeImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppTheme
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? scope = null,
    Object? colorsJson = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$AppThemeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String,
      colorsJson: null == colorsJson
          ? _value._colorsJson
          : colorsJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppThemeImpl implements _AppTheme {
  const _$AppThemeImpl(
      {required this.id,
      required this.companyId,
      required this.scope,
      required final Map<String, dynamic> colorsJson,
      required this.createdAt,
      required this.updatedAt})
      : _colorsJson = colorsJson;

  factory _$AppThemeImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppThemeImplFromJson(json);

  @override
  final String id;
  @override
  final String companyId;
  @override
  final String scope;
// 'initial_screen' or 'default_ui'
  final Map<String, dynamic> _colorsJson;
// 'initial_screen' or 'default_ui'
  @override
  Map<String, dynamic> get colorsJson {
    if (_colorsJson is EqualUnmodifiableMapView) return _colorsJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_colorsJson);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AppTheme(id: $id, companyId: $companyId, scope: $scope, colorsJson: $colorsJson, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppThemeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            const DeepCollectionEquality()
                .equals(other._colorsJson, _colorsJson) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, companyId, scope,
      const DeepCollectionEquality().hash(_colorsJson), createdAt, updatedAt);

  /// Create a copy of AppTheme
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppThemeImplCopyWith<_$AppThemeImpl> get copyWith =>
      __$$AppThemeImplCopyWithImpl<_$AppThemeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppThemeImplToJson(
      this,
    );
  }
}

abstract class _AppTheme implements AppTheme {
  const factory _AppTheme(
      {required final String id,
      required final String companyId,
      required final String scope,
      required final Map<String, dynamic> colorsJson,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$AppThemeImpl;

  factory _AppTheme.fromJson(Map<String, dynamic> json) =
      _$AppThemeImpl.fromJson;

  @override
  String get id;
  @override
  String get companyId;
  @override
  String get scope; // 'initial_screen' or 'default_ui'
  @override
  Map<String, dynamic> get colorsJson;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of AppTheme
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppThemeImplCopyWith<_$AppThemeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UIOverrides _$UIOverridesFromJson(Map<String, dynamic> json) {
  return _UIOverrides.fromJson(json);
}

/// @nodoc
mixin _$UIOverrides {
  String get id => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  String get scope => throw _privateConstructorUsedError;
  Map<String, dynamic> get visibilityJson => throw _privateConstructorUsedError;
  Map<String, dynamic> get textOverridesJson =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UIOverrides to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UIOverrides
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UIOverridesCopyWith<UIOverrides> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UIOverridesCopyWith<$Res> {
  factory $UIOverridesCopyWith(
          UIOverrides value, $Res Function(UIOverrides) then) =
      _$UIOverridesCopyWithImpl<$Res, UIOverrides>;
  @useResult
  $Res call(
      {String id,
      String companyId,
      String? deviceId,
      String scope,
      Map<String, dynamic> visibilityJson,
      Map<String, dynamic> textOverridesJson,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$UIOverridesCopyWithImpl<$Res, $Val extends UIOverrides>
    implements $UIOverridesCopyWith<$Res> {
  _$UIOverridesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UIOverrides
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? deviceId = freezed,
    Object? scope = null,
    Object? visibilityJson = null,
    Object? textOverridesJson = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String,
      visibilityJson: null == visibilityJson
          ? _value.visibilityJson
          : visibilityJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      textOverridesJson: null == textOverridesJson
          ? _value.textOverridesJson
          : textOverridesJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UIOverridesImplCopyWith<$Res>
    implements $UIOverridesCopyWith<$Res> {
  factory _$$UIOverridesImplCopyWith(
          _$UIOverridesImpl value, $Res Function(_$UIOverridesImpl) then) =
      __$$UIOverridesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String companyId,
      String? deviceId,
      String scope,
      Map<String, dynamic> visibilityJson,
      Map<String, dynamic> textOverridesJson,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$UIOverridesImplCopyWithImpl<$Res>
    extends _$UIOverridesCopyWithImpl<$Res, _$UIOverridesImpl>
    implements _$$UIOverridesImplCopyWith<$Res> {
  __$$UIOverridesImplCopyWithImpl(
      _$UIOverridesImpl _value, $Res Function(_$UIOverridesImpl) _then)
      : super(_value, _then);

  /// Create a copy of UIOverrides
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? deviceId = freezed,
    Object? scope = null,
    Object? visibilityJson = null,
    Object? textOverridesJson = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UIOverridesImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String,
      visibilityJson: null == visibilityJson
          ? _value._visibilityJson
          : visibilityJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      textOverridesJson: null == textOverridesJson
          ? _value._textOverridesJson
          : textOverridesJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UIOverridesImpl implements _UIOverrides {
  const _$UIOverridesImpl(
      {required this.id,
      required this.companyId,
      this.deviceId,
      required this.scope,
      required final Map<String, dynamic> visibilityJson,
      required final Map<String, dynamic> textOverridesJson,
      required this.createdAt,
      required this.updatedAt})
      : _visibilityJson = visibilityJson,
        _textOverridesJson = textOverridesJson;

  factory _$UIOverridesImpl.fromJson(Map<String, dynamic> json) =>
      _$$UIOverridesImplFromJson(json);

  @override
  final String id;
  @override
  final String companyId;
  @override
  final String? deviceId;
  @override
  final String scope;
  final Map<String, dynamic> _visibilityJson;
  @override
  Map<String, dynamic> get visibilityJson {
    if (_visibilityJson is EqualUnmodifiableMapView) return _visibilityJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_visibilityJson);
  }

  final Map<String, dynamic> _textOverridesJson;
  @override
  Map<String, dynamic> get textOverridesJson {
    if (_textOverridesJson is EqualUnmodifiableMapView)
      return _textOverridesJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_textOverridesJson);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UIOverrides(id: $id, companyId: $companyId, deviceId: $deviceId, scope: $scope, visibilityJson: $visibilityJson, textOverridesJson: $textOverridesJson, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UIOverridesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            const DeepCollectionEquality()
                .equals(other._visibilityJson, _visibilityJson) &&
            const DeepCollectionEquality()
                .equals(other._textOverridesJson, _textOverridesJson) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      companyId,
      deviceId,
      scope,
      const DeepCollectionEquality().hash(_visibilityJson),
      const DeepCollectionEquality().hash(_textOverridesJson),
      createdAt,
      updatedAt);

  /// Create a copy of UIOverrides
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UIOverridesImplCopyWith<_$UIOverridesImpl> get copyWith =>
      __$$UIOverridesImplCopyWithImpl<_$UIOverridesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UIOverridesImplToJson(
      this,
    );
  }
}

abstract class _UIOverrides implements UIOverrides {
  const factory _UIOverrides(
      {required final String id,
      required final String companyId,
      final String? deviceId,
      required final String scope,
      required final Map<String, dynamic> visibilityJson,
      required final Map<String, dynamic> textOverridesJson,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UIOverridesImpl;

  factory _UIOverrides.fromJson(Map<String, dynamic> json) =
      _$UIOverridesImpl.fromJson;

  @override
  String get id;
  @override
  String get companyId;
  @override
  String? get deviceId;
  @override
  String get scope;
  @override
  Map<String, dynamic> get visibilityJson;
  @override
  Map<String, dynamic> get textOverridesJson;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of UIOverrides
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UIOverridesImplCopyWith<_$UIOverridesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeviceConfig _$DeviceConfigFromJson(Map<String, dynamic> json) {
  return _DeviceConfig.fromJson(json);
}

/// @nodoc
mixin _$DeviceConfig {
  String get id => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get alias => throw _privateConstructorUsedError;
  String get serial => throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError;
  String get appVersion => throw _privateConstructorUsedError;
  DateTime get lastSeen => throw _privateConstructorUsedError;
  Map<String, dynamic> get flagsJson => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DeviceConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceConfigCopyWith<DeviceConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceConfigCopyWith<$Res> {
  factory $DeviceConfigCopyWith(
          DeviceConfig value, $Res Function(DeviceConfig) then) =
      _$DeviceConfigCopyWithImpl<$Res, DeviceConfig>;
  @useResult
  $Res call(
      {String id,
      String companyId,
      String alias,
      String serial,
      String timezone,
      String appVersion,
      DateTime lastSeen,
      Map<String, dynamic> flagsJson,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$DeviceConfigCopyWithImpl<$Res, $Val extends DeviceConfig>
    implements $DeviceConfigCopyWith<$Res> {
  _$DeviceConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? alias = null,
    Object? serial = null,
    Object? timezone = null,
    Object? appVersion = null,
    Object? lastSeen = null,
    Object? flagsJson = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      alias: null == alias
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String,
      serial: null == serial
          ? _value.serial
          : serial // ignore: cast_nullable_to_non_nullable
              as String,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      lastSeen: null == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      flagsJson: null == flagsJson
          ? _value.flagsJson
          : flagsJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceConfigImplCopyWith<$Res>
    implements $DeviceConfigCopyWith<$Res> {
  factory _$$DeviceConfigImplCopyWith(
          _$DeviceConfigImpl value, $Res Function(_$DeviceConfigImpl) then) =
      __$$DeviceConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String companyId,
      String alias,
      String serial,
      String timezone,
      String appVersion,
      DateTime lastSeen,
      Map<String, dynamic> flagsJson,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$DeviceConfigImplCopyWithImpl<$Res>
    extends _$DeviceConfigCopyWithImpl<$Res, _$DeviceConfigImpl>
    implements _$$DeviceConfigImplCopyWith<$Res> {
  __$$DeviceConfigImplCopyWithImpl(
      _$DeviceConfigImpl _value, $Res Function(_$DeviceConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeviceConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? alias = null,
    Object? serial = null,
    Object? timezone = null,
    Object? appVersion = null,
    Object? lastSeen = null,
    Object? flagsJson = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$DeviceConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      alias: null == alias
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String,
      serial: null == serial
          ? _value.serial
          : serial // ignore: cast_nullable_to_non_nullable
              as String,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      lastSeen: null == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      flagsJson: null == flagsJson
          ? _value._flagsJson
          : flagsJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceConfigImpl implements _DeviceConfig {
  const _$DeviceConfigImpl(
      {required this.id,
      required this.companyId,
      required this.alias,
      required this.serial,
      required this.timezone,
      required this.appVersion,
      required this.lastSeen,
      required final Map<String, dynamic> flagsJson,
      required this.createdAt,
      required this.updatedAt})
      : _flagsJson = flagsJson;

  factory _$DeviceConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String companyId;
  @override
  final String alias;
  @override
  final String serial;
  @override
  final String timezone;
  @override
  final String appVersion;
  @override
  final DateTime lastSeen;
  final Map<String, dynamic> _flagsJson;
  @override
  Map<String, dynamic> get flagsJson {
    if (_flagsJson is EqualUnmodifiableMapView) return _flagsJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_flagsJson);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'DeviceConfig(id: $id, companyId: $companyId, alias: $alias, serial: $serial, timezone: $timezone, appVersion: $appVersion, lastSeen: $lastSeen, flagsJson: $flagsJson, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.alias, alias) || other.alias == alias) &&
            (identical(other.serial, serial) || other.serial == serial) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            const DeepCollectionEquality()
                .equals(other._flagsJson, _flagsJson) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      companyId,
      alias,
      serial,
      timezone,
      appVersion,
      lastSeen,
      const DeepCollectionEquality().hash(_flagsJson),
      createdAt,
      updatedAt);

  /// Create a copy of DeviceConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceConfigImplCopyWith<_$DeviceConfigImpl> get copyWith =>
      __$$DeviceConfigImplCopyWithImpl<_$DeviceConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceConfigImplToJson(
      this,
    );
  }
}

abstract class _DeviceConfig implements DeviceConfig {
  const factory _DeviceConfig(
      {required final String id,
      required final String companyId,
      required final String alias,
      required final String serial,
      required final String timezone,
      required final String appVersion,
      required final DateTime lastSeen,
      required final Map<String, dynamic> flagsJson,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$DeviceConfigImpl;

  factory _DeviceConfig.fromJson(Map<String, dynamic> json) =
      _$DeviceConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get companyId;
  @override
  String get alias;
  @override
  String get serial;
  @override
  String get timezone;
  @override
  String get appVersion;
  @override
  DateTime get lastSeen;
  @override
  Map<String, dynamic> get flagsJson;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of DeviceConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceConfigImplCopyWith<_$DeviceConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
