import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/intern_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/glass_container.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  Color _getActionColor(String actionType) {
    switch (actionType) {
      case 'add':
        return AppTheme.secondaryGreen;
      case 'update':
        return Colors.amber;
      case 'delete':
        return Colors.red;
      case 'export':
        return Colors.blue;
      default:
        return AppTheme.primaryOrange;
    }
  }

  IconData _getActionIcon(String actionType) {
    switch (actionType) {
      case 'add':
        return Icons.person_add_rounded;
      case 'update':
        return Icons.edit_rounded;
      case 'delete':
        return Icons.delete_rounded;
      case 'export':
        return Icons.file_download_rounded;
      default:
        return Icons.history_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InternProvider>(context);
    final logs = provider.activityLogs;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Activity Log'),
      ),
      body: logs.isEmpty
          ? const Center(child: Text('No activity logs recorded yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                final color = _getActionColor(log.actionType);
                final icon = _getActionIcon(log.actionType);
                final timeFormatted = DateFormat('dd MMM yyyy, hh:mm a').format(log.timestamp);

                return GlassContainer(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  log.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  timeFormatted,
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              log.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'By: ${log.adminEmail}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
