import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    // Start authentication after a short delay to allow the screen to build
    Future.delayed(const Duration(milliseconds: 500), () {
      _authenticate();
    });
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      final canAuthenticate = canCheckBiometrics && isDeviceSupported;

      if (!mounted) return;

      if (!canAuthenticate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication not available')),
        );
        setState(() {
          _isAuthenticating = false;
        });
        return;
      }

      // For debugging
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (!mounted) return;

      if (availableBiometrics.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No biometrics enrolled on this device')),
        );
        setState(() {
          _isAuthenticating = false;
        });
        return;
      }

      // Debug output to help identify available biometrics
      debugPrint("Available biometrics: $availableBiometrics");

      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Fingerprint authentication required',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Fingerprint authentication required',
            cancelButton: 'Cancel',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancel',
          ),
        ],
      );

      if (!mounted) return;

      if (authenticated) {
        context.push('/verification-qr');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication cancelled or failed. Try again.')),
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
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  Widget _buildTopLines() {
    return Row(
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final iconSize = screenSize.width * 0.45;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
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
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _authenticate,
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
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                  child: Text(
                    'Place your finger on the fingerprint scanner while under surveillance of authorized personnel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenSize.width * 0.04,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
