import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';
import '../screens/contact_detail_screen.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;

  const ContactCard({super.key, required this.contact});

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    if (urlString.trim().isEmpty) return;
    final Uri uri = Uri.parse(urlString);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $urlString...')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactService = ContactService();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RepaintBoundary(
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ContactDetailScreen(contactId: contact.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar with Initials and Gradient
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: contact.avatarGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: contact.avatarGradient[0].withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        contact.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Contact Main Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                contact.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Favorite Star Button
                            IconButton(
                              icon: Icon(
                                contact.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                                color: contact.isFavorite ? const Color(0xFFF59E0B) : Colors.grey,
                                size: 24,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                contactService.toggleFavorite(contact.id);
                              },
                            ),
                          ],
                        ),

                        if (contact.company.isNotEmpty || contact.jobTitle.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              contact.jobTitle.isNotEmpty
                                  ? '${contact.jobTitle} ${contact.company.isNotEmpty ? "@ ${contact.company}" : ""}'
                                  : contact.company,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                        const SizedBox(height: 6),

                        // Category Pill Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: contact.categoryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: contact.categoryColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: contact.categoryColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                contact.categoryLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: contact.categoryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
              const SizedBox(height: 8),

              // Action Buttons Row (Phone, Copy, Details)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        contact.phone,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      // Quick Call Button
                      _ActionButton(
                        icon: Icons.call,
                        color: Colors.green,
                        onPressed: () => _launchUrl(context, contact.phoneUriString),
                      ),
                      const SizedBox(width: 8),

                      // Quick WhatsApp Button
                      _ActionButton(
                        icon: Icons.chat_bubble_outline,
                        color: const Color(0xFF25D366),
                        onPressed: () => _launchUrl(context, contact.whatsappUriString),
                      ),

                      const SizedBox(width: 8),

                      // Detail Chevron
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
