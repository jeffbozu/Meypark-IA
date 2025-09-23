import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme.freezed.dart';
part 'theme.g.dart';

@freezed
class AppTheme with _$AppTheme {
  const factory AppTheme({
    required String id,
    required String companyId,
    required String scope, // 'initial_screen' or 'default_ui'
    required Map<String, dynamic> colorsJson,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppTheme;

  factory AppTheme.fromJson(Map<String, dynamic> json) =>
      _$AppThemeFromJson(json);
}

@freezed
class UIOverrides with _$UIOverrides {
  const factory UIOverrides({
    required String id,
    required String companyId,
    String? deviceId,
    required String scope,
    required Map<String, dynamic> visibilityJson,
    required Map<String, dynamic> textOverridesJson,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UIOverrides;

  factory UIOverrides.fromJson(Map<String, dynamic> json) =>
      _$UIOverridesFromJson(json);
}

@freezed
class DeviceConfig with _$DeviceConfig {
  const factory DeviceConfig({
    required String id,
    required String companyId,
    required String alias,
    required String serial,
    required String timezone,
    required String appVersion,
    required DateTime lastSeen,
    required Map<String, dynamic> flagsJson,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DeviceConfig;

  factory DeviceConfig.fromJson(Map<String, dynamic> json) =>
      _$DeviceConfigFromJson(json);
}
