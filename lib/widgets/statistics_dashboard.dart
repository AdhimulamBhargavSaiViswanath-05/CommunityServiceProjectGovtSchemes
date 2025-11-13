import 'package:flutter/material.dart';

class StatisticsDashboard extends StatelessWidget {
  final int totalSchemes;
  final int applicableSchemes;
  final int savedSchemes;

  const StatisticsDashboard({
    super.key,
    required this.totalSchemes,
    required this.applicableSchemes,
    required this.savedSchemes,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Total\nSchemes',
                  totalSchemes.toString(),
                  Icons.apps_rounded,
                  Colors.blue,
                  isDark,
                ),
                _buildStatItem(
                  context,
                  'Applicable\nSchemes',
                  applicableSchemes.toString(),
                  Icons.check_circle_rounded,
                  Colors.green,
                  isDark,
                ),
                _buildStatItem(
                  context,
                  'Saved\nSchemes',
                  savedSchemes.toString(),
                  Icons.bookmark_rounded,
                  Colors.orange,
                  isDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
      ],
    );
  }
}
