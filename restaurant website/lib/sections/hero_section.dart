import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onBookTap;
  final VoidCallback onMenuTap;

  const HeroSection({
    super.key,
    required this.onBookTap,
    required this.onMenuTap,
  });

  Future<void> _openWhatsApp() async {
    const phone = '917800698999';
    final Uri url = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent('Hi Upper Deck Restro! I would like to inquire about booking a table.')}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 650),
      decoration: BoxDecoration(
        color: AppTheme.darkBackground,
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1552566626-52f8b828add9'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black87,
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.85),
              AppTheme.darkBackground,
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppTheme.primaryGold.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, color: AppTheme.brightGold, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'LUXURY ROOFTOP DINING & NIGHTLIFE',
                        style: GoogleFonts.poppins(
                          color: AppTheme.brightGold,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Heading
                Text(
                  'Upper Deck Restro',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: isDesktop ? 64 : 38,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGold,
                    letterSpacing: 1.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                // Subtitle
                Text(
                  'Experience Lucknow\'s finest Mughlai flavors, signature cocktails & vibrant rooftop party vibes',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: isDesktop ? 18 : 15,
                    color: AppTheme.textWhite.withOpacity(0.9),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 36),
                // Action Buttons
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: onBookTap,
                      icon: const Icon(Icons.table_restaurant, size: 20),
                      label: const Text('BOOK A TABLE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                        elevation: 8,
                        shadowColor: AppTheme.primaryGold.withOpacity(0.4),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: onMenuTap,
                      icon: const Icon(Icons.restaurant_menu, color: AppTheme.primaryGold),
                      label: const Text('EXPLORE MENU'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryGold,
                        side: const BorderSide(color: AppTheme.primaryGold, width: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _openWhatsApp,
                      icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18, color: Colors.white),
                      label: const Text('WHATSAPP INQUIRY'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.whatsappGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 56),
                // Highlights Bar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 30,
                    runSpacing: 20,
                    children: const [
                      _StatBadge(icon: Icons.star, title: '4.9 ★ Rating', subtitle: 'Over 1000+ Reviews'),
                      _StatBadge(icon: Icons.roofing, title: 'Rooftop Lounge', titleColor: AppTheme.primaryGold, subtitle: 'Panoramic View'),
                      _StatBadge(icon: Icons.nightlife, title: 'Live DJ & Bar', subtitle: 'Weekend Nightlife'),
                      _StatBadge(icon: Icons.restaurant, title: 'Authentic Mughlai', subtitle: 'Chef Crafted'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? titleColor;
  final String subtitle;

  const _StatBadge({
    required this.icon,
    required this.title,
    this.titleColor,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryGold.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.primaryGold, size: 22),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: titleColor ?? AppTheme.textWhite,
                fontSize: 14,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
