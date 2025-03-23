import 'package:flutter/material.dart';
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
                  Text(
                    'Get help from protoBot',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.04,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6881FF),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                    color: const Color(0xFF6881FF),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.04),
              Center(
                child: Image.asset(
                  'assets/images/shield_check.png',
                  width: screenSize.width * 0.60,
                  height: screenSize.width * 0.60,
                ),
              ),
              SizedBox(height: screenSize.height * 0.04),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                  vertical: screenSize.height * 0.02,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6881FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hi Shreyanssh,\nLet\'s get you Protofied!',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.045,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    context,
                    'Get verified',
                    Icons.verified_user_outlined,
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
              SizedBox(height: screenSize.height * 0.04),
            ],
          ),
        ),
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
    final buttonSize = screenSize.width * 0.4;

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
            color: const Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: buttonSize * 0.2,
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
