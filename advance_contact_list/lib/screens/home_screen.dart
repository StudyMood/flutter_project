import 'dart:async';
import 'package:flutter/material.dart';
import '../services/contact_service.dart';
import '../widgets/contact_card.dart';
import '../widgets/quick_dial_bar.dart';
import 'add_edit_contact_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ContactService _service = ContactService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _service.removeListener(_onServiceChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onServiceChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filteredContacts = _service.filteredContacts;
    final favContacts = _service.favoriteContacts;
    final isDark = _service.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/icons/icon.png',
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.contact_phone_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Nexus Contacts',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_service.isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: () => _service.toggleViewMode(),
            tooltip: _service.isGridView ? 'Switch to List View' : 'Switch to Grid View',
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () => _service.toggleTheme(),
            tooltip: 'Toggle Light/Dark Theme',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts by name, phone, email...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _service.setSearchQuery('');
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                _debounceTimer?.cancel();
                _debounceTimer = Timer(const Duration(milliseconds: 150), () {
                  _service.setSearchQuery(val);
                });
              },
            ),
          ),

          // Category Chips Filter Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              children: [
                _buildCategoryChip('all', 'All (${_service.totalCount})', Icons.groups_rounded),
                _buildCategoryChip('favorite', 'Favorites (${_service.favCount})', Icons.star_rounded),
                _buildCategoryChip('developer', 'Developer (${_service.developerCount})', Icons.code_rounded),
                _buildCategoryChip('family', 'Family (${_service.familyCount})', Icons.family_restroom_rounded),
                _buildCategoryChip('friends', 'Friends (${_service.friendsCount})', Icons.handshake_rounded),
                _buildCategoryChip('vip', 'VIP (${_service.vipCount})', Icons.workspace_premium_rounded),
                _buildCategoryChip('intern', 'Interns (${_service.internCount})', Icons.school_rounded),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Main Contacts View Body
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Quick Dial Carousel for Favorites (when All or Favorite tab selected)
                if (_service.selectedCategory == 'all' || _service.selectedCategory == 'favorite')
                  SliverToBoxAdapter(
                    child: QuickDialBar(favoriteContacts: favContacts),
                  ),

                // Contacts Title & Count Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Contacts (${filteredContacts.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _service.selectedCategory.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Empty State if no contacts match
                if (filteredContacts.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _service.allContacts.isEmpty
                                ? Icons.person_add_alt_1_rounded
                                : Icons.search_off_rounded,
                            size: 64,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _service.allContacts.isEmpty
                                ? 'No Saved Contacts Yet'
                                : 'No Contacts Found',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _service.allContacts.isEmpty
                                ? 'Tap the "+" button below to add your first contact.'
                                : 'Try adjusting your search query or category filter.',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  // Contacts List / Grid View
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: _service.isGridView
                        ? SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.82,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final contact = filteredContacts[index];
                                return ContactCard(key: ValueKey(contact.id), contact: contact);
                              },
                              childCount: filteredContacts.length,
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final contact = filteredContacts[index];
                                return ContactCard(key: ValueKey(contact.id), contact: contact);
                              },
                              childCount: filteredContacts.length,
                            ),
                          ),
                  ),
              ],
            ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Add Contact'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditContactScreen()),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(String id, String label, IconData icon) {
    final isSelected = _service.selectedCategory == id;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: ChoiceChip(
        avatar: Icon(
          icon,
          size: 16,
          color: isSelected ? Colors.white : theme.primaryColor,
        ),
        label: Text(label),
        selected: isSelected,
        selectedColor: theme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (selected) {
          if (selected) {
            _service.setCategory(id);
          }
        },
      ),
    );
  }
}
