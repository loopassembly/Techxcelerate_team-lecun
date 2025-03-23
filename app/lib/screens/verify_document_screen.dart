import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class VerifyDocumentScreen extends StatelessWidget {
  const VerifyDocumentScreen({super.key});

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
                  Text(
                    'Verify Document',
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
                  _buildAadhaarInput(context),
                  SizedBox(height: screenSize.height * 0.03),
                  _buildGetOTPButton(context),
                  SizedBox(height: screenSize.height * 0.04),
                  Text(
                    'Enter OTP',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.04,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.015),
                  _buildOTPInput(context),
                  SizedBox(height: screenSize.height * 0.03),
                  _buildSubmitButton(context),
                ],
              ),
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

  Widget _buildTopLines() {
    return Row(
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
    );
  }

  Widget _buildAadhaarInput(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return TextFormField(
      decoration: InputDecoration(
        hintText: '1241 6534 2452',
        hintStyle: TextStyle(
          color: const Color(0xFF999999),
          fontSize: screenSize.width * 0.04,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF6881FF),
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      style: TextStyle(
        fontSize: screenSize.width * 0.04,
        color: const Color(0xFF1A1A1A),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12),
        _AadhaarFormatter(),
      ],
    );
  }

  Widget _buildGetOTPButton(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6881FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: Text(
          'Get OTP',
          style: TextStyle(
            fontSize: screenSize.width * 0.04,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildOTPInput(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return TextFormField(
      decoration: InputDecoration(
        hintText: '451342',
        hintStyle: TextStyle(
          color: const Color(0xFF999999),
          fontSize: screenSize.width * 0.04,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF6881FF),
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      style: TextStyle(
        fontSize: screenSize.width * 0.04,
        color: const Color(0xFF1A1A1A),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => context.push('/fetched-data'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6881FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: Text(
          'Submit',
          style: TextStyle(
            fontSize: screenSize.width * 0.04,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
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
