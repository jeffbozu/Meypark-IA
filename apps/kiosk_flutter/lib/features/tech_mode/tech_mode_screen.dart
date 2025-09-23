import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/supabase_providers.dart';
import '../../widgets/dynamic_app_bar.dart';

class TechModeScreen extends ConsumerStatefulWidget {
  const TechModeScreen({super.key});

  @override
  ConsumerState<TechModeScreen> createState() => _TechModeScreenState();
}

class _TechModeScreenState extends ConsumerState<TechModeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Estado del sistema
  final Map<String, dynamic> _systemStatus = {
    'version': '1.0.0',
    'uptime': '2d 14h 32m',
    'battery': 85,
    'signal': -65,
    'temperature': 42,
    'paper': 78,
    'emv': 'OK',
    'coins': 92,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Técnico'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Estado'),
            Tab(icon: Icon(Icons.build), text: 'Pruebas'),
            Tab(icon: Icon(Icons.list), text: 'Logs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatusTab(),
          _buildTestsTab(),
          _buildLogsTab(),
        ],
      ),
    );
  }

  Widget _buildStatusTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Información general
          _buildInfoCard(),
          const SizedBox(height: 16),

          // Estado del hardware
          _buildHardwareStatus(),
          const SizedBox(height: 16),

          // Estado de la red
          _buildNetworkStatus(),
          const SizedBox(height: 16),

          // Estado de los periféricos
          _buildPeripheralStatus(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información del Sistema',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Versión', _systemStatus['version']),
            _buildInfoRow('Tiempo activo', _systemStatus['uptime']),
            _buildInfoRow('ID del Dispositivo',
                'DEV-${DateTime.now().millisecondsSinceEpoch}'),
            _buildInfoRow('Última conexión', 'Hace 2 minutos'),
            _buildInfoRow('Estado', 'Operativo', isGood: true),
          ],
        ),
      ),
    );
  }

  Widget _buildHardwareStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado del Hardware',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatusRow(
              'Batería',
              '${_systemStatus['battery']}%',
              _systemStatus['battery'] > 20,
              Icons.battery_6_bar,
            ),
            _buildStatusRow(
              'Temperatura',
              '${_systemStatus['temperature']}°C',
              _systemStatus['temperature'] < 50,
              Icons.thermostat,
            ),
            _buildStatusRow(
              'Papel',
              '${_systemStatus['paper']}%',
              _systemStatus['paper'] > 20,
              Icons.description,
            ),
            _buildStatusRow(
              'Monedas',
              '${_systemStatus['coins']}%',
              _systemStatus['coins'] > 20,
              Icons.monetization_on,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado de la Red',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatusRow(
              'Señal WiFi',
              '${_systemStatus['signal']} dBm',
              _systemStatus['signal'] > -80,
              Icons.wifi,
            ),
            _buildStatusRow(
              'Conexión Supabase',
              'Conectado',
              true,
              Icons.cloud_done,
            ),
            _buildStatusRow(
              'Latencia',
              '45 ms',
              true,
              Icons.speed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeripheralStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado de los Periféricos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatusRow(
              'Terminal EMV',
              _systemStatus['emv'],
              _systemStatus['emv'] == 'OK',
              Icons.credit_card,
            ),
            _buildStatusRow(
              'Impresora',
              'Lista',
              true,
              Icons.print,
            ),
            _buildStatusRow(
              'Pantalla Táctil',
              'Funcionando',
              true,
              Icons.touch_app,
            ),
            _buildStatusRow(
              'Altavoces',
              'Funcionando',
              true,
              Icons.volume_up,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pruebas del Sistema',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Pruebas de hardware
          _buildTestCard(
            'Impresora',
            'Prueba de impresión',
            Icons.print,
            () => _runPrinterTest(),
          ),
          const SizedBox(height: 12),

          _buildTestCard(
            'Terminal EMV',
            'Prueba de comunicación EMV',
            Icons.credit_card,
            () => _runEMVTest(),
          ),
          const SizedBox(height: 12),

          _buildTestCard(
            'Pantalla Táctil',
            'Calibración de pantalla táctil',
            Icons.touch_app,
            () => _runTouchTest(),
          ),
          const SizedBox(height: 12),

          _buildTestCard(
            'Altavoces',
            'Prueba de audio',
            Icons.volume_up,
            () => _runAudioTest(),
          ),
          const SizedBox(height: 12),

          _buildTestCard(
            'Conexión de Red',
            'Prueba de conectividad',
            Icons.wifi,
            () => _runNetworkTest(),
          ),
          const SizedBox(height: 12),

          _buildTestCard(
            'Captura de Pantalla',
            'Tomar captura y subir a Supabase',
            Icons.camera_alt,
            () => _runScreenshotTest(),
          ),
          const SizedBox(height: 12),

          _buildTestCard(
            'Recargar Tarifas',
            'Actualizar tarifas desde Supabase',
            Icons.refresh,
            () => _runRefreshTariffs(),
          ),
          const SizedBox(height: 12),

          _buildTestCard(
            'Reiniciar UI',
            'Reiniciar la interfaz de usuario',
            Icons.restart_alt,
            () => _runRestartUI(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Logs del Sistema',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _refreshLogs,
                icon: const Icon(Icons.refresh),
                label: const Text('Actualizar'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filtros de log
          Row(
            children: [
              FilterChip(
                label: const Text('Todos'),
                selected: true,
                onSelected: (selected) {},
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Error'),
                selected: false,
                onSelected: (selected) {},
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Warning'),
                selected: false,
                onSelected: (selected) {},
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Info'),
                selected: false,
                onSelected: (selected) {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Lista de logs
          _buildLogsList(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isGood = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isGood ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(
      String label, String value, bool isGood, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: isGood ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isGood ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCard(
      String title, String description, IconData icon, VoidCallback onTest) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: onTest,
          child: const Text('Ejecutar'),
        ),
      ),
    );
  }

  Widget _buildLogsList() {
    final logs = [
      {
        'level': 'info',
        'message': 'Aplicación iniciada correctamente',
        'time': '14:32:15'
      },
      {'level': 'info', 'message': 'Conectado a Supabase', 'time': '14:32:16'},
      {
        'level': 'info',
        'message': 'Cargando configuración del dispositivo',
        'time': '14:32:17'
      },
      {'level': 'warning', 'message': 'Batería baja: 25%', 'time': '14:35:22'},
      {
        'level': 'error',
        'message': 'Error de conexión EMV',
        'time': '14:38:45'
      },
      {'level': 'info', 'message': 'Reconectando a EMV...', 'time': '14:38:46'},
      {
        'level': 'info',
        'message': 'Conexión EMV restablecida',
        'time': '14:39:12'
      },
      {
        'level': 'info',
        'message': 'Transacción completada: TXN-12345',
        'time': '14:42:33'
      },
    ];

    return Column(
      children: logs.map((log) {
        final level = log['level'] as String;
        final message = log['message'] as String;
        final time = log['time'] as String;

        Color levelColor;
        IconData levelIcon;

        switch (level) {
          case 'error':
            levelColor = Colors.red;
            levelIcon = Icons.error;
            break;
          case 'warning':
            levelColor = Colors.orange;
            levelIcon = Icons.warning;
            break;
          default:
            levelColor = Colors.blue;
            levelIcon = Icons.info;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(levelIcon, color: levelColor),
            title: Text(message),
            subtitle: Text(time),
            trailing: Text(
              level.toUpperCase(),
              style: TextStyle(
                color: levelColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _runPrinterTest() {
    _showTestDialog('Impresora', 'Ejecutando prueba de impresión...', () {
      // TODO: Implementar prueba de impresión
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prueba de impresión completada'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _runEMVTest() {
    _showTestDialog('Terminal EMV', 'Probando comunicación EMV...', () {
      // TODO: Implementar prueba EMV
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prueba EMV completada'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _runTouchTest() {
    _showTestDialog('Pantalla Táctil', 'Calibrando pantalla táctil...', () {
      // TODO: Implementar calibración
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Calibración completada'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _runAudioTest() {
    _showTestDialog('Altavoces', 'Probando audio...', () {
      // TODO: Implementar prueba de audio
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prueba de audio completada'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _runNetworkTest() {
    _showTestDialog('Red', 'Probando conectividad...', () {
      // TODO: Implementar prueba de red
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prueba de red completada'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _runScreenshotTest() {
    _showTestDialog('Captura', 'Tomando captura de pantalla...', () {
      // TODO: Implementar captura y subida
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Captura subida a Supabase'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _runRefreshTariffs() {
    _showTestDialog('Tarifas', 'Actualizando tarifas...', () {
      // TODO: Implementar actualización de tarifas
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarifas actualizadas'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _runRestartUI() {
    _showTestDialog('Reinicio', 'Reiniciando interfaz...', () {
      // TODO: Implementar reinicio de UI
      context.go('/');
    });
  }

  void _showTestDialog(String title, String message, VoidCallback onComplete) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );

    // Simular ejecución de prueba
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      onComplete();
    });
  }

  void _refreshLogs() {
    // TODO: Implementar actualización de logs
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logs actualizados'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
