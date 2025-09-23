// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accessibility.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccessibilityPrefsImpl _$$AccessibilityPrefsImplFromJson(
        Map<String, dynamic> json) =>
    _$AccessibilityPrefsImpl(
      id: json['id'] as String,
      deviceId: json['deviceId'] as String,
      comboJson: json['comboJson'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AccessibilityPrefsImplToJson(
        _$AccessibilityPrefsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceId': instance.deviceId,
      'comboJson': instance.comboJson,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$AISettingsImpl _$$AISettingsImplFromJson(Map<String, dynamic> json) =>
    _$AISettingsImpl(
      id: json['id'] as String,
      companyId: json['companyId'] as String,
      deviceId: json['deviceId'] as String?,
      masterOn: json['masterOn'] as bool? ?? true,
      presetsSmart: json['presetsSmart'] as bool? ?? true,
      payRecoLast5: json['payRecoLast5'] as bool? ?? true,
      a11yRememberLast5: json['a11yRememberLast5'] as bool? ?? true,
      layoutAdaptiveTts: json['layoutAdaptiveTts'] as bool? ?? true,
      queueMode: json['queueMode'] as bool? ?? true,
      payPromotion: json['payPromotion'] as bool? ?? true,
      maintenancePredictive: json['maintenancePredictive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AISettingsImplToJson(_$AISettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyId': instance.companyId,
      'deviceId': instance.deviceId,
      'masterOn': instance.masterOn,
      'presetsSmart': instance.presetsSmart,
      'payRecoLast5': instance.payRecoLast5,
      'a11yRememberLast5': instance.a11yRememberLast5,
      'layoutAdaptiveTts': instance.layoutAdaptiveTts,
      'queueMode': instance.queueMode,
      'payPromotion': instance.payPromotion,
      'maintenancePredictive': instance.maintenancePredictive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$TTSConfigImpl _$$TTSConfigImplFromJson(Map<String, dynamic> json) =>
    _$TTSConfigImpl(
      enabled: json['enabled'] as bool? ?? true,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.8,
      pitch: (json['pitch'] as num?)?.toDouble() ?? 1.0,
      volume: (json['volume'] as num?)?.toDouble() ?? 0.9,
      language: json['language'] as String? ?? 'es-ES',
      voiceGender: json['voiceGender'] as String? ?? 'female',
    );

Map<String, dynamic> _$$TTSConfigImplToJson(_$TTSConfigImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'speed': instance.speed,
      'pitch': instance.pitch,
      'volume': instance.volume,
      'language': instance.language,
      'voiceGender': instance.voiceGender,
    };
