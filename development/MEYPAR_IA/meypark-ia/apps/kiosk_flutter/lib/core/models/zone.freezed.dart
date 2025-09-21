// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zone.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Zone _$ZoneFromJson(Map<String, dynamic> json) {
  return _Zone.fromJson(json);
}

/// @nodoc
mixin _$Zone {
  String get id => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  Map<String, dynamic> get scheduleJson => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isExternal => throw _privateConstructorUsedError;
  Map<String, dynamic>? get discounts => throw _privateConstructorUsedError;
  double? get residentDiscount => throw _privateConstructorUsedError;

  /// Serializes this Zone to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Zone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ZoneCopyWith<Zone> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ZoneCopyWith<$Res> {
  factory $ZoneCopyWith(Zone value, $Res Function(Zone) then) =
      _$ZoneCopyWithImpl<$Res, Zone>;
  @useResult
  $Res call(
      {String id,
      String companyId,
      String code,
      String name,
      String color,
      Map<String, dynamic> scheduleJson,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt,
      bool isExternal,
      Map<String, dynamic>? discounts,
      double? residentDiscount});
}

/// @nodoc
class _$ZoneCopyWithImpl<$Res, $Val extends Zone>
    implements $ZoneCopyWith<$Res> {
  _$ZoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Zone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? code = null,
    Object? name = null,
    Object? color = null,
    Object? scheduleJson = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isExternal = null,
    Object? discounts = freezed,
    Object? residentDiscount = freezed,
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
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      scheduleJson: null == scheduleJson
          ? _value.scheduleJson
          : scheduleJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isExternal: null == isExternal
          ? _value.isExternal
          : isExternal // ignore: cast_nullable_to_non_nullable
              as bool,
      discounts: freezed == discounts
          ? _value.discounts
          : discounts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      residentDiscount: freezed == residentDiscount
          ? _value.residentDiscount
          : residentDiscount // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ZoneImplCopyWith<$Res> implements $ZoneCopyWith<$Res> {
  factory _$$ZoneImplCopyWith(
          _$ZoneImpl value, $Res Function(_$ZoneImpl) then) =
      __$$ZoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String companyId,
      String code,
      String name,
      String color,
      Map<String, dynamic> scheduleJson,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt,
      bool isExternal,
      Map<String, dynamic>? discounts,
      double? residentDiscount});
}

/// @nodoc
class __$$ZoneImplCopyWithImpl<$Res>
    extends _$ZoneCopyWithImpl<$Res, _$ZoneImpl>
    implements _$$ZoneImplCopyWith<$Res> {
  __$$ZoneImplCopyWithImpl(_$ZoneImpl _value, $Res Function(_$ZoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of Zone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? code = null,
    Object? name = null,
    Object? color = null,
    Object? scheduleJson = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isExternal = null,
    Object? discounts = freezed,
    Object? residentDiscount = freezed,
  }) {
    return _then(_$ZoneImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      scheduleJson: null == scheduleJson
          ? _value._scheduleJson
          : scheduleJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isExternal: null == isExternal
          ? _value.isExternal
          : isExternal // ignore: cast_nullable_to_non_nullable
              as bool,
      discounts: freezed == discounts
          ? _value._discounts
          : discounts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      residentDiscount: freezed == residentDiscount
          ? _value.residentDiscount
          : residentDiscount // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ZoneImpl implements _Zone {
  const _$ZoneImpl(
      {required this.id,
      required this.companyId,
      required this.code,
      required this.name,
      required this.color,
      required final Map<String, dynamic> scheduleJson,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt,
      this.isExternal = false,
      final Map<String, dynamic>? discounts,
      this.residentDiscount})
      : _scheduleJson = scheduleJson,
        _discounts = discounts;

  factory _$ZoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$ZoneImplFromJson(json);

  @override
  final String id;
  @override
  final String companyId;
  @override
  final String code;
  @override
  final String name;
  @override
  final String color;
  final Map<String, dynamic> _scheduleJson;
  @override
  Map<String, dynamic> get scheduleJson {
    if (_scheduleJson is EqualUnmodifiableMapView) return _scheduleJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_scheduleJson);
  }

  @override
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final bool isExternal;
  final Map<String, dynamic>? _discounts;
  @override
  Map<String, dynamic>? get discounts {
    final value = _discounts;
    if (value == null) return null;
    if (_discounts is EqualUnmodifiableMapView) return _discounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final double? residentDiscount;

  @override
  String toString() {
    return 'Zone(id: $id, companyId: $companyId, code: $code, name: $name, color: $color, scheduleJson: $scheduleJson, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, isExternal: $isExternal, discounts: $discounts, residentDiscount: $residentDiscount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ZoneImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality()
                .equals(other._scheduleJson, _scheduleJson) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isExternal, isExternal) ||
                other.isExternal == isExternal) &&
            const DeepCollectionEquality()
                .equals(other._discounts, _discounts) &&
            (identical(other.residentDiscount, residentDiscount) ||
                other.residentDiscount == residentDiscount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      companyId,
      code,
      name,
      color,
      const DeepCollectionEquality().hash(_scheduleJson),
      isActive,
      createdAt,
      updatedAt,
      isExternal,
      const DeepCollectionEquality().hash(_discounts),
      residentDiscount);

  /// Create a copy of Zone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ZoneImplCopyWith<_$ZoneImpl> get copyWith =>
      __$$ZoneImplCopyWithImpl<_$ZoneImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ZoneImplToJson(
      this,
    );
  }
}

abstract class _Zone implements Zone {
  const factory _Zone(
      {required final String id,
      required final String companyId,
      required final String code,
      required final String name,
      required final String color,
      required final Map<String, dynamic> scheduleJson,
      required final bool isActive,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final bool isExternal,
      final Map<String, dynamic>? discounts,
      final double? residentDiscount}) = _$ZoneImpl;

  factory _Zone.fromJson(Map<String, dynamic> json) = _$ZoneImpl.fromJson;

  @override
  String get id;
  @override
  String get companyId;
  @override
  String get code;
  @override
  String get name;
  @override
  String get color;
  @override
  Map<String, dynamic> get scheduleJson;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isExternal;
  @override
  Map<String, dynamic>? get discounts;
  @override
  double? get residentDiscount;

  /// Create a copy of Zone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ZoneImplCopyWith<_$ZoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Tariff _$TariffFromJson(Map<String, dynamic> json) {
  return _Tariff.fromJson(json);
}

/// @nodoc
mixin _$Tariff {
  String get id => throw _privateConstructorUsedError;
  String get zoneId => throw _privateConstructorUsedError;
  int get pricePerMinCents => throw _privateConstructorUsedError;
  int get minMinutes => throw _privateConstructorUsedError;
  int get maxMinutes => throw _privateConstructorUsedError;
  int get stepMinutes => throw _privateConstructorUsedError;
  List<int> get presets => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Tariff to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tariff
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TariffCopyWith<Tariff> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TariffCopyWith<$Res> {
  factory $TariffCopyWith(Tariff value, $Res Function(Tariff) then) =
      _$TariffCopyWithImpl<$Res, Tariff>;
  @useResult
  $Res call(
      {String id,
      String zoneId,
      int pricePerMinCents,
      int minMinutes,
      int maxMinutes,
      int stepMinutes,
      List<int> presets,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$TariffCopyWithImpl<$Res, $Val extends Tariff>
    implements $TariffCopyWith<$Res> {
  _$TariffCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tariff
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? zoneId = null,
    Object? pricePerMinCents = null,
    Object? minMinutes = null,
    Object? maxMinutes = null,
    Object? stepMinutes = null,
    Object? presets = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      zoneId: null == zoneId
          ? _value.zoneId
          : zoneId // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerMinCents: null == pricePerMinCents
          ? _value.pricePerMinCents
          : pricePerMinCents // ignore: cast_nullable_to_non_nullable
              as int,
      minMinutes: null == minMinutes
          ? _value.minMinutes
          : minMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      maxMinutes: null == maxMinutes
          ? _value.maxMinutes
          : maxMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      stepMinutes: null == stepMinutes
          ? _value.stepMinutes
          : stepMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      presets: null == presets
          ? _value.presets
          : presets // ignore: cast_nullable_to_non_nullable
              as List<int>,
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
abstract class _$$TariffImplCopyWith<$Res> implements $TariffCopyWith<$Res> {
  factory _$$TariffImplCopyWith(
          _$TariffImpl value, $Res Function(_$TariffImpl) then) =
      __$$TariffImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String zoneId,
      int pricePerMinCents,
      int minMinutes,
      int maxMinutes,
      int stepMinutes,
      List<int> presets,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$TariffImplCopyWithImpl<$Res>
    extends _$TariffCopyWithImpl<$Res, _$TariffImpl>
    implements _$$TariffImplCopyWith<$Res> {
  __$$TariffImplCopyWithImpl(
      _$TariffImpl _value, $Res Function(_$TariffImpl) _then)
      : super(_value, _then);

  /// Create a copy of Tariff
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? zoneId = null,
    Object? pricePerMinCents = null,
    Object? minMinutes = null,
    Object? maxMinutes = null,
    Object? stepMinutes = null,
    Object? presets = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$TariffImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      zoneId: null == zoneId
          ? _value.zoneId
          : zoneId // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerMinCents: null == pricePerMinCents
          ? _value.pricePerMinCents
          : pricePerMinCents // ignore: cast_nullable_to_non_nullable
              as int,
      minMinutes: null == minMinutes
          ? _value.minMinutes
          : minMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      maxMinutes: null == maxMinutes
          ? _value.maxMinutes
          : maxMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      stepMinutes: null == stepMinutes
          ? _value.stepMinutes
          : stepMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      presets: null == presets
          ? _value._presets
          : presets // ignore: cast_nullable_to_non_nullable
              as List<int>,
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
class _$TariffImpl implements _Tariff {
  const _$TariffImpl(
      {required this.id,
      required this.zoneId,
      required this.pricePerMinCents,
      required this.minMinutes,
      required this.maxMinutes,
      this.stepMinutes = 5,
      required final List<int> presets,
      required this.createdAt,
      required this.updatedAt})
      : _presets = presets;

  factory _$TariffImpl.fromJson(Map<String, dynamic> json) =>
      _$$TariffImplFromJson(json);

  @override
  final String id;
  @override
  final String zoneId;
  @override
  final int pricePerMinCents;
  @override
  final int minMinutes;
  @override
  final int maxMinutes;
  @override
  @JsonKey()
  final int stepMinutes;
  final List<int> _presets;
  @override
  List<int> get presets {
    if (_presets is EqualUnmodifiableListView) return _presets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_presets);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Tariff(id: $id, zoneId: $zoneId, pricePerMinCents: $pricePerMinCents, minMinutes: $minMinutes, maxMinutes: $maxMinutes, stepMinutes: $stepMinutes, presets: $presets, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TariffImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.zoneId, zoneId) || other.zoneId == zoneId) &&
            (identical(other.pricePerMinCents, pricePerMinCents) ||
                other.pricePerMinCents == pricePerMinCents) &&
            (identical(other.minMinutes, minMinutes) ||
                other.minMinutes == minMinutes) &&
            (identical(other.maxMinutes, maxMinutes) ||
                other.maxMinutes == maxMinutes) &&
            (identical(other.stepMinutes, stepMinutes) ||
                other.stepMinutes == stepMinutes) &&
            const DeepCollectionEquality().equals(other._presets, _presets) &&
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
      zoneId,
      pricePerMinCents,
      minMinutes,
      maxMinutes,
      stepMinutes,
      const DeepCollectionEquality().hash(_presets),
      createdAt,
      updatedAt);

  /// Create a copy of Tariff
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TariffImplCopyWith<_$TariffImpl> get copyWith =>
      __$$TariffImplCopyWithImpl<_$TariffImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TariffImplToJson(
      this,
    );
  }
}

abstract class _Tariff implements Tariff {
  const factory _Tariff(
      {required final String id,
      required final String zoneId,
      required final int pricePerMinCents,
      required final int minMinutes,
      required final int maxMinutes,
      final int stepMinutes,
      required final List<int> presets,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$TariffImpl;

  factory _Tariff.fromJson(Map<String, dynamic> json) = _$TariffImpl.fromJson;

  @override
  String get id;
  @override
  String get zoneId;
  @override
  int get pricePerMinCents;
  @override
  int get minMinutes;
  @override
  int get maxMinutes;
  @override
  int get stepMinutes;
  @override
  List<int> get presets;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Tariff
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TariffImplCopyWith<_$TariffImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
