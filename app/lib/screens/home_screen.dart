import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.06,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenSize.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProtoBotHelpButton(context),
                  IconButton(
                    onPressed: () {
                      // Open navigation drawer or menu
                    },
                    icon: const Icon(Icons.menu),
                    color: const Color(0xFF6881FF),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.03),
              _buildShieldLogo(screenSize),
              SizedBox(height: screenSize.height * 0.05),
              _buildWelcomeMessage(context, screenSize, "Shreyansh"),
              SizedBox(height: screenSize.height * 0.025),
              _buildProtoIdBox(context, screenSize, "Your ProtoID :", "972412345678"),
              SizedBox(height: screenSize.height * 0.025),
              _buildProtoIdBox(
                  context, screenSize, "Your DID :", "did:key:z6MkmyLGDkKW4oj7eXueSXCxkQe3uvB4yBxzvi1rWkZaqtW"),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    context,
                    'Get verified',
                    Icons.qr_code_scanner_rounded,
                    onTap: () => context.push('/identity-service'),
                  ),
                  _buildActionButton(
                    context,
                    'Update Profile',
                    Icons.person_outline,
                    onTap: () => context.push('/update-profile'),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProtoBotHelpButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // Show help dialog or navigate to chatbot screen
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('ProtoBot Help'),
            content: const Text('How can I assist you today?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF1FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF6881FF).withOpacity(0.3)),
        ),
        child: const Text(
          'Get help from protoBot',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6881FF),
          ),
        ),
      ),
    );
  }

  Widget _buildShieldLogo(Size screenSize) {
    return Center(
      child: Image.asset('assets/images/shield_check.png',
          width: screenSize.width * 0.60, height: screenSize.width * 0.60),
    );
  }

  Widget _buildWelcomeMessage(
      BuildContext context, Size screenSize, String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Hi $name,\nLet\'s get you Protofied!',
        style: TextStyle(
          fontSize: screenSize.width * 0.065,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildProtoIdBox(
      BuildContext context, Size screenSize, String title ,String protoId) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: screenSize.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF6881FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: screenSize.width * 0.035,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenSize.height * 0.005),
              Container(
                constraints: BoxConstraints(
                  maxWidth: screenSize.width * 0.6,
                ),
                child: Text(
                  protoId,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.045,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: protoId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ProtoID copied to clipboard')),
              );
            },
            icon: const Icon(Icons.copy, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final buttonSize = screenSize.width * 0.43;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: buttonSize,
        height: buttonSize * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF6881FF),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: buttonSize * 0.25,
              color: const Color(0xFF6881FF),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Text(
              label,
              style: TextStyle(
                fontSize: screenSize.width * 0.04,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
