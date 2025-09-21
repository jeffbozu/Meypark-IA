import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/supabase_providers.dart';
import '../../widgets/dynamic_app_bar.dart';
import '../../core/utils/plate_validator.dart';

class PlateInputScreen extends ConsumerStatefulWidget {
  const PlateInputScreen({super.key});

  @override
  ConsumerState<PlateInputScreen> createState() => _PlateInputScreenState();
}

class _PlateInputScreenState extends ConsumerState<PlateInputScreen> {
  String _selectedCountry = 'ES';
  String _plateText = '';
  bool _isValid = false;
  String? _errorMessage;

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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Icon(
                  Icons.directions_car,
                  size: 48,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Matrícula del Vehículo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Introduzca la matrícula del vehículo',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Country selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'País:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
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
                        selectedColor: Colors.blue.shade100,
                        checkmarkColor: Colors.blue.shade700,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Plate display
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
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
                    color: Colors.blue.shade700,
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
              margin: const EdgeInsets.all(16),
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

          // Virtual keyboard
          Expanded(
            child: _buildVirtualKeyboard(),
          ),

          // Continue button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isValid ? _continue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isValid ? Colors.green : Colors.grey,
                minimumSize: const Size(0, 60),
              ),
              child: const Text(
                'CONTINUAR',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVirtualKeyboard() {
    final keys = _getKeyboardKeys();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];

        if (key == 'BACKSPACE') {
          return _buildKeyButton(
            icon: Icons.backspace,
            onTap: _removeLastCharacter,
            color: Colors.red.shade100,
            iconColor: Colors.red.shade700,
          );
        } else if (key == 'CLEAR') {
          return _buildKeyButton(
            icon: Icons.clear,
            onTap: _clearPlate,
            color: Colors.orange.shade100,
            iconColor: Colors.orange.shade700,
          );
        } else {
          return _buildKeyButton(
            text: key,
            onTap: () => _addCharacter(key),
          );
        }
      },
    );
  }

  Widget _buildKeyButton({
    String? text,
    IconData? icon,
    required VoidCallback onTap,
    Color? color,
    Color? iconColor,
  }) {
    return Material(
      color: color ?? Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, color: iconColor ?? Colors.black, size: 24)
                : Text(
                    text!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  List<String> _getKeyboardKeys() {
    switch (_selectedCountry) {
      case 'ES':
        return [
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '0',
          'A',
          'B',
          'C',
          'D',
          'E',
          'F',
          'G',
          'H',
          'I',
          'J',
          'K',
          'L',
          'M',
          'N',
          'Ñ',
          'O',
          'P',
          'Q',
          'R',
          'S',
          'T',
          'U',
          'V',
          'W',
          'X',
          'Y',
          'Z',
          'CLEAR',
          'BACKSPACE',
          '',
          '',
          '',
        ];
      case 'FR':
        return [
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '0',
          'A',
          'B',
          'C',
          'D',
          'E',
          'F',
          'G',
          'H',
          'I',
          'J',
          'K',
          'L',
          'M',
          'N',
          'O',
          'P',
          'Q',
          'R',
          'S',
          'T',
          'U',
          'V',
          'W',
          'X',
          'Y',
          'Z',
          'CLEAR',
          'BACKSPACE',
          '',
          '',
          '',
          '',
        ];
      default:
        return [
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '0',
          'A',
          'B',
          'C',
          'D',
          'E',
          'F',
          'G',
          'H',
          'I',
          'J',
          'K',
          'L',
          'M',
          'N',
          'O',
          'P',
          'Q',
          'R',
          'S',
          'T',
          'U',
          'V',
          'W',
          'X',
          'Y',
          'Z',
          'CLEAR',
          'BACKSPACE',
          '',
          '',
          '',
          '',
        ];
    }
  }

  void _addCharacter(String character) {
    setState(() {
      _plateText += character;
      _validatePlate();
    });
  }

  void _removeLastCharacter() {
    if (_plateText.isNotEmpty) {
      setState(() {
        _plateText = _plateText.substring(0, _plateText.length - 1);
        _validatePlate();
      });
    }
  }

  void _clearPlate() {
    setState(() {
      _plateText = '';
      _validatePlate();
    });
  }

  void _validatePlate() {
    final validator = PlateValidator();
    final result = validator.validate(_plateText, _selectedCountry);

    setState(() {
      _isValid = result.isValid;
      _errorMessage = result.isValid ? null : result.errorMessage;
    });
  }

  void _continue() {
    if (_isValid) {
      // TODO: Guardar matrícula seleccionada y navegar a siguiente pantalla
      print('Plate: $_selectedCountry $_plateText');
      context.go('/pay/duration');
    }
  }
}
