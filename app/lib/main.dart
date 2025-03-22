import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProtoID',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6881FF)),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.notoSerif(
            fontSize: 32.0,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            height: 1.2,
          ),
          displayMedium: GoogleFonts.notoSerif(
            fontSize: 28.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.2,
          ),
          displaySmall: GoogleFonts.notoSerif(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.2,
          ),
          headlineMedium: GoogleFonts.notoSerif(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.2,
          ),
          headlineSmall: GoogleFonts.notoSerif(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.2,
          ),
          titleLarge: GoogleFonts.notoSerif(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.2,
          ),
          bodyLarge: GoogleFonts.notoSerif(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
            height: 1.5,
          ),
          bodyMedium: GoogleFonts.notoSerif(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}