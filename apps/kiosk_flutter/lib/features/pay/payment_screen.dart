import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/dynamic_app_bar.dart';
import '../../core/providers/supabase_providers.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String? _selectedPaymentMethod;

  // Los métodos de pago ahora vienen de Supabase a través del provider

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DynamicAppBar(),
      body: Consumer(
        builder: (context, ref, child) {
          // Obtener métodos de pago desde Supabase
          final paymentMethodsAsync = ref.watch(paymentMethodsProvider);
          
          return paymentMethodsAsync.when(
            data: (paymentMethods) => _buildPaymentContent(paymentMethods),
            loading: () => _buildLoadingContent(),
            error: (error, stack) => _buildErrorContent(error),
          );
        },
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFE62144),
            const Color(0xFF8B1538),
          ],
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildErrorContent(Object error) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFE62144),
            const Color(0xFF8B1538),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error al cargar métodos de pago: $error',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentContent(List<Map<String, dynamic>> paymentMethods) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFE62144),
            const Color(0xFF8B1538),
          ],
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.payment,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Método de Pago',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Selecciona tu método de pago preferido',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Información del pago
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Zona:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const Text(
                            'Zona Centro',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Matrícula:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const Text(
                            'ES-1234ABC',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Duración:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const Text(
                            '2 horas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            '5.00 €',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Métodos de pago
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                final method = paymentMethods[index];
                final isSelected = _selectedPaymentMethod == method['id'];

                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedPaymentMethod = method['id']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Color(int.parse(method['color'].replaceAll('#', '0xFF')))
                            : Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIconFromString(method['icon']),
                          size: 32,
                          color: isSelected 
                              ? Color(int.parse(method['color'].replaceAll('#', '0xFF'))) 
                              : Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          method['name'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected 
                                ? Color(int.parse(method['color'].replaceAll('#', '0xFF'))) 
                                : Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Botón pagar
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed:
                  _selectedPaymentMethod != null ? () => _processPayment(paymentMethods) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedPaymentMethod != null
                    ? Colors.white
                    : Colors.grey.shade300,
                foregroundColor: _selectedPaymentMethod != null
                    ? const Color(0xFFE62144)
                    : Colors.grey.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'PAGAR ${_selectedPaymentMethod != null ? 'CON ${paymentMethods.firstWhere((m) => m['id'] == _selectedPaymentMethod)['name'].toString().toUpperCase()}' : ''}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _processPayment(List<Map<String, dynamic>> paymentMethods) {
    if (_selectedPaymentMethod != null) {
      // Simular procesamiento de pago
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Procesando pago con ${paymentMethods.firstWhere((m) => m['id'] == _selectedPaymentMethod)['name']}...'),
          backgroundColor: Colors.green,
        ),
      );

      // Navegar a resultado después de un breve delay
      Future.delayed(const Duration(seconds: 2), () {
        context.goNamed('pay-result', extra: {
          'success': true,
          'transactionId': 'TXN-${DateTime.now().millisecondsSinceEpoch}',
          'amount': 5.00,
        });
      });
    }
  }

  // Función para convertir strings de iconos a IconData
  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'credit_card':
        return Icons.credit_card;
      case 'nfc':
        return Icons.nfc;
      case 'phone_android':
        return Icons.phone_android;
      case 'money':
        return Icons.money;
      case 'qr_code':
        return Icons.qr_code;
      default:
        return Icons.payment;
    }
  }
}