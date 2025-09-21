// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accessibility.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AccessibilityPrefs _$AccessibilityPrefsFromJson(Map<String, dynamic> json) {
  return _AccessibilityPrefs.fromJson(json);
}

/// @nodoc
mixin _$AccessibilityPrefs {
  String get id => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;
  Map<String, dynamic> get comboJson => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AccessibilityPrefs to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccessibilityPrefs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccessibilityPrefsCopyWith<AccessibilityPrefs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccessibilityPrefsCopyWith<$Res> {
  factory $AccessibilityPrefsCopyWith(
          AccessibilityPrefs value, $Res Function(AccessibilityPrefs) then) =
      _$AccessibilityPrefsCopyWithImpl<$Res, AccessibilityPrefs>;
  @useResult
  $Res call(
      {String id,
      String deviceId,
      Map<String, dynamic> comboJson,
      DateTime createdAt});
}

/// @nodoc
class _$AccessibilityPrefsCopyWithImpl<$Res, $Val extends AccessibilityPrefs>
    implements $AccessibilityPrefsCopyWith<$Res> {
  _$AccessibilityPrefsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccessibilityPrefs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceId = null,
    Object? comboJson = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      comboJson: null == comboJson
          ? _value.comboJson
          : comboJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccessibilityPrefsImplCopyWith<$Res>
    implements $AccessibilityPrefsCopyWith<$Res> {
  factory _$$AccessibilityPrefsImplCopyWith(_$AccessibilityPrefsImpl value,
          $Res Function(_$AccessibilityPrefsImpl) then) =
      __$$AccessibilityPrefsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String deviceId,
      Map<String, dynamic> comboJson,
      DateTime createdAt});
}

/// @nodoc
class __$$AccessibilityPrefsImplCopyWithImpl<$Res>
    extends _$AccessibilityPrefsCopyWithImpl<$Res, _$AccessibilityPrefsImpl>
    implements _$$AccessibilityPrefsImplCopyWith<$Res> {
  __$$AccessibilityPrefsImplCopyWithImpl(_$AccessibilityPrefsImpl _value,
      $Res Function(_$AccessibilityPrefsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccessibilityPrefs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceId = null,
    Object? comboJson = null,
    Object? createdAt = null,
  }) {
    return _then(_$AccessibilityPrefsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      comboJson: null == comboJson
          ? _value._comboJson
          : comboJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccessibilityPrefsImpl implements _AccessibilityPrefs {
  const _$AccessibilityPrefsImpl(
      {required this.id,
      required this.deviceId,
      required final Map<String, dynamic> comboJson,
      required this.createdAt})
      : _comboJson = comboJson;

  factory _$AccessibilityPrefsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccessibilityPrefsImplFromJson(json);

  @override
  final String id;
  @override
  final String deviceId;
  final Map<String, dynamic> _comboJson;
  @override
  Map<String, dynamic> get comboJson {
    if (_comboJson is EqualUnmodifiableMapView) return _comboJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_comboJson);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'AccessibilityPrefs(id: $id, deviceId: $deviceId, comboJson: $comboJson, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccessibilityPrefsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            const DeepCollectionEquality()
                .equals(other._comboJson, _comboJson) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, deviceId,
      const DeepCollectionEquality().hash(_comboJson), createdAt);

  /// Create a copy of AccessibilityPrefs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccessibilityPrefsImplCopyWith<_$AccessibilityPrefsImpl> get copyWith =>
      __$$AccessibilityPrefsImplCopyWithImpl<_$AccessibilityPrefsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccessibilityPrefsImplToJson(
      this,
    );
  }
}

abstract class _AccessibilityPrefs implements AccessibilityPrefs {
  const factory _AccessibilityPrefs(
      {required final String id,
      required final String deviceId,
      required final Map<String, dynamic> comboJson,
      required final DateTime createdAt}) = _$AccessibilityPrefsImpl;

  factory _AccessibilityPrefs.fromJson(Map<String, dynamic> json) =
      _$AccessibilityPrefsImpl.fromJson;

  @override
  String get id;
  @override
  String get deviceId;
  @override
  Map<String, dynamic> get comboJson;
  @override
  DateTime get createdAt;

  /// Create a copy of AccessibilityPrefs
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccessibilityPrefsImplCopyWith<_$AccessibilityPrefsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AISettings _$AISettingsFromJson(Map<String, dynamic> json) {
  return _AISettings.fromJson(json);
}

/// @nodoc
mixin _$AISettings {
  String get id => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  bool get masterOn => throw _privateConstructorUsedError;
  bool get presetsSmart => throw _privateConstructorUsedError;
  bool get payRecoLast5 => throw _privateConstructorUsedError;
  bool get a11yRememberLast5 => throw _privateConstructorUsedError;
  bool get layoutAdaptiveTts => throw _privateConstructorUsedError;
  bool get queueMode => throw _privateConstructorUsedError;
  bool get payPromotion => throw _privateConstructorUsedError;
  bool get maintenancePredictive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AISettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AISettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AISettingsCopyWith<AISettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AISettingsCopyWith<$Res> {
  factory $AISettingsCopyWith(
          AISettings value, $Res Function(AISettings) then) =
      _$AISettingsCopyWithImpl<$Res, AISettings>;
  @useResult
  $Res call(
      {String id,
      String companyId,
      String? deviceId,
      bool masterOn,
      bool presetsSmart,
      bool payRecoLast5,
      bool a11yRememberLast5,
      bool layoutAdaptiveTts,
      bool queueMode,
      bool payPromotion,
      bool maintenancePredictive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$AISettingsCopyWithImpl<$Res, $Val extends AISettings>
    implements $AISettingsCopyWith<$Res> {
  _$AISettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AISettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? deviceId = freezed,
    Object? masterOn = null,
    Object? presetsSmart = null,
    Object? payRecoLast5 = null,
    Object? a11yRememberLast5 = null,
    Object? layoutAdaptiveTts = null,
    Object? queueMode = null,
    Object? payPromotion = null,
    Object? maintenancePredictive = null,
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
      masterOn: null == masterOn
          ? _value.masterOn
          : masterOn // ignore: cast_nullable_to_non_nullable
              as bool,
      presetsSmart: null == presetsSmart
          ? _value.presetsSmart
          : presetsSmart // ignore: cast_nullable_to_non_nullable
              as bool,
      payRecoLast5: null == payRecoLast5
          ? _value.payRecoLast5
          : payRecoLast5 // ignore: cast_nullable_to_non_nullable
              as bool,
      a11yRememberLast5: null == a11yRememberLast5
          ? _value.a11yRememberLast5
          : a11yRememberLast5 // ignore: cast_nullable_to_non_nullable
              as bool,
      layoutAdaptiveTts: null == layoutAdaptiveTts
          ? _value.layoutAdaptiveTts
          : layoutAdaptiveTts // ignore: cast_nullable_to_non_nullable
              as bool,
      queueMode: null == queueMode
          ? _value.queueMode
          : queueMode // ignore: cast_nullable_to_non_nullable
              as bool,
      payPromotion: null == payPromotion
          ? _value.payPromotion
          : payPromotion // ignore: cast_nullable_to_non_nullable
              as bool,
      maintenancePredictive: null == maintenancePredictive
          ? _value.maintenancePredictive
          : maintenancePredictive // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$AISettingsImplCopyWith<$Res>
    implements $AISettingsCopyWith<$Res> {
  factory _$$AISettingsImplCopyWith(
          _$AISettingsImpl value, $Res Function(_$AISettingsImpl) then) =
      __$$AISettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String companyId,
      String? deviceId,
      bool masterOn,
      bool presetsSmart,
      bool payRecoLast5,
      bool a11yRememberLast5,
      bool layoutAdaptiveTts,
      bool queueMode,
      bool payPromotion,
      bool maintenancePredictive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$AISettingsImplCopyWithImpl<$Res>
    extends _$AISettingsCopyWithImpl<$Res, _$AISettingsImpl>
    implements _$$AISettingsImplCopyWith<$Res> {
  __$$AISettingsImplCopyWithImpl(
      _$AISettingsImpl _value, $Res Function(_$AISettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AISettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? deviceId = freezed,
    Object? masterOn = null,
    Object? presetsSmart = null,
    Object? payRecoLast5 = null,
    Object? a11yRememberLast5 = null,
    Object? layoutAdaptiveTts = null,
    Object? queueMode = null,
    Object? payPromotion = null,
    Object? maintenancePredictive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$AISettingsImpl(
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
      masterOn: null == masterOn
          ? _value.masterOn
          : masterOn // ignore: cast_nullable_to_non_nullable
              as bool,
      presetsSmart: null == presetsSmart
          ? _value.presetsSmart
          : presetsSmart // ignore: cast_nullable_to_non_nullable
              as bool,
      payRecoLast5: null == payRecoLast5
          ? _value.payRecoLast5
          : payRecoLast5 // ignore: cast_nullable_to_non_nullable
              as bool,
      a11yRememberLast5: null == a11yRememberLast5
          ? _value.a11yRememberLast5
          : a11yRememberLast5 // ignore: cast_nullable_to_non_nullable
              as bool,
      layoutAdaptiveTts: null == layoutAdaptiveTts
          ? _value.layoutAdaptiveTts
          : layoutAdaptiveTts // ignore: cast_nullable_to_non_nullable
              as bool,
      queueMode: null == queueMode
          ? _value.queueMode
          : queueMode // ignore: cast_nullable_to_non_nullable
              as bool,
      payPromotion: null == payPromotion
          ? _value.payPromotion
          : payPromotion // ignore: cast_nullable_to_non_nullable
              as bool,
      maintenancePredictive: null == maintenancePredictive
          ? _value.maintenancePredictive
          : maintenancePredictive // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$AISettingsImpl implements _AISettings {
  const _$AISettingsImpl(
      {required this.id,
      required this.companyId,
      this.deviceId,
      this.masterOn = true,
      this.presetsSmart = true,
      this.payRecoLast5 = true,
      this.a11yRememberLast5 = true,
      this.layoutAdaptiveTts = true,
      this.queueMode = true,
      this.payPromotion = true,
      this.maintenancePredictive = true,
      required this.createdAt,
      required this.updatedAt});

  factory _$AISettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AISettingsImplFromJson(json);

  @override
  final String id;
  @override
  final String companyId;
  @override
  final String? deviceId;
  @override
  @JsonKey()
  final bool masterOn;
  @override
  @JsonKey()
  final bool presetsSmart;
  @override
  @JsonKey()
  final bool payRecoLast5;
  @override
  @JsonKey()
  final bool a11yRememberLast5;
  @override
  @JsonKey()
  final bool layoutAdaptiveTts;
  @override
  @JsonKey()
  final bool queueMode;
  @override
  @JsonKey()
  final bool payPromotion;
  @override
  @JsonKey()
  final bool maintenancePredictive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AISettings(id: $id, companyId: $companyId, deviceId: $deviceId, masterOn: $masterOn, presetsSmart: $presetsSmart, payRecoLast5: $payRecoLast5, a11yRememberLast5: $a11yRememberLast5, layoutAdaptiveTts: $layoutAdaptiveTts, queueMode: $queueMode, payPromotion: $payPromotion, maintenancePredictive: $maintenancePredictive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AISettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.masterOn, masterOn) ||
                other.masterOn == masterOn) &&
            (identical(other.presetsSmart, presetsSmart) ||
                other.presetsSmart == presetsSmart) &&
            (identical(other.payRecoLast5, payRecoLast5) ||
                other.payRecoLast5 == payRecoLast5) &&
            (identical(other.a11yRememberLast5, a11yRememberLast5) ||
                other.a11yRememberLast5 == a11yRememberLast5) &&
            (identical(other.layoutAdaptiveTts, layoutAdaptiveTts) ||
                other.layoutAdaptiveTts == layoutAdaptiveTts) &&
            (identical(other.queueMode, queueMode) ||
                other.queueMode == queueMode) &&
            (identical(other.payPromotion, payPromotion) ||
                other.payPromotion == payPromotion) &&
            (identical(other.maintenancePredictive, maintenancePredictive) ||
                other.maintenancePredictive == maintenancePredictive) &&
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
      masterOn,
      presetsSmart,
      payRecoLast5,
      a11yRememberLast5,
      layoutAdaptiveTts,
      queueMode,
      payPromotion,
      maintenancePredictive,
      createdAt,
      updatedAt);

  /// Create a copy of AISettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AISettingsImplCopyWith<_$AISettingsImpl> get copyWith =>
      __$$AISettingsImplCopyWithImpl<_$AISettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AISettingsImplToJson(
      this,
    );
  }
}

abstract class _AISettings implements AISettings {
  const factory _AISettings(
      {required final String id,
      required final String companyId,
      final String? deviceId,
      final bool masterOn,
      final bool presetsSmart,
      final bool payRecoLast5,
      final bool a11yRememberLast5,
      final bool layoutAdaptiveTts,
      final bool queueMode,
      final bool payPromotion,
      final bool maintenancePredictive,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$AISettingsImpl;

  factory _AISettings.fromJson(Map<String, dynamic> json) =
      _$AISettingsImpl.fromJson;

  @override
  String get id;
  @override
  String get companyId;
  @override
  String? get deviceId;
  @override
  bool get masterOn;
  @override
  bool get presetsSmart;
  @override
  bool get payRecoLast5;
  @override
  bool get a11yRememberLast5;
  @override
  bool get layoutAdaptiveTts;
  @override
  bool get queueMode;
  @override
  bool get payPromotion;
  @override
  bool get maintenancePredictive;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of AISettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AISettingsImplCopyWith<_$AISettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TTSConfig _$TTSConfigFromJson(Map<String, dynamic> json) {
  return _TTSConfig.fromJson(json);
}

/// @nodoc
mixin _$TTSConfig {
  bool get enabled => throw _privateConstructorUsedError;
  double get speed => throw _privateConstructorUsedError;
  double get pitch => throw _privateConstructorUsedError;
  double get volume => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get voiceGender => throw _privateConstructorUsedError;

  /// Serializes this TTSConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TTSConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TTSConfigCopyWith<TTSConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TTSConfigCopyWith<$Res> {
  factory $TTSConfigCopyWith(TTSConfig value, $Res Function(TTSConfig) then) =
      _$TTSConfigCopyWithImpl<$Res, TTSConfig>;
  @useResult
  $Res call(
      {bool enabled,
      double speed,
      double pitch,
      double volume,
      String language,
      String voiceGender});
}

/// @nodoc
class _$TTSConfigCopyWithImpl<$Res, $Val extends TTSConfig>
    implements $TTSConfigCopyWith<$Res> {
  _$TTSConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TTSConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? speed = null,
    Object? pitch = null,
    Object? volume = null,
    Object? language = null,
    Object? voiceGender = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      pitch: null == pitch
          ? _value.pitch
          : pitch // ignore: cast_nullable_to_non_nullable
              as double,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      voiceGender: null == voiceGender
          ? _value.voiceGender
          : voiceGender // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TTSConfigImplCopyWith<$Res>
    implements $TTSConfigCopyWith<$Res> {
  factory _$$TTSConfigImplCopyWith(
          _$TTSConfigImpl value, $Res Function(_$TTSConfigImpl) then) =
      __$$TTSConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      double speed,
      double pitch,
      double volume,
      String language,
      String voiceGender});
}

/// @nodoc
class __$$TTSConfigImplCopyWithImpl<$Res>
    extends _$TTSConfigCopyWithImpl<$Res, _$TTSConfigImpl>
    implements _$$TTSConfigImplCopyWith<$Res> {
  __$$TTSConfigImplCopyWithImpl(
      _$TTSConfigImpl _value, $Res Function(_$TTSConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of TTSConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? speed = null,
    Object? pitch = null,
    Object? volume = null,
    Object? language = null,
    Object? voiceGender = null,
  }) {
    return _then(_$TTSConfigImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      pitch: null == pitch
          ? _value.pitch
          : pitch // ignore: cast_nullable_to_non_nullable
              as double,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      voiceGender: null == voiceGender
          ? _value.voiceGender
          : voiceGender // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TTSConfigImpl implements _TTSConfig {
  const _$TTSConfigImpl(
      {this.enabled = true,
      this.speed = 0.8,
      this.pitch = 1.0,
      this.volume = 0.9,
      this.language = 'es-ES',
      this.voiceGender = 'female'});

  factory _$TTSConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$TTSConfigImplFromJson(json);

  @override
  @JsonKey()
  final bool enabled;
  @override
  @JsonKey()
  final double speed;
  @override
  @JsonKey()
  final double pitch;
  @override
  @JsonKey()
  final double volume;
  @override
  @JsonKey()
  final String language;
  @override
  @JsonKey()
  final String voiceGender;

  @override
  String toString() {
    return 'TTSConfig(enabled: $enabled, speed: $speed, pitch: $pitch, volume: $volume, language: $language, voiceGender: $voiceGender)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TTSConfigImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.pitch, pitch) || other.pitch == pitch) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.voiceGender, voiceGender) ||
                other.voiceGender == voiceGender));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, enabled, speed, pitch, volume, language, voiceGender);

  /// Create a copy of TTSConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TTSConfigImplCopyWith<_$TTSConfigImpl> get copyWith =>
      __$$TTSConfigImplCopyWithImpl<_$TTSConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TTSConfigImplToJson(
      this,
    );
  }
}

abstract class _TTSConfig implements TTSConfig {
  const factory _TTSConfig(
      {final bool enabled,
      final double speed,
      final double pitch,
      final double volume,
      final String language,
      final String voiceGender}) = _$TTSConfigImpl;

  factory _TTSConfig.fromJson(Map<String, dynamic> json) =
      _$TTSConfigImpl.fromJson;

  @override
  bool get enabled;
  @override
  double get speed;
  @override
  double get pitch;
  @override
  double get volume;
  @override
  String get language;
  @override
  String get voiceGender;

  /// Create a copy of TTSConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TTSConfigImplCopyWith<_$TTSConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
