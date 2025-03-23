import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/login_screen.dart';
import 'screens/instruction_screen.dart';
import 'screens/qr_scanner_screen.dart';
import 'screens/success_screen.dart';
import 'screens/failure_screen.dart';

void main() {
  runApp(const ProviderScope(child: OrgApp()));
}

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/login',
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/instruction',
      builder: (context, state) => const InstructionScreen(),
    ),
    GoRoute(
      path: '/qr-scanner',
      builder: (context, state) => const QRScannerScreen(),
    ),
    GoRoute(
      path: '/success',
      builder: (context, state) => const SuccessScreen(),
    ),
    GoRoute(
      path: '/failure',
      builder: (context, state) => const FailureScreen(),
    ),
  ],
);

class OrgApp extends StatelessWidget {
  const OrgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ProtoID Organization',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6881FF),
        ),
        textTheme: GoogleFonts.robotoCondensedTextTheme(),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
