import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowService {
  static WindowService? _instance;
  WindowService._internal();
  factory WindowService() => _instance ??= WindowService._internal();

  static Future<void> initialize() async {
    await windowManager.ensureInitialized();

    // Configuración de ventana para kiosko
    const windowOptions = WindowOptions(
      size: Size(1280, 800), // Tamaño para pantalla 10" en landscape
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal, // Permitir controles de ventana
      windowButtonVisibility: true, // Mostrar botones de cerrar, minimizar
      title: 'MEYPARK - Kiosko de Estacionamiento',
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setResizable(true); // Permitir redimensionar
      await windowManager.setMinimizable(true);
      await windowManager.setClosable(true);
    });
  }

  static Future<void> setKioskMode(bool enabled) async {
    if (enabled) {
      await windowManager.setFullScreen(true);
      await windowManager.setAlwaysOnTop(true);
      await windowManager.setSkipTaskbar(true);
      await windowManager.setResizable(false);
    } else {
      await windowManager.setFullScreen(false);
      await windowManager.setAlwaysOnTop(false);
      await windowManager.setSkipTaskbar(false);
      await windowManager.setResizable(true);
    }
  }

  static Future<void> setWindowSize(Size size) async {
    await windowManager.setSize(size);
    await windowManager.center();
  }

  static Future<void> minimizeWindow() async {
    await windowManager.minimize();
  }

  static Future<void> maximizeWindow() async {
    await windowManager.maximize();
  }

  static Future<void> restoreWindow() async {
    await windowManager.restore();
  }

  static Future<void> closeWindow() async {
    await windowManager.close();
  }

  static Future<bool> isMaximized() async {
    return await windowManager.isMaximized();
  }

  static Future<bool> isMinimized() async {
    return await windowManager.isMinimized();
  }

  static Future<Size> getWindowSize() async {
    return await windowManager.getSize();
  }

  static Future<Offset> getWindowPosition() async {
    return await windowManager.getPosition();
  }
}
