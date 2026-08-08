import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _makePhoneCall() async {
    final Uri url = Uri.parse('tel:+917800698999');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openMaps() async {
    final Uri url = Uri.parse('https://maps.google.com/?q=Upper+Deck+Restro+Jankipuram+Lucknow');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openWhatsApp() async {
    const phone = '917800698999';
    final Uri url = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent('Hi Upper Deck Restro! I want to get in touch.')}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 850;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppTheme.darkBackground,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Text(
                'VISIT & CONTACT US',
                style: GoogleFonts.poppins(
                  color: AppTheme.primaryGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Location & Operating Hours',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: isDesktop ? 36 : 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              const SizedBox(height: 16),
              Container(width: 60, height: 3, color: AppTheme.primaryGold),
              const SizedBox(height: 40),

              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildContactInfoList()),
                        const SizedBox(width: 40),
                        Expanded(child: _buildMapCard()),
                      ],
                    )
                  : Column(
                      children: [
                        _buildContactInfoList(),
                        const SizedBox(height: 36),
                        _buildMapCard(),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfoList() {
    return Column(
      children: [
        _ContactItemCard(
          icon: Icons.location_on_rounded,
          title: 'Location',
          subtitle: 'Engineering College Chauraha, Jankipuram, Lucknow, Uttar Pradesh 226021',
          actionText: 'Get Directions',
          onTap: _openMaps,
        ),
        const SizedBox(height: 16),
        _ContactItemCard(
          icon: Icons.phone_in_talk_rounded,
          title: 'Direct Call & Reservations',
          subtitle: '+91 78006 98999',
          actionText: 'Call Now',
          onTap: _makePhoneCall,
        ),
        const SizedBox(height: 16),
        _ContactItemCard(
          icon: Icons.access_time_filled_rounded,
          title: 'Operating Hours',
          subtitle: 'Open Daily: 4:00 PM – 1:00 AM Midnight\n(Rooftop Lounge & Bar open till late)',
        ),
        const SizedBox(height: 16),
        _ContactItemCard(
          icon: Icons.chat_rounded,
          title: 'Instant WhatsApp Chat',
          subtitle: 'Quick response for table bookings, parties & corporate events',
          actionText: 'Chat on WhatsApp',
          actionColor: AppTheme.whatsappGreen,
          onTap: _openWhatsApp,
        ),
      ],
    );
  }

  Widget _buildMapCard() {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGold.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.map_rounded, color: AppTheme.primaryGold, size: 48),
          ),
          const SizedBox(height: 20),
          Text(
            'Upper Deck Restro & Lounge',
            style: GoogleFonts.playfairDisplay(
              color: AppTheme.primaryGold,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Jankipuram, Lucknow, UP',
            style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _openMaps,
            icon: const Icon(Icons.near_me_rounded, size: 18),
            label: const Text('OPEN GOOGLE MAPS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionText;
  final Color? actionColor;
  final VoidCallback? onTap;

  const _ContactItemCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.actionColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryGold, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.textWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                    height: 1.4,
                  ),
                ),
                if (actionText != null) ...[
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: onTap,
                    child: Text(
                      actionText!,
                      style: GoogleFonts.poppins(
                        color: actionColor ?? AppTheme.brightGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
