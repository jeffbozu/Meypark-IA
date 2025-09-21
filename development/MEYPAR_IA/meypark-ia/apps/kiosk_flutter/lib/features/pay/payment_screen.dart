import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/supabase_providers.dart';
import '../../widgets/dynamic_app_bar.dart';
import '../../core/utils/currency_formatter.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String _selectedPaymentMethod = 'qr';
  bool _isProcessing = false;

  // Datos de la transacción (normalmente vendrían del estado)
  final double _amount = 5.00;
  final int _duration = 30;
  final String _plate = '1234ABC';
  final String _zone = 'Zona Azul Centro';

  @override
  Widget build(BuildContext context) {
    final aiRecommendations = ref.watch(aiRecommendationsProvider);

    return Scaffold(
      appBar: const DynamicAppBar(),
      body: Column(
        children: [
          // Resumen de la transacción
          _buildTransactionSummary(),

          // Métodos de pago
          _buildPaymentMethods(aiRecommendations),

          const Spacer(),

          // Botón de pago
          _buildPaymentButton(),
        ],
      ),
    );
  }

  Widget _buildTransactionSummary() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          const Text(
            'Resumen de la Transacción',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Matrícula:', style: TextStyle(fontSize: 16)),
              Text(_plate,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Zona:', style: TextStyle(fontSize: 16)),
              Text(_zone,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Duración:', style: TextStyle(fontSize: 16)),
              Text('$_duration minutos',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total a pagar:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                CurrencyFormatter.format(_amount),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(
      AsyncValue<Map<String, dynamic>?> aiRecommendations) {
    final recommendedMethod =
        aiRecommendations.value?['recommended_payment_method'] as String?;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Método de Pago',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Google Pay
          _buildPaymentMethodCard(
            'gpay',
            'Google Pay',
            'Pago rápido y seguro',
            Icons.payment,
            Colors.blue,
            recommendedMethod == 'gpay',
          ),

          const SizedBox(height: 12),

          // Apple Pay
          _buildPaymentMethodCard(
            'apple_pay',
            'Apple Pay',
            'Pago con Touch ID/Face ID',
            Icons.apple,
            Colors.black,
            recommendedMethod == 'apple_pay',
          ),

          const SizedBox(height: 12),

          // QR Code
          _buildPaymentMethodCard(
            'qr',
            'Código QR',
            'Escanee el código para pagar',
            Icons.qr_code,
            Colors.green,
            recommendedMethod == 'qr',
          ),

          const SizedBox(height: 12),

          // EMV/Tarjeta
          _buildPaymentMethodCard(
            'emv',
            'Tarjeta EMV',
            'Inserte o acerque su tarjeta',
            Icons.credit_card,
            Colors.orange,
            recommendedMethod == 'emv',
          ),

          const SizedBox(height: 12),

          // Monedas
          _buildPaymentMethodCard(
            'coins',
            'Monedas',
            'Inserte monedas en la ranura',
            Icons.monetization_on,
            Colors.amber,
            recommendedMethod == 'coins',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    String method,
    String title,
    String description,
    IconData icon,
    Color color,
    bool isRecommended,
  ) {
    final isSelected = _selectedPaymentMethod == method;

    return GestureDetector(
      onTap: () => _selectPaymentMethod(method),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? color : Colors.black,
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Recomendado',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isProcessing ? Colors.grey : Colors.green,
          minimumSize: const Size(0, 60),
        ),
        child: _isProcessing
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Procesando...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Text(
                'PAGAR ${CurrencyFormatter.format(_amount)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  void _selectPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simular procesamiento de pago
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Implementar lógica real de pago
    print(
        'Processing payment: $_selectedPaymentMethod for ${CurrencyFormatter.format(_amount)}');

    setState(() {
      _isProcessing = false;
    });

    // Navegar a pantalla de resultado
    if (mounted) {
      context.go('/pay/result');
    }
  }
}
