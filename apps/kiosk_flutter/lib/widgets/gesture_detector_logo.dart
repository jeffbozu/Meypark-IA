import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'password_dialog.dart';

class GestureDetectorLogo extends StatefulWidget {
  final Widget child;
  final String logoText;

  const GestureDetectorLogo({
    super.key,
    required this.child,
    this.logoText = 'MEYPARK IA',
  });

  @override
  State<GestureDetectorLogo> createState() => _GestureDetectorLogoState();
}

class _GestureDetectorLogoState extends State<GestureDetectorLogo> {
  int _tapCount = 0;
  DateTime? _lastTapTime;
  bool _isLongPressing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onLongPressStart: (_) => _handleLongPressStart(),
      onLongPressEnd: (_) => _handleLongPressEnd(),
      child: widget.child,
    );
  }

  void _handleTap() {
    final now = DateTime.now();

    // Resetear contador si han pasado más de 2 segundos desde el último tap
    if (_lastTapTime != null && now.difference(_lastTapTime!).inSeconds > 2) {
      _tapCount = 0;
    }

    _tapCount++;
    _lastTapTime = now;

    // Si son 3 toques seguidos, mostrar diálogo de login
    if (_tapCount >= 3) {
      _tapCount = 0;
      _showPasswordDialog('login');
    }
  }

  void _handleLongPressStart() {
    _isLongPressing = true;

    // Mostrar indicador visual después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (_isLongPressing && mounted) {
        _showPasswordDialog('tech_mode');
      }
    });
  }

  void _handleLongPressEnd() {
    _isLongPressing = false;
  }

  void _showPasswordDialog(String mode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PasswordDialog(
        mode: mode,
        onSuccess: () => _navigateToMode(mode),
      ),
    );
  }

  void _navigateToMode(String mode) {
    switch (mode) {
      case 'login':
        context.go('/login');
        break;
      case 'tech_mode':
        context.go('/tech-mode');
        break;
    }
  }
}
