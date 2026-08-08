import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppTheme.darkBackground,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Text(
                'ABOUT US',
                style: GoogleFonts.poppins(
                  color: AppTheme.primaryGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome to Upper Deck Restro',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: isDesktop ? 36 : 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 60,
                height: 3,
                color: AppTheme.primaryGold,
              ),
              const SizedBox(height: 40),
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: _buildStoryText()),
                        const SizedBox(width: 50),
                        Expanded(child: _buildImageGrid()),
                      ],
                    )
                  : Column(
                      children: [
                        _buildStoryText(),
                        const SizedBox(height: 40),
                        _buildImageGrid(),
                      ],
                    ),
              const SizedBox(height: 60),
              // Feature Cards
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: const [
                  _FeatureCard(
                    icon: Icons.deck_rounded,
                    title: 'Luxury Rooftop',
                    description: 'Breathtaking open-air rooftop views under starry Lucknow nights.',
                  ),
                  _FeatureCard(
                    icon: Icons.local_bar_rounded,
                    title: 'Craft Cocktails',
                    description: 'Handcrafted signature drinks prepared by expert mixologists.',
                  ),
                  _FeatureCard(
                    icon: Icons.outdoor_grill_rounded,
                    title: 'Authentic Grill & Tandoor',
                    description: 'Rich Mughlai, North Indian & Asian charcoal delicacies.',
                  ),
                  _FeatureCard(
                    icon: Icons.celebration_rounded,
                    title: 'Nightlife & Parties',
                    description: 'Vibrant DJ sessions, private celebrations & corporate events.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lucknow\'s Premier Rooftop Culinary Destination',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryGold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Upper Deck Restro is situated at Engineering College Chauraha, Jankipuram, Lucknow. We combine culinary excellence with high-energy lounge vibes.',
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: AppTheme.textWhite.withOpacity(0.9),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'From rich Mughlai biryanis and smoky kebabs to artisan cocktails and international appetizers, every dish is crafted to perfection. Whether you are planning an intimate dinner or a rooftop bash with live music, Upper Deck Restro offers an unforgettable experience.',
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: AppTheme.textMuted,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildImageGrid() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 320,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryGold.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Image.network(
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryGold, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppTheme.textWhite,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppTheme.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
