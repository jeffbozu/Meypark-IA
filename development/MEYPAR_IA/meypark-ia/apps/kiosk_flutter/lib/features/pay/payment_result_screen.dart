import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../widgets/dynamic_app_bar.dart';
import '../../core/utils/currency_formatter.dart';

class PaymentResultScreen extends ConsumerWidget {
  const PaymentResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Datos de la transacción (normalmente vendrían del estado)
    final transactionData = {
      'id': 'TXN-${DateTime.now().millisecondsSinceEpoch}',
      'plate': '1234ABC',
      'zone': 'Zona Azul Centro',
      'duration': 30,
      'amount': 5.00,
      'paymentMethod': 'QR Code',
      'startTime': DateTime.now(),
      'endTime': DateTime.now().add(const Duration(minutes: 30)),
      'qrData':
          'https://meypark.com/verify/TXN-${DateTime.now().millisecondsSinceEpoch}',
    };

    return Scaffold(
      appBar: const DynamicAppBar(),
      body: Column(
        children: [
          // Header de éxito
          _buildSuccessHeader(),

          // Detalles de la transacción
          _buildTransactionDetails(transactionData),

          // QR Code
          _buildQRCode(transactionData['qrData'] as String),

          const Spacer(),

          // Botones de acción
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            '¡Pago Exitoso!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Su estacionamiento ha sido activado',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetails(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detalles de la Transacción',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('ID de Transacción', data['id']),
          _buildDetailRow('Matrícula', data['plate']),
          _buildDetailRow('Zona', data['zone']),
          _buildDetailRow('Duración', '${data['duration']} minutos'),
          _buildDetailRow('Método de Pago', data['paymentMethod']),
          _buildDetailRow('Hora de Inicio', _formatTime(data['startTime'])),
          _buildDetailRow('Hora de Fin', _formatTime(data['endTime'])),
          const Divider(),
          _buildDetailRow(
            'Total Pagado',
            CurrencyFormatter.format(data['amount']),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? Colors.green.shade700 : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCode(String qrData) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Código QR de Verificación',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: 200.0,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Escanee este código para verificar su estacionamiento',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Botón imprimir
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => _printTicket(context),
              icon: const Icon(Icons.print),
              label: const Text('Imprimir Ticket'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Botón enviar por email
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => _sendEmail(context),
              icon: const Icon(Icons.email),
              label: const Text('Enviar por Email'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Botón volver al inicio
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => _goHome(context),
              icon: const Icon(Icons.home),
              label: const Text('Volver al Inicio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _printTicket(BuildContext context) {
    // TODO: Implementar impresión de ticket
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Imprimiendo ticket...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _sendEmail(BuildContext context) {
    // TODO: Implementar envío por email
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enviando por email...'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _goHome(BuildContext context) {
    context.go('/');
  }
}
