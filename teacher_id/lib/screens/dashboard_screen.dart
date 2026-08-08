import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/intern_model.dart';
import '../providers/intern_provider.dart';
import '../providers/auth_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/glass_container.dart';
import '../widgets/digital_id_card_widget.dart';
import '../services/pdf_service.dart';
import 'add_edit_intern_screen.dart';
import 'intern_profile_screen.dart';
import 'qr_scanner_screen.dart';
import 'activity_log_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const List<String> techList = [
    'All',
    'Flutter',
    'PHP',
    'Python',
    'Java',
    'MERN Stack',
    'Digital Marketing',
    'UI/UX',
    'AI/ML',
    'Data Science',
    'Cyber Security',
  ];

  @override
  Widget build(BuildContext context) {
    final internProvider = Provider.of<InternProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.badge, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DigiCoders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryOrange,
                  ),
                ),
                Text(
                  authProvider.isAdmin ? 'Admin Dashboard' : 'Intern Portal',
                  style: const TextStyle(fontSize: 11, color: AppTheme.secondaryGreen),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // QR Scanner Button
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded, color: AppTheme.primaryOrange),
            tooltip: 'QR / Barcode Scanner',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QrScannerScreen()),
              );
            },
          ),

          // Dark Mode Toggle
          IconButton(
            icon: Icon(
              internProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: internProvider.isDarkMode ? Colors.amber : Colors.indigo,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () => internProvider.toggleDarkMode(),
          ),

          // Activity Log Button (Admin only)
          if (authProvider.isAdmin)
            IconButton(
              icon: const Icon(Icons.history_rounded),
              tooltip: 'Admin Activity Log',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ActivityLogScreen()),
                );
              },
            ),

          // Profile / Logout Popup
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle_rounded),
            onSelected: (val) {
              if (val == 'logout') {
                authProvider.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else if (val == 'switch') {
                authProvider.switchRole(
                  authProvider.isAdmin ? UserRole.intern : UserRole.admin,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'role',
                enabled: false,
                child: Text('Logged in as ${authProvider.userEmail}'),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'switch',
                child: Row(
                  children: [
                    const Icon(Icons.swap_horiz_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text(authProvider.isAdmin ? 'Switch to Intern View' : 'Switch to Admin View'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.red, size: 18),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 400));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Stat Cards Row
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 700 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      StatCard(
                        title: 'Total Interns',
                        value: '${internProvider.totalInternsCount}',
                        icon: Icons.groups_rounded,
                        iconColor: AppTheme.primaryOrange,
                        gradientColors: const [Color(0xFFFF6B00), Color(0xFFFF9E00)],
                      ),
                      StatCard(
                        title: 'Active Interns',
                        value: '${internProvider.activeInternsCount}',
                        icon: Icons.check_circle_outline_rounded,
                        iconColor: AppTheme.secondaryGreen,
                        gradientColors: const [Color(0xFF00A651), Color(0xFF25D366)],
                      ),
                      StatCard(
                        title: 'Completed',
                        value: '${internProvider.completedInternsCount}',
                        icon: Icons.workspace_premium_rounded,
                        iconColor: Colors.blue,
                        gradientColors: const [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                      ),
                      StatCard(
                        title: 'Technologies',
                        value: '${internProvider.technologiesCount}',
                        icon: Icons.memory_rounded,
                        iconColor: Colors.purple,
                        gradientColors: const [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // Quick Actions Bar
              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (authProvider.isAdmin)
                      _buildQuickActionButton(
                        context,
                        icon: Icons.person_add_alt_1_rounded,
                        label: 'Add Intern',
                        color: AppTheme.primaryOrange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddEditInternScreen(),
                            ),
                          );
                        },
                      ),
                    _buildQuickActionButton(
                      context,
                      icon: Icons.qr_code_scanner_rounded,
                      label: 'Scan QR',
                      color: AppTheme.secondaryGreen,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QrScannerScreen(),
                          ),
                        );
                      },
                    ),
                    _buildQuickActionButton(
                      context,
                      icon: Icons.file_download_outlined,
                      label: 'Export Excel',
                      color: Colors.blue,
                      onTap: () {
                        internProvider.generateCsvData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Exported ${internProvider.totalInternsCount} records to CSV/Excel format.'),
                            backgroundColor: AppTheme.secondaryGreen,
                          ),
                        );
                      },
                    ),
                    if (authProvider.isAdmin)
                      _buildQuickActionButton(
                        context,
                        icon: Icons.list_alt_rounded,
                        label: 'Activity Log',
                        color: Colors.purple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ActivityLogScreen(),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Search Input
              TextField(
                onChanged: (val) => internProvider.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: 'Search by Name, ID, Tech, Email or Phone...',
                  prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryOrange),
                  suffixIcon: internProvider.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () => internProvider.setSearchQuery(''),
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 14),

              // Tech Filter Chips Scrollable Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: techList.map((tech) {
                    final isSelected = internProvider.selectedTechnology == tech;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(tech),
                        selectedColor: AppTheme.primaryOrange,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (_) {
                          internProvider.setTechnologyFilter(tech);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // Interns Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Intern Directory (${internProvider.filteredInterns.length})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  DropdownButton<String>(
                    value: internProvider.selectedStatus,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.filter_list_rounded, color: AppTheme.primaryOrange),
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All Status')),
                      DropdownMenuItem(value: 'Active', child: Text('Active Only')),
                      DropdownMenuItem(value: 'Completed', child: Text('Completed Only')),
                    ],
                    onChanged: (val) {
                      if (val != null) internProvider.setStatusFilter(val);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Filtered Intern List
              if (internProvider.filteredInterns.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'No interns found matching filter',
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: internProvider.filteredInterns.length,
                  itemBuilder: (context, index) {
                    final intern = internProvider.filteredInterns[index];
                    return _buildInternCardItem(context, intern, authProvider.isAdmin);
                  },
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: authProvider.isAdmin
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddEditInternScreen()),
                );
              },
              backgroundColor: AppTheme.primaryOrange,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Intern', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildInternCardItem(BuildContext context, InternModel intern, bool isAdmin) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: AppTheme.primaryOrange.withOpacity(0.1),
            backgroundImage: intern.image.startsWith('http') ? NetworkImage(intern.image) : null,
            child: !intern.image.startsWith('http')
                ? Text(
                    intern.fullName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryOrange,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),

          // Intern Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        intern.fullName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: intern.status == 'Active'
                            ? AppTheme.secondaryGreen.withOpacity(0.15)
                            : Colors.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        intern.status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: intern.status == 'Active' ? AppTheme.secondaryGreen : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${intern.internId} • ${intern.technology}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryOrange,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${intern.college} • ${intern.joiningDate}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Quick Action Menu / ID Card Preview Button
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (val) {
              final internProvider = Provider.of<InternProvider>(context, listen: false);
              if (val == 'card') {
                _showDigitalIdModal(context, intern);
              } else if (val == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InternProfileScreen(intern: intern),
                  ),
                );
              } else if (val == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditInternScreen(internToEdit: intern),
                  ),
                );
              } else if (val == 'pdf') {
                PdfService.printOrDownloadIdCard(intern);
              } else if (val == 'delete') {
                _confirmDelete(context, internProvider, intern);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'card',
                child: Row(
                  children: [
                    Icon(Icons.badge_outlined, color: AppTheme.primaryOrange, size: 18),
                    SizedBox(width: 8),
                    Text('View Digital ID Card'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_pin_rounded, color: AppTheme.secondaryGreen, size: 18),
                    SizedBox(width: 8),
                    Text('View Full Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf_rounded, color: Colors.blue, size: 18),
                    SizedBox(width: 8),
                    Text('Download PDF ID Card'),
                  ],
                ),
              ),
              if (isAdmin) ...[
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_rounded, color: Colors.amber, size: 18),
                      SizedBox(width: 8),
                      Text('Edit Intern'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Text('Delete Intern', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showDigitalIdModal(BuildContext context, InternModel intern) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigitalIdCardWidget(intern: intern),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      PdfService.printOrDownloadIdCard(intern);
                    },
                    icon: const Icon(Icons.print_rounded, size: 18),
                    label: const Text('Print / PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
                    label: const Text('Close', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white38),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, InternProvider provider, InternModel intern) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Intern Record'),
        content: Text('Are you sure you want to delete ${intern.fullName} (${intern.internId})?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteIntern(intern.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Deleted ${intern.fullName}')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
