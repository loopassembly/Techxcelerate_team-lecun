import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FailureScreen extends StatelessWidget {
  const FailureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenSize.height * 0.04),
              Row(
                children: [
                  Text(
                    'Verification Result',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.055,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                    color: const Color(0xFF6881FF),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.08),
              Container(
                width: screenSize.width * 0.5,
                height: screenSize.width * 0.5,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cancel,
                  size: screenSize.width * 0.3,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: screenSize.height * 0.04),
              Text(
                'Unauthorized!',
                style: TextStyle(
                  fontSize: screenSize.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                  vertical: screenSize.height * 0.03,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verification Failed',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      'The ProtoID could not be verified. This may be due to:',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.04,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    _buildErrorItem(
                      context, 
                      'Invalid QR code',
                      screenSize,
                    ),
                    _buildErrorItem(
                      context, 
                      'Expired ProtoID',
                      screenSize,
                    ),
                    _buildErrorItem(
                      context, 
                      'Unregistered user',
                      screenSize,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/login'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF6881FF)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Back to Login',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.04,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6881FF),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenSize.width * 0.04),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.push('/qr-scanner'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6881FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.04,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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

  Widget _buildErrorItem(
    BuildContext context, 
    String text, 
    Size screenSize,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: Colors.red,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: screenSize.width * 0.04,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
