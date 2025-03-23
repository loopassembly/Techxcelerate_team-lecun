import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _authenticateWithBiometrics({bool isFace = false}) async {
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      final canAuthenticate = canCheckBiometrics && isDeviceSupported;

      if (!mounted) return;

      if (!canAuthenticate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication not available')),
        );
        return;
      }

      // For debugging
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (!mounted) return;

      if (availableBiometrics.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No biometrics enrolled on this device')),
        );
        return;
      }

      // Debug output to help identify available biometrics
      debugPrint("Available biometrics: $availableBiometrics");

      // Don't check for specific biometric types, just proceed with authentication
      // This handles devices that report generic BiometricType.weak or BiometricType.strong

      final authenticated = await _localAuth.authenticate(
        localizedReason: isFace ? 'Face authentication required' : 'Fingerprint authentication required',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Biometric authentication required',
            cancelButton: 'Cancel',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancel',
          ),
        ],
      );

      if (!mounted) return;

      if (authenticated) {
        // If this is the last biometric screen (face), navigate to verification success
        if (isFace && _currentPage == 3) {
          context.push('/verification-success');
        } else {
          // Otherwise, move to the next onboarding screen
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication cancelled or failed')),
        );
      }
    } on PlatformException catch (e) {
      if (!mounted) return;

      String message = 'Authentication error: ${e.message}';

      if (e.code == auth_error.notAvailable) {
        message = 'Biometric hardware not available';
      } else if (e.code == auth_error.notEnrolled) {
        message = 'No biometrics enrolled';
      } else if (e.code == auth_error.lockedOut || 
                e.code == auth_error.permanentlyLockedOut) {
        message = 'Biometric authentication locked';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: ${e.toString()}')),
      );
    }
  }

  Widget _buildProgressDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _currentPage == index
                    ? const Color(0xFF6881FF)
                    : const Color(0xFF6881FF).withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildTopLines() {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseWidth = screenWidth - 48;
    // Remove unused spacing variable

    // Calculate widths ensuring they're positive
    final availableWidth = baseWidth > 0 ? baseWidth : 0.0;

    // Adjust to make sure the total fits within availableWidth
    final totalParts = 1.0; // 0.7 + 0.2 + 0.1 = 1.0
    final width1 = math.max(0.0, availableWidth * 0.68);
    final width2 = math.max(0.0, availableWidth * 0.18);
    final width3 = math.max(0.0, availableWidth * 0.08);

    // Use Expanded to prevent overflow
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 68,
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 18,
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 8,
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeScreen() {
    final screenSize = MediaQuery.of(context).size;
    final iconSize = screenSize.width * 0.25;
    final buttonWidth = screenSize.width * 0.8;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.06,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/shield_check.png',
              width: iconSize,
              height: iconSize,
            ),
          ),
          SizedBox(height: screenSize.height * 0.04),
          Text(
            'ProtoID',
            style: TextStyle(
              fontSize: screenSize.width * 0.07,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          Text(
            'Secure Digital Identity',
            style: TextStyle(
              fontSize: screenSize.width * 0.04,
              color: const Color(0xFF666666),
            ),
          ),
          SizedBox(height: screenSize.height * 0.06),
          SizedBox(
            width: buttonWidth,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6881FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: screenSize.width * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.04),
          Text(
            'Powered by Blockchain',
            style: TextStyle(
              fontSize: screenSize.width * 0.035,
              color: const Color(0xFF666666),
            ),
          ),
          SizedBox(height: screenSize.height * 0.005),
          Text(
            'Zero-Knowledge Proofs',
            style: TextStyle(
              fontSize: screenSize.width * 0.035,
              color: const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAadhaarScreen() {
    final screenSize = MediaQuery.of(context).size;
    final horizontalPadding = screenSize.width * 0.06;
    final inputHeight = 56.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenSize.height * 0.04),
          Text(
            'Authentication',
            style: TextStyle(
              fontSize: screenSize.width * 0.055,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: screenSize.height * 0.015),
          _buildTopLines(),
          SizedBox(height: screenSize.height * 0.06),
          Text(
            'Aadhaar card number',
            style: TextStyle(
              fontSize: screenSize.width * 0.04,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: screenSize.height * 0.015),
          TextFormField(
            decoration: InputDecoration(
              hintText: '1241 6534 2452',
              hintStyle: TextStyle(
                color: const Color(0xFF999999),
                fontSize: screenSize.width * 0.04,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF6881FF)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _AadhaarFormatter(),
            ],
          ),
          SizedBox(height: screenSize.height * 0.04),
          SizedBox(
            width: double.infinity,
            height: inputHeight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6881FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Get OTP',
                style: TextStyle(
                  fontSize: screenSize.width * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            'OTP',
            style: TextStyle(
              fontSize: screenSize.width * 0.04,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: screenSize.height * 0.015),
          TextFormField(
            decoration: InputDecoration(
              hintText: '451342',
              hintStyle: TextStyle(
                color: const Color(0xFF999999),
                fontSize: screenSize.width * 0.04,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF6881FF)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
          ),
          SizedBox(height: screenSize.height * 0.04),
          SizedBox(
            width: double.infinity,
            height: inputHeight,
            child: ElevatedButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6881FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: screenSize.width * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildFingerprintScreen() {
    final screenSize = MediaQuery.of(context).size;
    final iconSize = screenSize.width * 0.45;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenSize.height * 0.04),
          Text(
            'Authentication',
            style: TextStyle(
              fontSize: screenSize.width * 0.055,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: screenSize.height * 0.015),
          _buildTopLines(),
          SizedBox(height: screenSize.height * 0.06),
          Center(
            child: Text(
              'Fingerprint Authentication',
              style: TextStyle(
                fontSize: screenSize.width * 0.045,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          const Spacer(flex: 1),
          Center(
            child: GestureDetector(
              onTap: () => _authenticateWithBiometrics(),
              child: Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6881FF).withOpacity(0.1),
                ),
                child: Icon(
                  Icons.fingerprint,
                  size: iconSize * 0.7,
                  color: const Color(0xFF6881FF),
                ),
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.04),
          Center(
            child: Text(
              'Place your finger on\nthe fingerprint scanner',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenSize.width * 0.04,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildFaceScreen() {
    final screenSize = MediaQuery.of(context).size;
    final iconSize = screenSize.width * 0.45;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenSize.height * 0.04),
          Text(
            'Authentication',
            style: TextStyle(
              fontSize: screenSize.width * 0.055,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: screenSize.height * 0.015),
          _buildTopLines(),
          SizedBox(height: screenSize.height * 0.06),
          Center(
            child: Text(
              'Face Authentication',
              style: TextStyle(
                fontSize: screenSize.width * 0.045,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          const Spacer(flex: 1),
          Center(
            child: GestureDetector(
              onTap: () => _authenticateWithBiometrics(isFace: true),
              child: Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6881FF).withOpacity(0.1),
                ),
                child: Icon(
                  Icons.face,
                  size: iconSize * 0.7,
                  color: const Color(0xFF6881FF),
                ),
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.04),
          Center(
            child: Text(
              'Click To Scan\nYour Face',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenSize.width * 0.04,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.04),
          Center(
            child: ElevatedButton(
              onPressed: () => _authenticateWithBiometrics(isFace: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6881FF),
                minimumSize: Size(screenSize.width * 0.3, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Scan',
                style: TextStyle(
                  fontSize: screenSize.width * 0.04,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  Column(
                    children: [
                      SizedBox(height: screenSize.height * 0.02),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: _buildTopLines(),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      SizedBox(
                        height: screenSize.height * 0.7,
                        child: _buildWelcomeScreen(),
                      ),
                    ],
                  ),
                  _buildAadhaarScreen(),
                  _buildFingerprintScreen(),
                  _buildFaceScreen(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: screenSize.height * 0.04),
              child: _buildProgressDots(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AadhaarFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > 12) {
      return oldValue;
    }

    final StringBuffer newText = StringBuffer();
    for (int i = 0; i < newValue.text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        newText.write(' ');
      }
      newText.write(newValue.text[i]);
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}