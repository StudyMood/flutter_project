import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/dish.dart';
import '../sections/about_section.dart';
import '../sections/booking_section.dart';
import '../sections/contact_section.dart';
import '../sections/gallery_section.dart';
import '../sections/hero_section.dart';
import '../sections/menu_section.dart';
import '../theme/app_theme.dart';
import '../widgets/footer_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _sectionKeys = {
    0: GlobalKey(), // Hero
    1: GlobalKey(), // About
    2: GlobalKey(), // Menu
    3: GlobalKey(), // Booking
    4: GlobalKey(), // Gallery
    5: GlobalKey(), // Contact
  };

  final Map<Dish, int> _cart = {};

  void _addToCart(Dish dish) {
    setState(() {
      _cart[dish] = (_cart[dish] ?? 0) + 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.cardDarkElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppTheme.primaryGold),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Added ${dish.name} to order tray',
                style: GoogleFonts.poppins(color: AppTheme.textWhite, fontSize: 13),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'VIEW TRAY',
          textColor: AppTheme.brightGold,
          onPressed: _openCartBottomSheet,
        ),
      ),
    );
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  double get _totalPrice {
    double total = 0;
    _cart.forEach((dish, count) {
      total += dish.price * count;
    });
    return total;
  }

  int get _totalItems {
    int total = 0;
    _cart.values.forEach((count) => total += count);
    return total;
  }

  void _openCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardDarkElevated,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shopping_bag_outlined, color: AppTheme.primaryGold, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            'Your Order Tray',
                            style: GoogleFonts.playfairDisplay(
                              color: AppTheme.primaryGold,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white70),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 10),
                  _cart.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              const Icon(Icons.no_meals_outlined, size: 48, color: AppTheme.textMuted),
                              const SizedBox(height: 12),
                              Text(
                                'Your order tray is currently empty',
                                style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 14),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: _cart.length,
                            separatorBuilder: (_, __) => const Divider(color: Colors.white10),
                            itemBuilder: (context, index) {
                              final dish = _cart.keys.elementAt(index);
                              final count = _cart[dish]!;
                              return Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      dish.imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dish.name,
                                          style: GoogleFonts.poppins(
                                            color: AppTheme.textWhite,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '₹${dish.price.toInt()} each',
                                          style: GoogleFonts.poppins(
                                            color: AppTheme.textMuted,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (count > 1) {
                                              _cart[dish] = count - 1;
                                            } else {
                                              _cart.remove(dish);
                                            }
                                          });
                                          setModalState(() {});
                                        },
                                        icon: const Icon(Icons.remove_circle_outline, size: 20, color: AppTheme.primaryGold),
                                      ),
                                      Text(
                                        '$count',
                                        style: GoogleFonts.poppins(color: AppTheme.textWhite, fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _cart[dish] = count + 1;
                                          });
                                          setModalState(() {});
                                        },
                                        icon: const Icon(Icons.add_circle_outline, size: 20, color: AppTheme.primaryGold),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                  if (_cart.isNotEmpty) ...[
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estimated Total:',
                          style: GoogleFonts.poppins(color: AppTheme.textWhite, fontSize: 16),
                        ),
                        Text(
                          '₹${_totalPrice.toInt()}',
                          style: GoogleFonts.poppins(
                            color: AppTheme.primaryGold,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          final itemsList = _cart.entries
                              .map((e) => '• ${e.key.name} x${e.value} (₹${(e.key.price * e.value).toInt()})')
                              .join('\n');
                          final message = 'Hi Upper Deck Restro! I would like to place an order:\n\n'
                              '$itemsList\n\n'
                              '💰 Total Amount: ₹${_totalPrice.toInt()}';
                          final url = Uri.parse('https://wa.me/917800698999?text=${Uri.encodeComponent(message)}');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          }
                        },
                        icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18, color: Colors.white),
                        label: const Text('SEND ORDER TO WHATSAPP'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.whatsappGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openWhatsApp() async {
    const phone = '917800698999';
    final Uri url = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent('Hi Upper Deck Restro! I have a query.')}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.85),
            border: const Border(bottom: BorderSide(color: Colors.white10)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Brand Logo
                InkWell(
                  onTap: () => _scrollToSection(0),
                  child: Row(
                    children: [
                      const Icon(Icons.deck, color: AppTheme.primaryGold, size: 26),
                      const SizedBox(width: 8),
                      Text(
                        'Upper Deck Restro',
                        style: GoogleFonts.playfairDisplay(
                          color: AppTheme.primaryGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                // Desktop Nav Items
                if (isDesktop)
                  Row(
                    children: [
                      _NavLink(title: 'Home', onTap: () => _scrollToSection(0)),
                      _NavLink(title: 'About', onTap: () => _scrollToSection(1)),
                      _NavLink(title: 'Menu', onTap: () => _scrollToSection(2)),
                      _NavLink(title: 'Reservation', onTap: () => _scrollToSection(3)),
                      _NavLink(title: 'Gallery', onTap: () => _scrollToSection(4)),
                      _NavLink(title: 'Contact', onTap: () => _scrollToSection(5)),
                    ],
                  ),

                // Right Actions (Order Tray Badge & Mobile Menu)
                Row(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          onPressed: _openCartBottomSheet,
                          icon: const Icon(Icons.shopping_bag_outlined, color: AppTheme.primaryGold, size: 26),
                        ),
                        if (_totalItems > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppTheme.brightGold,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                              child: Text(
                                '$_totalItems',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (!isDesktop)
                      PopupMenuButton<int>(
                        icon: const Icon(Icons.menu_rounded, color: AppTheme.primaryGold, size: 28),
                        color: AppTheme.cardDarkElevated,
                        onSelected: _scrollToSection,
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 0, child: Text('Home', style: GoogleFonts.poppins(color: Colors.white))),
                          PopupMenuItem(value: 1, child: Text('About', style: GoogleFonts.poppins(color: Colors.white))),
                          PopupMenuItem(value: 2, child: Text('Menu', style: GoogleFonts.poppins(color: Colors.white))),
                          PopupMenuItem(value: 3, child: Text('Reservation', style: GoogleFonts.poppins(color: Colors.white))),
                          PopupMenuItem(value: 4, child: Text('Gallery', style: GoogleFonts.poppins(color: Colors.white))),
                          PopupMenuItem(value: 5, child: Text('Contact', style: GoogleFonts.poppins(color: Colors.white))),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openWhatsApp,
        backgroundColor: AppTheme.whatsappGreen,
        child: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 26),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(key: _sectionKeys[0], child: HeroSection(onBookTap: () => _scrollToSection(3), onMenuTap: () => _scrollToSection(2))),
            Container(key: _sectionKeys[1], child: const AboutSection()),
            Container(key: _sectionKeys[2], child: MenuSection(onDishAdded: _addToCart)),
            Container(key: _sectionKeys[3], child: const BookingSection()),
            Container(key: _sectionKeys[4], child: const GallerySection()),
            Container(key: _sectionKeys[5], child: const ContactSection()),
            FooterWidget(onNavTap: _scrollToSection),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavLink({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: AppTheme.textWhite,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
