import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../models/intern_model.dart';
import '../themes/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/digital_id_card_widget.dart';
import '../services/pdf_service.dart';

class InternProfileScreen extends StatelessWidget {
  final InternModel intern;

  const InternProfileScreen({super.key, required this.intern});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Intern Profile Verification'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, color: AppTheme.primaryOrange),
            tooltip: 'Download PDF ID Card',
            onPressed: () => PdfService.printOrDownloadIdCard(intern),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppTheme.secondaryGreen),
            tooltip: 'Share Profile',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sharing profile of ${intern.fullName} (${intern.internId})...'),
                  backgroundColor: AppTheme.secondaryGreen,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Verified Header Banner
            GlassContainer(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 54,
                        backgroundColor: AppTheme.primaryOrange,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: intern.image.startsWith('http')
                              ? NetworkImage(intern.image)
                              : null,
                          child: !intern.image.startsWith('http')
                              ? Text(
                                  intern.fullName[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryOrange,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppTheme.secondaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    intern.fullName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'ID: ${intern.internId}',
                          style: const TextStyle(
                            color: AppTheme.primaryOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          intern.technology,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppTheme.secondaryGreen, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Verified DigiCoders Intern • ${intern.status} Status',
                        style: const TextStyle(
                          color: AppTheme.secondaryGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3D Flippable Digital ID Card Preview
            Text(
              'Interactive Digital ID Card',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),
            DigitalIdCardWidget(intern: intern),

            const SizedBox(height: 20),

            // Profile Details List
            GlassContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Complete Profile Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryOrange),
                  ),
                  const Divider(height: 20),
                  _buildProfileRow(Icons.email_outlined, 'Email Address', intern.email),
                  _buildProfileRow(Icons.phone_android_outlined, 'Contact Number', intern.phone),
                  _buildProfileRow(Icons.calendar_month_outlined, 'Joining Date', intern.joiningDate),
                  _buildProfileRow(Icons.school_outlined, 'College / Institution', intern.college),
                  _buildProfileRow(Icons.location_on_outlined, 'Address', intern.address),
                  _buildProfileRow(Icons.verified_outlined, 'Internship Status', intern.status),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // QR & Barcode Section
            GlassContainer(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Verification System Codes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: QrImageView(
                          data: intern.internId,
                          version: QrVersions.auto,
                          size: 110.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: intern.internId,
                    height: 45,
                    drawText: true,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Bottom Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => PdfService.printOrDownloadIdCard(intern),
                    icon: const Icon(Icons.print_rounded),
                    label: const Text('Print / Download PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                Text(
                  value.isNotEmpty ? value : 'N/A',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
