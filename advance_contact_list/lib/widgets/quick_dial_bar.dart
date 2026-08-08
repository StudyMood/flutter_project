import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../screens/contact_detail_screen.dart';

class QuickDialBar extends StatelessWidget {
  final List<Contact> favoriteContacts;

  const QuickDialBar({super.key, required this.favoriteContacts});

  @override
  Widget build(BuildContext context) {
    if (favoriteContacts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(Icons.bolt, color: Color(0xFFF59E0B), size: 20),
              SizedBox(width: 6),
              Text(
                'Quick Dial & Favorites',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: favoriteContacts.length,
            itemBuilder: (context, index) {
              final contact = favoriteContacts[index];
              return RepaintBoundary(
                key: ValueKey('quick_dial_${contact.id}'),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContactDetailScreen(contactId: contact.id),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: contact.avatarGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: contact.avatarGradient[0].withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
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
                      const SizedBox(height: 6),
                      Text(
                        contact.name.split(' ')[0],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          ),
        ),
      ],
    );
  }
}
