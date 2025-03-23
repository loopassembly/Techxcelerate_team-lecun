import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool _isScanning = true;

  @override
  void reassemble() {
    super.reassemble();
    controller.stop();
    controller.start();
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenSize.height * 0.04),
                  Text(
                    'Scan QR Code',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.055,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.015),
                  _buildTopLines(),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    'Position the QR code within the frame to scan',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.04,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenSize.height * 0.04),
            Expanded(
              child: _buildQrView(context),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.06,
                vertical: screenSize.height * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () => controller.toggleTorch(),
                    icon: ValueListenableBuilder(
                      valueListenable: controller.torchState,
                      builder: (context, state, child) {
                        return Icon(
                          state == TorchState.on
                              ? Icons.flash_on
                              : Icons.flash_off,
                          size: 28,
                          color: const Color(0xFF6881FF),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.switchCamera(),
                    icon: const Icon(
                      Icons.flip_camera_ios,
                      size: 28,
                      color: Color(0xFF6881FF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            if (_isScanning &&
                barcodes.isNotEmpty &&
                barcodes.first.rawValue != null) {
              _isScanning = false;

              // For demo purposes, randomly decide success or failure
              final bool isSuccess =
                  DateTime.now().millisecondsSinceEpoch % 2 == 0;

              if (isSuccess) {
                context.push('/success');
              } else {
                context.push('/failure');
              }
            }
          },
        ),
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF6881FF),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
