import 'package:flutter/material.dart';

class CategoryMapper {
  /// Maps ministry/category names to appropriate icons
  static IconData getIconForCategory(String category) {
    final lowerCategory = category.toLowerCase();

    if (lowerCategory.contains('agriculture') ||
        lowerCategory.contains('farmer') ||
        lowerCategory.contains('kisan')) {
      return Icons.agriculture;
    } else if (lowerCategory.contains('finance') ||
        lowerCategory.contains('bank') ||
        lowerCategory.contains('economic')) {
      return Icons.account_balance_wallet;
    } else if (lowerCategory.contains('health') ||
        lowerCategory.contains('medical') ||
        lowerCategory.contains('ayush')) {
      return Icons.local_hospital;
    } else if (lowerCategory.contains('education') ||
        lowerCategory.contains('school') ||
        lowerCategory.contains('student')) {
      return Icons.school;
    } else if (lowerCategory.contains('women') ||
        lowerCategory.contains('child') ||
        lowerCategory.contains('nari')) {
      return Icons.woman;
    } else if (lowerCategory.contains('labour') ||
        lowerCategory.contains('employment') ||
        lowerCategory.contains('job')) {
      return Icons.work;
    } else if (lowerCategory.contains('housing') ||
        lowerCategory.contains('urban') ||
        lowerCategory.contains('awas')) {
      return Icons.home;
    } else if (lowerCategory.contains('skill') ||
        lowerCategory.contains('training') ||
        lowerCategory.contains('kaushal')) {
      return Icons.model_training;
    } else if (lowerCategory.contains('pension') ||
        lowerCategory.contains('social') ||
        lowerCategory.contains('welfare')) {
      return Icons.elderly;
    } else if (lowerCategory.contains('msme') ||
        lowerCategory.contains('business') ||
        lowerCategory.contains('enterprise')) {
      return Icons.business_center;
    } else if (lowerCategory.contains('transport') ||
        lowerCategory.contains('road') ||
        lowerCategory.contains('railway')) {
      return Icons.directions_bus;
    } else if (lowerCategory.contains('rural') ||
        lowerCategory.contains('panchayat') ||
        lowerCategory.contains('village')) {
      return Icons.villa;
    } else if (lowerCategory.contains('environment') ||
        lowerCategory.contains('forest') ||
        lowerCategory.contains('climate')) {
      return Icons.eco;
    } else if (lowerCategory.contains('digital') ||
        lowerCategory.contains('technology') ||
        lowerCategory.contains('electronics')) {
      return Icons.computer;
    } else if (lowerCategory.contains('defence') ||
        lowerCategory.contains('army') ||
        lowerCategory.contains('military')) {
      return Icons.security;
    } else if (lowerCategory.contains('law') ||
        lowerCategory.contains('justice') ||
        lowerCategory.contains('legal')) {
      return Icons.gavel;
    } else if (lowerCategory.contains('commerce') ||
        lowerCategory.contains('trade') ||
        lowerCategory.contains('export')) {
      return Icons.store;
    } else if (lowerCategory.contains('tourism') ||
        lowerCategory.contains('culture') ||
        lowerCategory.contains('heritage')) {
      return Icons.tour;
    } else if (lowerCategory.contains('power') ||
        lowerCategory.contains('energy') ||
        lowerCategory.contains('electricity')) {
      return Icons.electric_bolt;
    } else if (lowerCategory.contains('water') ||
        lowerCategory.contains('jal') ||
        lowerCategory.contains('drinking')) {
      return Icons.water_drop;
    } else if (lowerCategory.contains('telecom') ||
        lowerCategory.contains('communication') ||
        lowerCategory.contains('postal')) {
      return Icons.phone;
    } else if (lowerCategory.contains('minority') ||
        lowerCategory.contains('tribal') ||
        lowerCategory.contains('sc/st')) {
      return Icons.diversity_3;
    } else if (lowerCategory.contains('youth') ||
        lowerCategory.contains('sports') ||
        lowerCategory.contains('khel')) {
      return Icons.sports;
    } else if (lowerCategory.contains('textile') ||
        lowerCategory.contains('handloom') ||
        lowerCategory.contains('weaving')) {
      return Icons.checkroom;
    } else if (lowerCategory.contains('food') ||
        lowerCategory.contains('nutrition') ||
        lowerCategory.contains('consumer')) {
      return Icons.restaurant;
    } else if (lowerCategory.contains('insurance') ||
        lowerCategory.contains('bima')) {
      return Icons.shield;
    } else {
      return Icons.description;
    }
  }

  /// Maps category to gradient colors
  static List<Color> getGradientForCategory(String category,
      {required bool isDark}) {
    final lowerCategory = category.toLowerCase();

    if (lowerCategory.contains('agriculture') ||
        lowerCategory.contains('farmer')) {
      return isDark
          ? [const Color(0xFF059669), const Color(0xFF047857)]
          : [const Color(0xFF10B981), const Color(0xFF059669)];
    } else if (lowerCategory.contains('finance') ||
        lowerCategory.contains('bank')) {
      return isDark
          ? [const Color(0xFFF59E0B), const Color(0xFFD97706)]
          : [const Color(0xFFFBBF24), const Color(0xFFF59E0B)];
    } else if (lowerCategory.contains('health') ||
        lowerCategory.contains('medical')) {
      return isDark
          ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
          : [const Color(0xFFF87171), const Color(0xFFEF4444)];
    } else if (lowerCategory.contains('education') ||
        lowerCategory.contains('school')) {
      return isDark
          ? [const Color(0xFF3B82F6), const Color(0xFF2563EB)]
          : [const Color(0xFF60A5FA), const Color(0xFF3B82F6)];
    } else if (lowerCategory.contains('women') ||
        lowerCategory.contains('child')) {
      return isDark
          ? [const Color(0xFFEC4899), const Color(0xFFDB2777)]
          : [const Color(0xFFF472B6), const Color(0xFFEC4899)];
    } else if (lowerCategory.contains('skill') ||
        lowerCategory.contains('training')) {
      return isDark
          ? [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)]
          : [const Color(0xFFA78BFA), const Color(0xFF8B5CF6)];
    } else if (lowerCategory.contains('pension') ||
        lowerCategory.contains('social')) {
      return isDark
          ? [const Color(0xFF64748B), const Color(0xFF475569)]
          : [const Color(0xFF94A3B8), const Color(0xFF64748B)];
    } else {
      return isDark
          ? [const Color(0xFF6366F1), const Color(0xFF4F46E5)]
          : [const Color(0xFF818CF8), const Color(0xFF6366F1)];
    }
  }

  /// Get emoji for category
  static String getEmojiForCategory(String category) {
    final lowerCategory = category.toLowerCase();

    if (lowerCategory.contains('agriculture') ||
        lowerCategory.contains('farmer')) {
      return '🌾';
    } else if (lowerCategory.contains('finance') ||
        lowerCategory.contains('bank')) {
      return '💰';
    } else if (lowerCategory.contains('health') ||
        lowerCategory.contains('medical')) {
      return '🏥';
    } else if (lowerCategory.contains('education') ||
        lowerCategory.contains('school')) {
      return '🎓';
    } else if (lowerCategory.contains('women') ||
        lowerCategory.contains('child')) {
      return '👩';
    } else if (lowerCategory.contains('skill') ||
        lowerCategory.contains('training')) {
      return '🎯';
    } else if (lowerCategory.contains('pension') ||
        lowerCategory.contains('social')) {
      return '👴';
    } else if (lowerCategory.contains('housing') ||
        lowerCategory.contains('awas')) {
      return '🏠';
    } else if (lowerCategory.contains('business') ||
        lowerCategory.contains('msme')) {
      return '💼';
    } else if (lowerCategory.contains('digital') ||
        lowerCategory.contains('technology')) {
      return '💻';
    } else {
      return '📋';
    }
  }

  /// Generate placeholder image widget for scheme
  static Widget getPlaceholderImage(
    String category, {
    double? size,
    double? height,
    required bool isDark,
  }) {
    final colors = getGradientForCategory(category, isDark: isDark);
    final icon = getIconForCategory(category);

    // If height is specified, use it, otherwise use size for both dimensions
    final finalWidth = size ?? double.infinity;
    final finalHeight = height ?? size ?? 120;

    // Calculate icon size based on height (use height or size, default to 60)
    final iconSize =
        height != null ? height * 0.4 : (size != null ? size * 0.5 : 60.0);

    return Container(
      width: finalWidth,
      height: finalHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius:
            size != null ? BorderRadius.circular(12) : BorderRadius.zero,
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}
