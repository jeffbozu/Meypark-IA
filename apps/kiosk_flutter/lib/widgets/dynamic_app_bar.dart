import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../core/providers/supabase_providers.dart';

class DynamicAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const DynamicAppBar({super.key});

  @override
  ConsumerState<DynamicAppBar> createState() => _DynamicAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _DynamicAppBarState extends ConsumerState<DynamicAppBar> {
  Timer? _timer;
  DateTime _currentTime = DateTime.now();
  int _tapCount = 0;
  Timer? _tapTimer;
  DateTime? _longPressStart;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tapTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Obtener hora de Madrid, España
          _currentTime = DateTime.now().toUtc().add(const Duration(hours: 1));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final uiConfig = ref.watch(uiConfigProvider);

    return uiConfig.when(
      loading: () => _buildSimpleAppBar(context),
      error: (error, stack) => _buildSimpleAppBar(context),
      data: (config) => _buildSimpleAppBar(context),
    );
  }

  AppBar _buildDefaultAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.local_parking,
              color: Color(0xFFE62144),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Nombre de la empresa
          const Text(
            'MEYPARK IA',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),

      // Hora y fecha en la esquina derecha
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('HH:mm').format(_currentTime),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              DateFormat('dd/MM/yyyy').format(_currentTime),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
      ],

      // Configuración del AppBar
      backgroundColor: const Color(0xFFE62144),
      elevation: 4,
      centerTitle: false,

      // Botón de acceso técico (5 toques) y login (mantener 3 segundos)
      leading: GestureDetector(
        onTap: _handleTap,
        onLongPressStart: _handleLongPressStart,
        onLongPressEnd: _handleLongPressEnd,
        child: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleTap() {
    _tapCount++;

    if (_tapTimer != null) {
      _tapTimer!.cancel();
    }

    _tapTimer = Timer(const Duration(milliseconds: 800), () {
      if (_tapCount >= 5) {
        // 5 toques detectado - acceso técnico
        _showTechnicalLogin();
      }
      _tapCount = 0;
    });
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    _longPressStart = DateTime.now();
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    if (_longPressStart != null) {
      final duration = DateTime.now().difference(_longPressStart!);
      if (duration.inSeconds >= 3) {
        // Mantener 3 segundos - login normal
        _showNormalLogin();
      }
    }
    _longPressStart = null;
  }

  void _showTechnicalLogin() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🔧 Acceso Técnico'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Introduce la contraseña técnica:'),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Contraseña técnica',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (password) {
                if (password == 'tech123') {
                  Navigator.of(context).pop();
                  context.goNamed('hidden-login');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contraseña incorrecta')),
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showNormalLogin() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🔑 Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Introduce tus credenciales:'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (password) {
                if (password == 'admin123') {
                  Navigator.of(context).pop();
                  context.goNamed('login');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Credenciales incorrectas')),
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  AppBar _buildConfiguredAppBar(
      BuildContext context, Map<String, dynamic> config) {
    final primaryColor = Color(int.parse(
        (config['primary_color'] ?? '#E62144').replaceFirst('#', '0xFF')));
    final companyName = config['company_name'] ?? 'MEYPARK';
    final showClock = config['show_clock'] ?? true;
    final timeFormat24h = config['time_format_24h'] ?? true;

    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Logo dinámico
          if (config['logo_url'] != null)
            Image.network(
              config['logo_url'],
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) => _buildDefaultLogo(),
            )
          else
            _buildDefaultLogo(),

          const SizedBox(width: 12),

          // Nombre de la empresa dinámico
          Text(
            companyName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),

          const Spacer(),

          // Reloj y fecha dinámicos
          if (showClock) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeFormat24h
                      ? DateFormat('HH:mm').format(_currentTime)
                      : DateFormat('h:mm a').format(_currentTime),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(_currentTime),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      centerTitle: false,

      // Botón de acceso técnico (5 toques) y login (mantener 3 segundos)
      leading: GestureDetector(
        onTap: _handleTap,
        onLongPressStart: _handleLongPressStart,
        onLongPressEnd: _handleLongPressEnd,
        child: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDefaultLogo() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.local_parking,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  AppBar _buildSimpleAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFE62144),
      elevation: 0,
      automaticallyImplyLeading: false, // Sin hamburguesa
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Fecha y hora de Madrid
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('dd/MM/yyyy').format(_currentTime),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('HH:mm:ss').format(_currentTime),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          // Botones de acción
          Row(
            children: [
              // Botón Idiomas
              _buildActionButton(
                icon: Icons.language,
                label: 'Idiomas',
                onTap: () => _showLanguageDialog(context),
              ),
              const SizedBox(width: 8),
              
              // Botón Accesibilidad
              _buildActionButton(
                icon: Icons.accessibility,
                label: 'Accesibilidad',
                onTap: () => context.go('/accessibility'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇪🇸'),
              title: const Text('Español'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar cambio de idioma
              },
            ),
            ListTile(
              leading: const Text('🇬🇧'),
              title: const Text('English'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar cambio de idioma
              },
            ),
            ListTile(
              leading: const Text('🇫🇷'),
              title: const Text('Français'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar cambio de idioma
              },
            ),
          ],
        ),
      ),
    );
  }
}
