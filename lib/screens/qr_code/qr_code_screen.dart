import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My QR Code'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Provider.of<ApiService>(context, listen: false).getQRCode(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text('Error loading QR code'),
                ],
              ),
            );
          }
          
          final data = snapshot.data ?? {};
          final user = data['user'] ?? {};
          final qrCode = user['qr_code'] ?? '';
          final studentName = '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}';
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // ID Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey.shade50,
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.school,
                                size: 40,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'STUDENT GOVERNANCE',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Occidental Mindoro State College',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Sablayan Campus',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.blue.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Student Name
                        Text(
                          studentName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        
                        // QR Code
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: QrImageView(
                            data: qrCode,
                            version: QrVersions.auto,
                            size: 200,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // QR Code Value
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            qrCode,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Present for event attendance verification',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Download Button
                ElevatedButton.icon(
                  onPressed: () {
                    // Download QR code
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download ID Card'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

