import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class FooterWidget extends StatelessWidget {
  final Function(int) onNavTap;

  const FooterWidget({
    super.key,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.deck, color: AppTheme.primaryGold, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    'Upper Deck Restro',
                    style: GoogleFonts.playfairDisplay(
                      color: AppTheme.primaryGold,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Luxury Rooftop Dining & Nightlife in Jankipuram, Lucknow',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Nav Buttons
              Wrap(
                spacing: 20,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _FooterLink(title: 'Home', onTap: () => onNavTap(0)),
                  _FooterLink(title: 'About Us', onTap: () => onNavTap(1)),
                  _FooterLink(title: 'Our Menu', onTap: () => onNavTap(2)),
                  _FooterLink(title: 'Book Table', onTap: () => onNavTap(3)),
                  _FooterLink(title: 'Gallery', onTap: () => onNavTap(4)),
                  _FooterLink(title: 'Contact', onTap: () => onNavTap(5)),
                ],
              ),
              const SizedBox(height: 30),

              const Divider(color: Colors.white10),
              const SizedBox(height: 20),

              Text(
                '📍 Engineering College Chauraha, Jankipuram, Lucknow | 📞 +91 78006 98999',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(
                '© ${DateTime.now().year} Upper Deck Restro. All Rights Reserved.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _FooterLink({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: AppTheme.textWhite,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
