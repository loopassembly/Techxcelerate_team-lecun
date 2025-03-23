import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InstructionScreen extends StatelessWidget {
  const InstructionScreen({super.key});

  Widget _buildProgressIndicator(BuildContext context) {
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
              color: Colors.grey.shade300,
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
                'ProtoID Verification',
                style: TextStyle(
                  fontSize: screenSize.width * 0.055,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: screenSize.height * 0.015),
              _buildProgressIndicator(context),
              SizedBox(height: screenSize.height * 0.06),
              Center(
                child: Container(
                  width: screenSize.width * 0.4,
                  height: screenSize.width * 0.4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6881FF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.qr_code_scanner,
                    size: screenSize.width * 0.25,
                    color: const Color(0xFF6881FF),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.05),
              Text(
                'Step 1: Request the user to present a valid ProtoID QR code',
                style: TextStyle(
                  fontSize: screenSize.width * 0.045,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                'Step 2: Scan the QR code',
                style: TextStyle(
                  fontSize: screenSize.width * 0.045,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                'Step 3: Verify the user\'s identity',
                style: TextStyle(
                  fontSize: screenSize.width * 0.045,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.push('/qr-scanner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6881FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: Text(
                      'Use QR Scanner',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
