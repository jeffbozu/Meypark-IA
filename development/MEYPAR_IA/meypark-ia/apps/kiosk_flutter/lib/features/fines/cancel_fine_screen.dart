import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/supabase_providers.dart';
import '../../widgets/dynamic_app_bar.dart';
import '../../core/utils/plate_validator.dart';
import '../../core/utils/currency_formatter.dart';

class CancelFineScreen extends ConsumerStatefulWidget {
  const CancelFineScreen({super.key});

  @override
  ConsumerState<CancelFineScreen> createState() => _CancelFineScreenState();
}

class _CancelFineScreenState extends ConsumerState<CancelFineScreen> {
  String _selectedCountry = 'ES';
  String _plateText = '';
  bool _isValid = false;
  String? _errorMessage;
  Map<String, dynamic>? _foundFine;
  bool _isSearching = false;

  final Map<String, String> _countries = {
    'ES': 'España',
    'FR': 'Francia',
    'DE': 'Alemania',
    'IT': 'Italia',
    'PT': 'Portugal',
    'GB': 'Reino Unido',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DynamicAppBar(),
      body: Column(
        children: [
          // Header
          _buildHeader(),

          // Input de matrícula
          _buildPlateInput(),

          // Resultado de búsqueda
          if (_foundFine != null) _buildFineDetails(),

          const Spacer(),

          // Botón de búsqueda/pago
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: Colors.red.shade50,
      child: Column(
        children: [
          Icon(
            Icons.gavel,
            size: 48,
            color: Colors.red.shade700,
          ),
          const SizedBox(height: 16),
          const Text(
            'Anular Denuncia',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Introduzca la matrícula para buscar y pagar la denuncia',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlateInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Matrícula del Vehículo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Selector de país
          Row(
            children: [
              const Text('País:', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 16),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  children: _countries.entries.map((entry) {
                    final isSelected = _selectedCountry == entry.key;
                    return ChoiceChip(
                      label: Text(entry.value),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCountry = entry.key;
                            _validatePlate();
                          });
                        }
                      },
                      selectedColor: Colors.red.shade100,
                      checkmarkColor: Colors.red.shade700,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Input de matrícula
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: _isValid ? Colors.green : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  _selectedCountry,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _plateText.isEmpty ? 'Introduzca la matrícula' : _plateText,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _plateText.isEmpty
                          ? Colors.grey.shade400
                          : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (_isValid)
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
              ],
            ),
          ),

          // Error message
          if (_errorMessage != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFineDetails() {
    final fine = _foundFine!;
    final status = fine['status'] as String;
    final amount = fine['amount_cents'] as int? ?? 0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor(status)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getStatusIcon(status),
                color: _getStatusColor(status),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                _getStatusText(status),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(status),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Matrícula', fine['plate'] ?? ''),
          _buildDetailRow('País', fine['country'] ?? ''),
          _buildDetailRow('Importe', CurrencyFormatter.formatCents(amount)),
          _buildDetailRow('Fecha', _formatDate(fine['created_at'])),
          if (fine['reason'] != null) _buildDetailRow('Motivo', fine['reason']),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (_foundFine == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _isValid && !_isSearching ? _searchFine : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(0, 60),
          ),
          child: _isSearching
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
                      'Buscando...',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : const Text(
                  'BUSCAR DENUNCIA',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      );
    } else {
      final status = _foundFine!['status'] as String;
      if (status == 'active') {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _payFine,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(0, 60),
            ),
            child: Text(
              'PAGAR ${CurrencyFormatter.formatCents(_foundFine!['amount_cents'] ?? 0)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => _goHome(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(0, 60),
            ),
            child: const Text(
              'VOLVER AL INICIO',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    }
  }

  void _validatePlate() {
    final validator = PlateValidator();
    final result = validator.validate(_plateText, _selectedCountry);

    setState(() {
      _isValid = result.isValid;
      _errorMessage = result.isValid ? null : result.errorMessage;
    });
  }

  Future<void> _searchFine() async {
    if (!_isValid) return;

    setState(() {
      _isSearching = true;
    });

    // Simular búsqueda en Supabase
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Implementar búsqueda real en Supabase
    final mockFine = {
      'id': 'FINE-${DateTime.now().millisecondsSinceEpoch}',
      'plate': _plateText,
      'country': _selectedCountry,
      'status': 'active', // 'active', 'paid', 'cancelled'
      'amount_cents': 5000, // 50.00€
      'created_at':
          DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'reason': 'Estacionamiento en zona prohibida',
    };

    setState(() {
      _isSearching = false;
      _foundFine = mockFine;
    });
  }

  Future<void> _payFine() async {
    // TODO: Implementar pago real de denuncia
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Procesando pago de denuncia...'),
        backgroundColor: Colors.green,
      ),
    );

    // Simular pago exitoso
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _foundFine = {
        ..._foundFine!,
        'status': 'paid',
        'paid_at': DateTime.now().toIso8601String(),
      };
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Denuncia pagada exitosamente!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _goHome() {
    context.go('/');
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.red;
      case 'paid':
        return Colors.green;
      case 'cancelled':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'active':
        return Icons.warning;
      case 'paid':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Denuncia Activa';
      case 'paid':
        return 'Denuncia Pagada';
      case 'cancelled':
        return 'Denuncia Cancelada';
      default:
        return 'Estado Desconocido';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }
}
