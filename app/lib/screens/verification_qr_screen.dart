import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VerificationQRScreen extends StatefulWidget {
  const VerificationQRScreen({super.key});

  @override
  State<VerificationQRScreen> createState() => _VerificationQRScreenState();
}

class _VerificationQRScreenState extends State<VerificationQRScreen> {
  bool _isLoading = true;
  String _loadingStep = 'Connecting...';
  String? _qrData;
  int _currentStep = 0;

  final List<String> _loadingSteps = [
    'Connecting...',
    'Retrieving',
    'Fetching Encrypted Data',
    'Decrypting & processing data',
    'Finalizing....',
  ];

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  void _simulateLoading() {
    // Simulate the loading steps with delays
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _currentStep = 0;
        _loadingStep = _loadingSteps[_currentStep];
      });

      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_currentStep < _loadingSteps.length - 1) {
          setState(() {
            _currentStep++;
            _loadingStep = _loadingSteps[_currentStep];
          });
        } else {
          timer.cancel();
          // Generate a unique QR code data with timestamp
          final qrData =
              'PROTOID-VERIFY-${DateTime.now().millisecondsSinceEpoch}';

          setState(() {
            _isLoading = false;
            _qrData = qrData;
          });
        }
      });
    });
  }

  Widget _buildTopLines(BuildContext context) {
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

  Widget _buildLoadingAnimation(Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            strokeWidth: 6,
          ),
        ),
        SizedBox(height: screenSize.height * 0.04),
        Text(
          _loadingStep,
          style: TextStyle(
            fontSize: screenSize.width * 0.045,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: screenSize.height * 0.02),
        SizedBox(
          width: screenSize.width * 0.7,
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / _loadingSteps.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: screenSize.height * 0.01),
        Text(
          'Step ${_currentStep + 1} of ${_loadingSteps.length}',
          style: TextStyle(
            fontSize: screenSize.width * 0.035,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildQRCode(Size screenSize, String qrData) {
    final qrSize = screenSize.width * 0.6;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: qrSize,
          backgroundColor: Colors.white,
        ),
        SizedBox(height: screenSize.height * 0.04),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
          child: Text(
            'Use this QR code to get yourself verified',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenSize.width * 0.04,
              color: const Color(0xFF666666),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
                'Verification QR code',
                style: TextStyle(
                  fontSize: screenSize.width * 0.055,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: screenSize.height * 0.015),
              _buildTopLines(context),
              Expanded(
                child: Center(
                  child: _isLoading
                      ? _buildLoadingAnimation(screenSize)
                      : _buildQRCode(screenSize, _qrData!),
                ),
              ),
              _isLoading
                  ? const SizedBox.shrink()
                  : Padding(
                      padding:
                          EdgeInsets.only(bottom: screenSize.height * 0.05),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => context.go('/home'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6881FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Back to Home',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
