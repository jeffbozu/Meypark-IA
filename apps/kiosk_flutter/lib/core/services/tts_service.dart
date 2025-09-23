import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TTSService {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;
  static bool _isEnabled = true;
  static double _rate = 0.5;
  static double _pitch = 1.0;
  static double _volume = 0.8;
  static String _language = 'es-ES';

  static Future<void> initialize() async {
    if (_isInitialized) return;

    await _flutterTts.setLanguage(_language);
    await _flutterTts.setSpeechRate(_rate);
    await _flutterTts.setVolume(_volume);
    await _flutterTts.setPitch(_pitch);

    // Configurar callbacks
    _flutterTts.setStartHandler(() {
      print('TTS Started');
    });

    _flutterTts.setCompletionHandler(() {
      print('TTS Completed');
    });

    _flutterTts.setErrorHandler((msg) {
      print('TTS Error: $msg');
    });

    _isInitialized = true;
  }

  static Future<void> speak(String text) async {
    if (!_isEnabled || !_isInitialized) return;

    try {
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking: $e');
    }
  }

  static Future<void> stop() async {
    await _flutterTts.stop();
  }

  static Future<void> pause() async {
    await _flutterTts.pause();
  }

  static Future<void> setRate(double rate) async {
    _rate = rate;
    await _flutterTts.setSpeechRate(rate);
  }

  static Future<void> setPitch(double pitch) async {
    _pitch = pitch;
    await _flutterTts.setPitch(pitch);
  }

  static Future<void> setVolume(double volume) async {
    _volume = volume;
    await _flutterTts.setVolume(volume);
  }

  static Future<void> setLanguage(String language) async {
    _language = language;
    await _flutterTts.setLanguage(language);
  }

  static Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
  }

  static bool get isEnabled => _isEnabled;
  static double get rate => _rate;
  static double get pitch => _pitch;
  static double get volume => _volume;
  static String get language => _language;
}

// Provider para TTS
final ttsServiceProvider = Provider<TTSService>((ref) => TTSService());

// Provider para configuración de TTS
final ttsConfigProvider =
    StateNotifierProvider<TTSConfigNotifier, TTSConfig>((ref) {
  return TTSConfigNotifier();
});

class TTSConfig {
  final bool enabled;
  final double rate;
  final double pitch;
  final double volume;
  final String language;

  TTSConfig({
    required this.enabled,
    required this.rate,
    required this.pitch,
    required this.volume,
    required this.language,
  });

  TTSConfig copyWith({
    bool? enabled,
    double? rate,
    double? pitch,
    double? volume,
    String? language,
  }) {
    return TTSConfig(
      enabled: enabled ?? this.enabled,
      rate: rate ?? this.rate,
      pitch: pitch ?? this.pitch,
      volume: volume ?? this.volume,
      language: language ?? this.language,
    );
  }
}

class TTSConfigNotifier extends StateNotifier<TTSConfig> {
  TTSConfigNotifier()
      : super(TTSConfig(
          enabled: true,
          rate: 0.5,
          pitch: 1.0,
          volume: 0.8,
          language: 'es-ES',
        ));

  void updateConfig(TTSConfig config) {
    state = config;
    TTSService.setEnabled(config.enabled);
    TTSService.setRate(config.rate);
    TTSService.setPitch(config.pitch);
    TTSService.setVolume(config.volume);
    TTSService.setLanguage(config.language);
  }

  void setEnabled(bool enabled) {
    state = state.copyWith(enabled: enabled);
    TTSService.setEnabled(enabled);
  }

  void setRate(double rate) {
    state = state.copyWith(rate: rate);
    TTSService.setRate(rate);
  }

  void setPitch(double pitch) {
    state = state.copyWith(pitch: pitch);
    TTSService.setPitch(pitch);
  }

  void setVolume(double volume) {
    state = state.copyWith(volume: volume);
    TTSService.setVolume(volume);
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
    TTSService.setLanguage(language);
  }
}
