import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildProgressIndicator() {
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
              color: Colors.grey.shade300,
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenSize.height * 0.04),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.055,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.015),
                _buildProgressIndicator(),
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
                      Icons.verified_user,
                      size: screenSize.width * 0.25,
                      color: const Color(0xFF6881FF),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.06),
                TextFormField(
                  controller: _userIdController,
                  decoration: InputDecoration(
                    labelText: 'User ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your User ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenSize.height * 0.02),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.push('/instruction');
                      }
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
                SizedBox(height: screenSize.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
