import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myscheme_app/providers/scheme_provider.dart';
import 'package:myscheme_app/providers/user_profile_provider.dart';
import 'package:myscheme_app/models/scheme.dart';
import 'package:myscheme_app/screens/scheme_detail_screen.dart';

/// Smart Notifications Screen - Intelligent scheme notifications
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateNotifications();
    });
  }

  void _generateNotifications() {
    final schemeProvider = Provider.of<SchemeProvider>(context, listen: false);
    final profileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    final schemes = schemeProvider.schemes;

    final notifications = <NotificationItem>[];

    // New matching schemes (last 5)
    for (int i = 0; i < (schemes.length > 5 ? 5 : schemes.length); i++) {
      notifications.add(NotificationItem(
        id: 'new_$i',
        type: NotificationType.newScheme,
        title: 'New Scheme Available',
        message: '${schemes[i].title} matches your profile',
        timestamp: DateTime.now().subtract(Duration(hours: i * 2)),
        scheme: schemes[i],
        isRead: i > 2,
      ));
    }

    // Deadline reminders
    final schemesWithDeadlines = schemes
        .where((s) => s.deadline.isNotEmpty && s.deadline != 'No Deadline')
        .take(3)
        .toList();
    for (int i = 0; i < schemesWithDeadlines.length; i++) {
      notifications.add(NotificationItem(
        id: 'deadline_$i',
        type: NotificationType.deadline,
        title: 'Application Deadline Approaching',
        message:
            '${schemesWithDeadlines[i].title} - Deadline: ${schemesWithDeadlines[i].deadline}',
        timestamp: DateTime.now().subtract(Duration(days: i + 1)),
        scheme: schemesWithDeadlines[i],
        isRead: i > 1,
      ));
    }

    // Document reminders
    if (!profileProvider.profile.hasAadhar ||
        !profileProvider.profile.hasPAN ||
        !profileProvider.profile.hasIncomeCertificate ||
        !profileProvider.profile.hasBankAccount) {
      final missingDocs = <String>[];
      if (!profileProvider.profile.hasAadhar) missingDocs.add('Aadhar Card');
      if (!profileProvider.profile.hasPAN) missingDocs.add('PAN Card');
      if (!profileProvider.profile.hasIncomeCertificate) {
        missingDocs.add('Income Certificate');
      }
      if (!profileProvider.profile.hasBankAccount) {
        missingDocs.add('Bank Account Details');
      }

      notifications.add(NotificationItem(
        id: 'doc_reminder',
        type: NotificationType.documentReminder,
        title: 'Complete Your Documents',
        message:
            'Upload ${missingDocs.length} missing documents: ${missingDocs.take(2).join(", ")}${missingDocs.length > 2 ? "..." : ""}',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: false,
      ));
    }

    // Profile update reminder
    notifications.add(NotificationItem(
      id: 'profile_update',
      type: NotificationType.profileUpdate,
      title: 'Keep Your Profile Updated',
      message: 'Regular profile updates help us find better schemes for you',
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      isRead: true,
    ));

    // Sort by timestamp (newest first)
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    setState(() {
      _notifications.clear();
      _notifications.addAll(notifications);
    });
  }

  void _markAsRead(String id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n.id == id);
      notification.isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (final notification in _notifications) {
        notification.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear All Notifications?'),
        content: const Text(
          'This will remove all notifications. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notifications.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications cleared'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0F172A),
                    const Color(0xFF1E293B),
                  ]
                : [
                    const Color(0xFFF0F9FF),
                    const Color(0xFFE0F2FE),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark, unreadCount),
              if (_notifications.isEmpty)
                Expanded(child: _buildEmptyState())
              else
                Expanded(child: _buildNotificationsList(isDark)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, int unreadCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Stay updated with latest schemes',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              if (unreadCount > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    '$unreadCount New',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          if (_notifications.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: unreadCount > 0 ? _markAllAsRead : null,
                    icon: const Icon(Icons.done_all, size: 18),
                    label: const Text('Mark All Read'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('Clear All'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationsList(bool isDark) {
    // Group notifications by time
    final today = <NotificationItem>[];
    final yesterday = <NotificationItem>[];
    final earlier = <NotificationItem>[];

    final now = DateTime.now();
    for (final notification in _notifications) {
      final difference = now.difference(notification.timestamp).inHours;
      if (difference < 24) {
        today.add(notification);
      } else if (difference < 48) {
        yesterday.add(notification);
      } else {
        earlier.add(notification);
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (today.isNotEmpty) ...[
          _buildSectionHeader('Today', isDark),
          ...today.map((n) => _buildNotificationCard(n, isDark)),
        ],
        if (yesterday.isNotEmpty) ...[
          _buildSectionHeader('Yesterday', isDark),
          ...yesterday.map((n) => _buildNotificationCard(n, isDark)),
        ],
        if (earlier.isNotEmpty) ...[
          _buildSectionHeader('Earlier', isDark),
          ...earlier.map((n) => _buildNotificationCard(n, isDark)),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, bool isDark) {
    final colors = _getTypeColors(notification.type);

    return GestureDetector(
      onTap: () {
        _markAsRead(notification.id);
        if (notification.scheme != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SchemeDetailScreen(scheme: notification.scheme!),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: notification.isRead
              ? (isDark ? const Color(0xFF1E293B) : Colors.white)
              : colors['background'],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead
                ? Colors.grey.withValues(alpha: 0.2)
                : colors['border']!,
            width: notification.isRead ? 1 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: notification.isRead
                  ? Colors.black.withValues(alpha: 0.05)
                  : colors['shadow']!,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: notification.isRead
                      ? null
                      : LinearGradient(colors: [
                          colors['icon']!,
                          colors['icon']!.withValues(alpha: 0.7),
                        ]),
                  color: notification.isRead
                      ? Colors.grey.withValues(alpha: 0.2)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(notification.type),
                  color: notification.isRead ? Colors.grey : Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: colors['icon'],
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
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
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7C3AED).withValues(alpha: 0.2),
                  const Color(0xFF6366F1).withValues(alpha: 0.2),
                ],
              ),
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 80,
              color: Color(0xFF7C3AED),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, Color> _getTypeColors(NotificationType type) {
    switch (type) {
      case NotificationType.newScheme:
        return {
          'icon': const Color(0xFF7C3AED),
          'background': const Color(0xFF7C3AED).withValues(alpha: 0.1),
          'border': const Color(0xFF7C3AED).withValues(alpha: 0.3),
          'shadow': const Color(0xFF7C3AED).withValues(alpha: 0.2),
        };
      case NotificationType.deadline:
        return {
          'icon': const Color(0xFFEF4444),
          'background': const Color(0xFFEF4444).withValues(alpha: 0.1),
          'border': const Color(0xFFEF4444).withValues(alpha: 0.3),
          'shadow': const Color(0xFFEF4444).withValues(alpha: 0.2),
        };
      case NotificationType.documentReminder:
        return {
          'icon': const Color(0xFFF59E0B),
          'background': const Color(0xFFF59E0B).withValues(alpha: 0.1),
          'border': const Color(0xFFF59E0B).withValues(alpha: 0.3),
          'shadow': const Color(0xFFF59E0B).withValues(alpha: 0.2),
        };
      case NotificationType.profileUpdate:
        return {
          'icon': const Color(0xFF10B981),
          'background': const Color(0xFF10B981).withValues(alpha: 0.1),
          'border': const Color(0xFF10B981).withValues(alpha: 0.3),
          'shadow': const Color(0xFF10B981).withValues(alpha: 0.2),
        };
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.newScheme:
        return Icons.new_releases;
      case NotificationType.deadline:
        return Icons.alarm;
      case NotificationType.documentReminder:
        return Icons.description;
      case NotificationType.profileUpdate:
        return Icons.person;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

/// Notification Type Enum
enum NotificationType {
  newScheme,
  deadline,
  documentReminder,
  profileUpdate,
}

/// Notification Item Model
class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final Scheme? scheme;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.scheme,
    this.isRead = false,
  });
}
