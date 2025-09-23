import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/pay/zone_picker_screen.dart';
import '../../features/pay/plate_input_screen.dart';
import '../../features/pay/duration_screen.dart';
import '../../features/pay/payment_screen.dart';
import '../../features/pay/payment_result_screen.dart';
import '../../features/fines/cancel_fine_screen.dart';
import '../../features/accessibility/accessibility_screen.dart';
import '../../features/tech_mode/tech_mode_screen.dart';
import '../../features/auth_hidden/hidden_login_screen.dart';
import '../../features/auth_hidden/login_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/pay',
        name: 'pay',
        redirect: (context, state) => '/pay/zone',
      ),
      GoRoute(
        path: '/pay/zone',
        name: 'pay-zone',
        builder: (context, state) => const ZonePickerScreen(),
      ),
      GoRoute(
        path: '/pay/plate',
        name: 'pay-plate',
        builder: (context, state) => const PlateInputScreen(),
      ),
      GoRoute(
        path: '/pay/duration',
        name: 'pay-duration',
        builder: (context, state) => const DurationScreen(),
      ),
      GoRoute(
        path: '/pay/payment',
        name: 'pay-payment',
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: '/pay/result',
        name: 'pay-result',
        builder: (context, state) => const PaymentResultScreen(),
      ),
      GoRoute(
        path: '/cancel-fine',
        name: 'cancel-fine',
        builder: (context, state) => const CancelFineScreen(),
      ),
      GoRoute(
        path: '/accessibility',
        name: 'accessibility',
        builder: (context, state) => const AccessibilityScreen(),
      ),
      GoRoute(
        path: '/tech-mode',
        name: 'tech-mode',
        builder: (context, state) => const TechModeScreen(),
      ),
      GoRoute(
        path: '/hidden-login',
        name: 'hidden-login',
        builder: (context, state) => const HiddenLoginScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
