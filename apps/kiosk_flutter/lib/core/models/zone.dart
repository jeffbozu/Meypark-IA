import 'package:freezed_annotation/freezed_annotation.dart';

part 'zone.freezed.dart';
part 'zone.g.dart';

@freezed
class Zone with _$Zone {
  const factory Zone({
    required String id,
    required String companyId,
    required String code,
    required String name,
    required String color,
    required Map<String, dynamic> scheduleJson,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isExternal,
    Map<String, dynamic>? discounts,
    double? residentDiscount,
  }) = _Zone;

  factory Zone.fromJson(Map<String, dynamic> json) => _$ZoneFromJson(json);
}

@freezed
class Tariff with _$Tariff {
  const factory Tariff({
    required String id,
    required String zoneId,
    required int pricePerMinCents,
    required int minMinutes,
    required int maxMinutes,
    @Default(5) int stepMinutes,
    required List<int> presets,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Tariff;

  factory Tariff.fromJson(Map<String, dynamic> json) => _$TariffFromJson(json);
}
