import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dish.dart';
import '../theme/app_theme.dart';

class MenuSection extends StatefulWidget {
  final Function(Dish) onDishAdded;

  const MenuSection({
    super.key,
    required this.onDishAdded,
  });

  @override
  State<MenuSection> createState() => _MenuSectionState();
}

class _MenuSectionState extends State<MenuSection> {
  String selectedCategory = 'All';
  String searchQuery = '';
  bool? filterVegOnly; // null = all, true = veg only, false = non-veg only

  final List<String> categories = [
    'All',
    'Mughlai',
    'Starters',
    'Main Course',
    'Cocktails',
    'Desserts',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredDishes = sampleDishes.where((dish) {
      final matchesCategory = selectedCategory == 'All' || dish.category == selectedCategory;
      final matchesSearch = dish.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          dish.description.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesVeg = filterVegOnly == null || dish.isVeg == filterVegOnly;
      return matchesCategory && matchesSearch && matchesVeg;
    }).toList();

    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppTheme.cardDark.withOpacity(0.5),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Text(
                'OUR MENU',
                style: GoogleFonts.poppins(
                  color: AppTheme.primaryGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Discover Gourmet Culinary Creation',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: isDesktop ? 36 : 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              const SizedBox(height: 16),
              Container(width: 60, height: 3, color: AppTheme.primaryGold),
              const SizedBox(height: 36),

              // Search & Filter Controls
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Search Input
                  SizedBox(
                    width: isDesktop ? 320 : double.infinity,
                    child: TextField(
                      onChanged: (val) => setState(() => searchQuery = val),
                      style: GoogleFonts.poppins(color: AppTheme.textWhite),
                      decoration: InputDecoration(
                        hintText: 'Search biryani, cocktails, paneer...',
                        hintStyle: GoogleFonts.poppins(color: AppTheme.textMuted),
                        prefixIcon: const Icon(Icons.search, color: AppTheme.primaryGold),
                        filled: true,
                        fillColor: AppTheme.cardDarkElevated,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: AppTheme.primaryGold),
                        ),
                      ),
                    ),
                  ),

                  // Veg/Non-Veg Filter Buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: filterVegOnly == null,
                        onSelected: (_) => setState(() => filterVegOnly = null),
                        selectedColor: AppTheme.primaryGold,
                        backgroundColor: AppTheme.cardDarkElevated,
                        labelStyle: TextStyle(
                          color: filterVegOnly == null ? Colors.black : AppTheme.textWhite,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        avatar: const CircleAvatar(backgroundColor: Colors.green, radius: 5),
                        label: const Text('Veg'),
                        selected: filterVegOnly == true,
                        onSelected: (_) => setState(() => filterVegOnly = true),
                        selectedColor: Colors.green.shade800,
                        backgroundColor: AppTheme.cardDarkElevated,
                        labelStyle: const TextStyle(color: AppTheme.textWhite),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        avatar: const CircleAvatar(backgroundColor: Colors.red, radius: 5),
                        label: const Text('Non-Veg'),
                        selected: filterVegOnly == false,
                        onSelected: (_) => setState(() => filterVegOnly = false),
                        selectedColor: Colors.red.shade900,
                        backgroundColor: AppTheme.cardDarkElevated,
                        labelStyle: const TextStyle(color: AppTheme.textWhite),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Category Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: categories.map((cat) {
                    final isSelected = cat == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) setState(() => selectedCategory = cat);
                        },
                        selectedColor: AppTheme.primaryGold,
                        backgroundColor: AppTheme.cardDarkElevated,
                        elevation: isSelected ? 4 : 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

              // Dish Grid
              filteredDishes.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          const Icon(Icons.search_off_rounded, color: AppTheme.textMuted, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'No dishes found matching your search',
                            style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 1;
                        if (constraints.maxWidth > 950) {
                          crossAxisCount = 3;
                        } else if (constraints.maxWidth > 600) {
                          crossAxisCount = 2;
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                            childAspectRatio: 0.78,
                          ),
                          itemCount: filteredDishes.length,
                          itemBuilder: (context, index) {
                            final dish = filteredDishes[index];
                            return _DishCard(
                              dish: dish,
                              onAdd: () => widget.onDishAdded(dish),
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

class _DishCard extends StatelessWidget {
  final Dish dish;
  final VoidCallback onAdd;

  const _DishCard({
    required this.dish,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGold.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: SizedBox(
                  height: 170,
                  width: double.infinity,
                  child: Image.network(
                    dish.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.cardDarkElevated,
                      child: const Icon(Icons.restaurant, color: AppTheme.primaryGold, size: 40),
                    ),
                  ),
                ),
              ),
              // Veg / Non-Veg Indicator Tag
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: dish.isVeg ? Colors.green : Colors.red,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: dish.isVeg ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dish.isVeg ? 'VEG' : 'NON-VEG',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Tag Badge
              if (dish.tag.isNotEmpty)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      dish.tag,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          dish.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: AppTheme.textWhite,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppTheme.brightGold, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            dish.rating.toString(),
                            style: GoogleFonts.poppins(
                              color: AppTheme.brightGold,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dish.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${dish.price.toInt()}',
                        style: GoogleFonts.poppins(
                          color: AppTheme.primaryGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: onAdd,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGold,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
