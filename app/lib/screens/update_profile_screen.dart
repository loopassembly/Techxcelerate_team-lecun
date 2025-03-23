import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.06,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenSize.height * 0.04),
                  Row(
                    children: [
                      Text(
                        'Update ProtoID profile using',
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
                  _buildProgressLines(),
                  SizedBox(height: screenSize.height * 0.03),
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE5E5E5),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          fontSize: screenSize.width * 0.04,
                          color: const Color(0xFF999999),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF999999),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  _buildDocumentOption(
                    context,
                    'Aadhaar',
                    'assets/icons/aadhaar.png',
                    onTap: () => context.push('/verify-document'),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  _buildDocumentOption(
                    context,
                    'Birth certificate',
                    'assets/icons/birth_certificate.png',
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  _buildDocumentOption(
                    context,
                    'Driving license',
                    'assets/icons/driving_license.png',
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  _buildDocumentOption(
                    context,
                    'PAN Details',
                    'assets/icons/pan_card.png',
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  _buildDocumentOption(
                    context,
                    'Voter ID card',
                    'assets/icons/voter_id.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentOption(
    BuildContext context,
    String title,
    String iconPath, {
    VoidCallback? onTap,
  }) {
    final screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: screenSize.width * 0.04,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressLines() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFF6881FF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFF6881FF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFF6881FF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
