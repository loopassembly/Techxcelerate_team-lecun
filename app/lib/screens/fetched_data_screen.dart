import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FetchedDataScreen extends StatefulWidget {
  const FetchedDataScreen({super.key});

  @override
  State<FetchedDataScreen> createState() => _FetchedDataScreenState();
}

class _FetchedDataScreenState extends State<FetchedDataScreen> {
  bool _isLoading = true;
  bool _isUploading = false;
  String _loadingStep = 'Connecting...';
  String _uploadingStep = '';
  int _currentStep = 0;
  int _currentUploadStep = 0;
  
  final List<String> _loadingSteps = [
    'Connecting...',
    'Retrieving',
    'Fetching Encrypted Data',
    'Decrypting & processing data',
    'Finalizing....',
  ];
  
  final List<String> _uploadingSteps = [
    'Preparing data...',
    'Encrypting personal information',
    'Connecting to blockchain',
    'Uploading to distributed ledger',
    'Verifying transaction',
    'Finalizing profile update',
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
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
  }
  
  void _simulateUploading() {
    setState(() {
      _isUploading = true;
      _currentUploadStep = 0;
      _uploadingStep = _uploadingSteps[_currentUploadStep];
    });
    
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      if (_currentUploadStep < _uploadingSteps.length - 1) {
        setState(() {
          _currentUploadStep++;
          _uploadingStep = _uploadingSteps[_currentUploadStep];
        });
      } else {
        timer.cancel();
        // Navigate to success screen after upload completes
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            context.push('/verification-success');
          }
        });
      }
    });
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
              const Color(0xFF6881FF),
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
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF6881FF),
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
  
  Widget _buildUploadingAnimation(Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              const Color(0xFF6881FF),
            ),
            strokeWidth: 6,
          ),
        ),
        SizedBox(height: screenSize.height * 0.04),
        Text(
          _uploadingStep,
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
            value: (_currentUploadStep + 1) / _uploadingSteps.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF6881FF),
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: screenSize.height * 0.01),
        Text(
          'Step ${_currentUploadStep + 1} of ${_uploadingSteps.length}',
          style: TextStyle(
            fontSize: screenSize.width * 0.035,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDataContent(Size screenSize) {
    return Column(
      children: [
        Center(
          child: Container(
            width: screenSize.width * 0.5,
            height: screenSize.width * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFCCCCCC),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.person_outline,
              size: screenSize.width * 0.25,
              color: const Color(0xFF666666),
            ),
          ),
        ),
        SizedBox(height: screenSize.height * 0.06),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.05,
            vertical: screenSize.height * 0.02,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F5FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: abc def',
                style: TextStyle(
                  fontSize: screenSize.width * 0.04,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: screenSize.height * 0.01),
              Text(
                'Gender: F',
                style: TextStyle(
                  fontSize: screenSize.width * 0.04,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: screenSize.height * 0.01),
              Text(
                'DOB: 1-1-2000',
                style: TextStyle(
                  fontSize: screenSize.width * 0.04,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: screenSize.height * 0.01),
              Text(
                'Address: asdf, asdf, asdf',
                style: TextStyle(
                  fontSize: screenSize.width * 0.04,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
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
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.06,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenSize.height * 0.03),
              Text(
                _isUploading ? 'Updating Profile' : 'Fetched Data',
                style: TextStyle(
                  fontSize: screenSize.width * 0.055,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: screenSize.height * 0.01),
              _buildTopLines(),
              if (_isLoading)
                Expanded(
                  child: Center(
                    child: _buildLoadingAnimation(screenSize),
                  ),
                )
              else if (_isUploading)
                Expanded(
                  child: Center(
                    child: _buildUploadingAnimation(screenSize),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: screenSize.height * 0.08),
                      _buildDataContent(screenSize),
                      const Spacer(),
                    ],
                  ),
                ),
              if (!_isLoading && !_isUploading)
                Padding(
                  padding: EdgeInsets.only(bottom: screenSize.height * 0.04),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _simulateUploading,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6881FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Update ProtoID profile',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.04,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              else
                SizedBox(height: screenSize.height * 0.04),
            ],
          ),
        ),
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
}
