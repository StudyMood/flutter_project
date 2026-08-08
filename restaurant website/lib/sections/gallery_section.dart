import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/gallery_item.dart';
import '../theme/app_theme.dart';

class GallerySection extends StatefulWidget {
  const GallerySection({super.key});

  @override
  State<GallerySection> createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection> {
  String selectedFilter = 'All';

  final List<String> filters = ['All', 'Ambience', 'Food', 'Cocktails', 'Nightlife'];

  void _openLightbox(GalleryItem item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black87, blurRadius: 30, spreadRadius: 10),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: AppTheme.cardDark,
                      child: Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: AppTheme.primaryGold,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = selectedFilter == 'All'
        ? sampleGalleryItems
        : sampleGalleryItems.where((item) => item.category == selectedFilter).toList();

    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppTheme.cardDark.withOpacity(0.4),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Text(
                'GALLERY',
                style: GoogleFonts.poppins(
                  color: AppTheme.primaryGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Glimpse of Upper Deck Restro',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: isDesktop ? 36 : 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              const SizedBox(height: 16),
              Container(width: 60, height: 3, color: AppTheme.primaryGold),
              const SizedBox(height: 30),

              // Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: filters.map((filter) {
                    final isSelected = filter == selectedFilter;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) setState(() => selectedFilter = filter);
                        },
                        selectedColor: AppTheme.primaryGold,
                        backgroundColor: AppTheme.cardDarkElevated,
                        labelStyle: GoogleFonts.poppins(
                          color: isSelected ? Colors.black : AppTheme.textWhite,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 40),

              // Gallery Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  int count = 1;
                  if (constraints.maxWidth > 900) {
                    count = 3;
                  } else if (constraints.maxWidth > 550) {
                    count = 2;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: count,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return InkWell(
                        onTap: () => _openLightbox(item),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.8),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        item.title,
                                        style: GoogleFonts.poppins(
                                          color: AppTheme.textWhite,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        item.category,
                                        style: GoogleFonts.poppins(
                                          color: AppTheme.primaryGold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
