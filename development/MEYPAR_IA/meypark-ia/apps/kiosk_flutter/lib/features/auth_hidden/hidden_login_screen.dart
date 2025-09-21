import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/supabase_providers.dart';
import '../../widgets/dynamic_app_bar.dart';

class HiddenLoginScreen extends ConsumerStatefulWidget {
  const HiddenLoginScreen({super.key});

  @override
  ConsumerState<HiddenLoginScreen> createState() => _HiddenLoginScreenState();
}

class _HiddenLoginScreenState extends ConsumerState<HiddenLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DynamicAppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Card(
            elevation: 8,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  _buildHeader(),

                  const SizedBox(height: 32),

                  // Formulario de login
                  _buildLoginForm(),

                  const SizedBox(height: 24),

                  // Botón de login
                  _buildLoginButton(),

                  const SizedBox(height: 16),

                  // Botón de cancelar
                  _buildCancelButton(),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    _buildErrorMessage(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.admin_panel_settings,
          size: 64,
          color: Colors.blue.shade700,
        ),
        const SizedBox(height: 16),
        const Text(
          'Acceso Técnico',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Acceso restringido para personal autorizado',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        // Email
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'admin@meypark.com',
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          enabled: !_isLoading,
        ),

        const SizedBox(height: 16),

        // Password
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            hintText: 'Introduzca su contraseña',
            prefixIcon: const Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          obscureText: true,
          enabled: !_isLoading,
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _performLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
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
                    'Iniciando sesión...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : const Text(
                'INICIAR SESIÓN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: _isLoading ? null : () => context.go('/'),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade400),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'CANCELAR',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
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
    );
  }

  Future<void> _performLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, complete todos los campos';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: Implementar autenticación real con Supabase
      await Future.delayed(const Duration(seconds: 2));

      // Simular autenticación
      if (_emailController.text == 'admin@meypark.com' &&
          _passwordController.text == 'admin123') {
        // Login exitoso
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sesión iniciada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/tech-mode');
        }
      } else {
        setState(() {
          _errorMessage = 'Credenciales incorrectas';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
