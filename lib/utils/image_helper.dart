import 'package:flutter/material.dart';

class ImageHelper {
  /// Generate a placeholder widget when image URL is not available
  static Widget generatePlaceholder(String category, {double size = 200}) {
    final colors = _getCategoryColors(category);
    final icon = _getCategoryIcon(category);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: size * 0.4,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  static List<Color> _getCategoryColors(String category) {
    final categoryLower = category.toLowerCase();

    if (categoryLower.contains('education') ||
        categoryLower.contains('scholarship')) {
      return [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)];
    } else if (categoryLower.contains('health') ||
        categoryLower.contains('medical')) {
      return [const Color(0xFF10B981), const Color(0xFF059669)];
    } else if (categoryLower.contains('agriculture') ||
        categoryLower.contains('farming')) {
      return [const Color(0xFF22C55E), const Color(0xFF16A34A)];
    } else if (categoryLower.contains('women') ||
        categoryLower.contains('girl')) {
      return [const Color(0xFFEC4899), const Color(0xFFDB2777)];
    } else if (categoryLower.contains('employment') ||
        categoryLower.contains('skill')) {
      return [const Color(0xFFF59E0B), const Color(0xFFD97706)];
    } else if (categoryLower.contains('housing') ||
        categoryLower.contains('shelter')) {
      return [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)];
    } else if (categoryLower.contains('social') ||
        categoryLower.contains('welfare')) {
      return [const Color(0xFF06B6D4), const Color(0xFF0891B2)];
    } else if (categoryLower.contains('business') ||
        categoryLower.contains('enterprise')) {
      return [const Color(0xFFEF4444), const Color(0xFFDC2626)];
    } else if (categoryLower.contains('pension') ||
        categoryLower.contains('senior')) {
      return [const Color(0xFF6366F1), const Color(0xFF4F46E5)];
    } else {
      return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
    }
  }

  static IconData _getCategoryIcon(String category) {
    final categoryLower = category.toLowerCase();

    if (categoryLower.contains('education') ||
        categoryLower.contains('scholarship')) {
      return Icons.school_rounded;
    } else if (categoryLower.contains('health') ||
        categoryLower.contains('medical')) {
      return Icons.local_hospital_rounded;
    } else if (categoryLower.contains('agriculture') ||
        categoryLower.contains('farming')) {
      return Icons.agriculture_rounded;
    } else if (categoryLower.contains('women') ||
        categoryLower.contains('girl')) {
      return Icons.woman_rounded;
    } else if (categoryLower.contains('employment') ||
        categoryLower.contains('skill')) {
      return Icons.work_rounded;
    } else if (categoryLower.contains('housing') ||
        categoryLower.contains('shelter')) {
      return Icons.home_rounded;
    } else if (categoryLower.contains('social') ||
        categoryLower.contains('welfare')) {
      return Icons.people_rounded;
    } else if (categoryLower.contains('business') ||
        categoryLower.contains('enterprise')) {
      return Icons.business_rounded;
    } else if (categoryLower.contains('pension') ||
        categoryLower.contains('senior')) {
      return Icons.elderly_rounded;
    } else {
      return Icons.account_balance_rounded;
    }
  }

  /// Get a simple placeholder image URL from an external service
  /// Using picsum.photos for random images based on scheme ID
  static String getPlaceholderUrl(String schemeId,
      {int width = 400, int height = 300}) {
    // Generate a seed based on scheme ID for consistent images
    final seed = schemeId.hashCode.abs() % 1000;
    return 'https://picsum.photos/seed/$seed/$width/$height';
  }
}
