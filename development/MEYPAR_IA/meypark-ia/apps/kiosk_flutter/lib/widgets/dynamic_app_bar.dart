import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
      
      // Botón de acceso técico (triple tap)
      leading: GestureDetector(
        onTap: () {
          // Triple tap para acceso técnico
          _handleTripleTap();
        },
        child: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
    );
  }

  int _tapCount = 0;
  Timer? _tapTimer;

  void _handleTripleTap() {
    _tapCount++;
    
    if (_tapTimer != null) {
      _tapTimer!.cancel();
    }
    
    _tapTimer = Timer(const Duration(milliseconds: 500), () {
      if (_tapCount >= 3) {
        // Triple tap detectado - mostrar login técnico
        _showTechnicalLogin();
      }
      _tapCount = 0;
    });
  }

  void _showTechnicalLogin() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Acceso Técnico'),
        content: const Text('Introduce la contraseña técnica:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.goNamed('hidden-login');
            },
            child: const Text('Acceder'),
          ),
        ],
      ),
    );
  }
}