import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../models/intern_model.dart';
import '../themes/app_theme.dart';

class DigitalIdCardWidget extends StatefulWidget {
  final InternModel intern;
  final bool enableFlip;

  const DigitalIdCardWidget({
    super.key,
    required this.intern,
    this.enableFlip = true,
  });

  @override
  State<DigitalIdCardWidget> createState() => _DigitalIdCardWidgetState();
}

class _DigitalIdCardWidgetState extends State<DigitalIdCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (!widget.enableFlip) return;
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _flipCard,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final angle = _animation.value * math.pi;
              final transform = Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateY(angle);

              final isUnder = _animation.value > 0.5;

              return Transform(
                transform: transform,
                alignment: Alignment.center,
                child: isUnder
                    ? Transform(
                        transform: Matrix4.identity()..rotateY(math.pi),
                        alignment: Alignment.center,
                        child: _buildBackSide(context),
                      )
                    : _buildFrontSide(context),
              );
            },
          ),
        ),
        if (widget.enableFlip) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _flipCard,
            icon: const Icon(Icons.flip_rounded, color: AppTheme.primaryOrange),
            label: Text(
              _isFront ? 'Tap Card to View Back Side' : 'Tap Card to View Front Side',
              style: const TextStyle(
                color: AppTheme.primaryOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFrontSide(BuildContext context) {
    return Container(
      width: 320,
      height: 490,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryOrange, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            // Top Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryOrange, Color(0xFFFF8800)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.code_rounded,
                          color: AppTheme.primaryOrange,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'DIGICODERS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'TRAINING INSTITUTE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Intern Photo Avatar
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryOrange, AppTheme.secondaryGreen],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 43,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: widget.intern.image.startsWith('http')
                        ? NetworkImage(widget.intern.image)
                        : null,
                    child: !widget.intern.image.startsWith('http')
                        ? Text(
                            widget.intern.fullName.isNotEmpty
                                ? widget.intern.fullName[0].toUpperCase()
                                : 'I',
                            style: const TextStyle(
                              fontSize: 34,
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 10),
                        SizedBox(width: 2),
                        Text(
                          'INTERN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Name
            Text(
              widget.intern.fullName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Intern ID Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryOrange.withOpacity(0.4)),
              ),
              child: Text(
                'ID: ${widget.intern.internId}',
                style: const TextStyle(
                  color: AppTheme.primaryOrange,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Technology Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.secondaryGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.intern.technology,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // QR & Barcode Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // QR Code
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: QrImageView(
                      data: widget.intern.internId,
                      version: QrVersions.auto,
                      size: 65.0,
                      foregroundColor: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Joining:', widget.intern.joiningDate),
                        const SizedBox(height: 3),
                        _buildDetailRow('Status:', widget.intern.status, isStatus: true),
                        const SizedBox(height: 3),
                        _buildDetailRow('College:', widget.intern.college),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Barcode
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BarcodeWidget(
                barcode: Barcode.code128(),
                data: widget.intern.internId,
                height: 32,
                drawText: true,
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            // Bottom Green Stripe
            Container(
              height: 10,
              width: double.infinity,
              color: AppTheme.secondaryGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackSide(BuildContext context) {
    return Container(
      width: 320,
      height: 490,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Dark slate
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.secondaryGreen, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondaryGreen.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              const Text(
                'DIGICODERS TECHNOLOGIES',
                style: TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Verification & Company Information',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
              const Divider(color: Colors.white24, height: 20),

              // QR Verification Header
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: QrImageView(
                  data: widget.intern.internId,
                  version: QrVersions.auto,
                  size: 90.0,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Scan QR Code to Verify Authenticity',
                style: TextStyle(
                  color: AppTheme.secondaryGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 14),

              // Company Details
              _buildInfoItem(Icons.language, 'Website', 'www.digicoders.in'),
              const SizedBox(height: 8),
              _buildInfoItem(Icons.email_outlined, 'Email', 'info@digicoders.in'),
              const SizedBox(height: 8),
              _buildInfoItem(Icons.phone_android, 'Phone', '+91 6394296291 / 9140979205'),
              const SizedBox(height: 8),
              _buildInfoItem(Icons.location_on_outlined, 'Address', 'Hazratganj / Alambagh, Lucknow, UP'),

              const Spacer(),

              // Seal & Signature
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'VALIDITY',
                        style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '6 MONTHS',
                        style: TextStyle(color: Colors.orange.shade300, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 1,
                        width: 80,
                        color: Colors.white38,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Authorized Sign',
                        style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isStatus
                  ? (value == 'Active' ? AppTheme.secondaryGreen : Colors.blue)
                  : const Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryOrange, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
