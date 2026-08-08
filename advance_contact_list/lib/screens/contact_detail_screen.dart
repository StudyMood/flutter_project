import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';
import 'add_edit_contact_screen.dart';

class ContactDetailScreen extends StatefulWidget {
  final String contactId;

  const ContactDetailScreen({super.key, required this.contactId});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  Future<void> _launchExternalUrl(String urlString, String fallbackMsg) async {
    if (urlString.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(fallbackMsg)),
        );
      }
      return;
    }
    final Uri uri = Uri.parse(urlString);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $urlString...')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactService = ContactService();
    final contactIndex = contactService.allContacts.indexWhere((c) => c.id == widget.contactId);

    if (contactIndex == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Contact Details')),
        body: const Center(child: Text('Contact not found')),
      );
    }

    final contact = contactService.allContacts[contactIndex];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(
              contact.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: contact.isFavorite ? const Color(0xFFF59E0B) : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                contactService.toggleFavorite(contact.id);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditContactScreen(contact: contact),
                ),
              );
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context, contactService, contact),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Avatar Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    contact.avatarGradient[0].withValues(alpha: 0.25),
                    contact.avatarGradient[1].withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
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
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        contact.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (contact.company.isNotEmpty || contact.jobTitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        contact.jobTitle.isNotEmpty
                            ? '${contact.jobTitle} ${contact.company.isNotEmpty ? "@ ${contact.company}" : ""}'
                            : contact.company,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 12),
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: contact.categoryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: contact.categoryColor, width: 1),
                    ),
                    child: Text(
                      contact.categoryLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: contact.categoryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Action Buttons Row (Call, WhatsApp, Email, LinkedIn)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CircleActionButton(
                  icon: Icons.call,
                  label: 'Call',
                  color: Colors.green,
                  onTap: () => _launchExternalUrl(contact.phoneUriString, 'Phone number not available'),
                ),
                _CircleActionButton(
                  icon: Icons.chat_bubble_rounded,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onTap: () => _launchExternalUrl(contact.whatsappUriString, 'WhatsApp number not available'),
                ),
                _CircleActionButton(
                  icon: Icons.email_rounded,
                  label: 'Gmail',
                  color: const Color(0xFFEA4335), // Gmail Red
                  onTap: () => _launchExternalUrl(
                    contact.email.isNotEmpty ? contact.mailtoUriString : '',
                    'No email address provided for contact',
                  ),
                ),
                _CircleActionButton(
                  icon: Icons.work_rounded,
                  label: 'LinkedIn',
                  color: const Color(0xFF0A66C2), // LinkedIn Blue
                  onTap: () => _launchExternalUrl(
                    contact.linkedinUriString,
                    'No LinkedIn profile provided for contact',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(indent: 20, endIndent: 20),
            const SizedBox(height: 12),

            // Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.phone,
                    label: 'Phone Number',
                    value: contact.phone,
                    onCopy: () {
                      Clipboard.setData(ClipboardData(text: contact.phone));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Phone number copied!')),
                      );
                    },
                  ),
                  if (contact.email.isNotEmpty)
                    _DetailRow(
                      icon: Icons.email,
                      label: 'Email Address',
                      value: contact.email,
                      onCopy: () {
                        Clipboard.setData(ClipboardData(text: contact.email));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email copied!')),
                        );
                      },
                    ),
                  if (contact.linkedin.isNotEmpty)
                    _DetailRow(
                      icon: Icons.work,
                      label: 'LinkedIn Profile',
                      value: contact.linkedinUriString,
                      onCopy: () {
                        Clipboard.setData(ClipboardData(text: contact.linkedinUriString));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('LinkedIn link copied!')),
                        );
                      },
                    ),
                  if (contact.company.isNotEmpty)
                    _DetailRow(
                      icon: Icons.business,
                      label: 'Company',
                      value: contact.company,
                    ),
                  if (contact.birthday != null)
                    _DetailRow(
                      icon: Icons.cake,
                      label: 'Birthday',
                      value: '${contact.birthday!.day}/${contact.birthday!.month}/${contact.birthday!.year} (${contact.daysUntilBirthday ?? 0} days remaining)',
                    ),
                  if (contact.address.isNotEmpty)
                    _DetailRow(
                      icon: Icons.location_on,
                      label: 'Address',
                      value: contact.address,
                    ),
                  if (contact.notes.isNotEmpty)
                    _DetailRow(
                      icon: Icons.notes,
                      label: 'Personal Notes',
                      value: contact.notes,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ContactService service, Contact contact) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${contact.name}?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              service.deleteContact(contact.id);
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close detail screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${contact.name} deleted')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CircleActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.15),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onCopy;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          if (onCopy != null)
            IconButton(
              icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
              onPressed: onCopy,
            ),
        ],
      ),
    );
  }
}
