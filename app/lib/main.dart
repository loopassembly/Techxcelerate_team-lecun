import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/fetched_data_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/update_profile_screen.dart';
import 'screens/verify_document_screen.dart';
import 'screens/verification_success_screen.dart';
import 'screens/identity_service_screen.dart';
import 'screens/authentication_screen.dart';
import 'screens/verification_qr_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/onboarding',
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/update-profile',
      builder: (context, state) => const UpdateProfileScreen(),
    ),
    GoRoute(
      path: '/verify-document',
      builder: (context, state) => const VerifyDocumentScreen(),
    ),
    GoRoute(
      path: '/fetched-data',
      builder: (context, state) => const FetchedDataScreen(),
    ),
    GoRoute(
      path: '/verification-success',
      builder: (context, state) => const VerificationSuccessScreen(),
    ),
    GoRoute(
      path: '/identity-service',
      builder: (context, state) => const IdentityServiceScreen(),
    ),
    GoRoute(
      path: '/authentication',
      builder: (context, state) => const AuthenticationScreen(),
    ),
    GoRoute(
      path: '/verification-qr',
      builder: (context, state) => const VerificationQRScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ProtoID',
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