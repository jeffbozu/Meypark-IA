import 'package:freezed_annotation/freezed_annotation.dart';

part 'accessibility.freezed.dart';
part 'accessibility.g.dart';

@freezed
class AccessibilityPrefs with _$AccessibilityPrefs {
  const factory AccessibilityPrefs({
    required String id,
    required String deviceId,
    required Map<String, dynamic> comboJson,
    required DateTime createdAt,
  }) = _AccessibilityPrefs;

  factory AccessibilityPrefs.fromJson(Map<String, dynamic> json) =>
      _$AccessibilityPrefsFromJson(json);
}

@freezed
class AISettings with _$AISettings {
  const factory AISettings({
    required String id,
    required String companyId,
    String? deviceId,
    @Default(true) bool masterOn,
    @Default(true) bool presetsSmart,
    @Default(true) bool payRecoLast5,
    @Default(true) bool a11yRememberLast5,
    @Default(true) bool layoutAdaptiveTts,
    @Default(true) bool queueMode,
    @Default(true) bool payPromotion,
    @Default(true) bool maintenancePredictive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AISettings;

  factory AISettings.fromJson(Map<String, dynamic> json) =>
      _$AISettingsFromJson(json);
}

@freezed
class TTSConfig with _$TTSConfig {
  const factory TTSConfig({
    @Default(true) bool enabled,
    @Default(0.8) double speed,
    @Default(1.0) double pitch,
    @Default(0.9) double volume,
    @Default('es-ES') String language,
    @Default('female') String voiceGender,
  }) = _TTSConfig;

  factory TTSConfig.fromJson(Map<String, dynamic> json) =>
      _$TTSConfigFromJson(json);
}
