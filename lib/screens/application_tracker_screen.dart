import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myscheme_app/providers/user_profile_provider.dart';
import 'package:myscheme_app/providers/scheme_provider.dart';
import 'package:myscheme_app/models/scheme.dart';
import 'package:myscheme_app/screens/scheme_detail_screen.dart';

/// Application Tracker Screen - Track scheme application status
class ApplicationTrackerScreen extends StatefulWidget {
  const ApplicationTrackerScreen({super.key});

  @override
  State<ApplicationTrackerScreen> createState() =>
      _ApplicationTrackerScreenState();
}

class _ApplicationTrackerScreenState extends State<ApplicationTrackerScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Pending',
    'Approved',
    'Rejected',
    'Under Review'
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profileProvider = Provider.of<UserProfileProvider>(context);
    final appliedSchemes = profileProvider.profile.appliedSchemes;

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
              _buildHeader(context, isDark, appliedSchemes.length),
              _buildFilterChips(isDark),
              Expanded(
                child: _buildApplicationList(
                  context,
                  appliedSchemes,
                  isDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, bool isDark, int totalApplications) {
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
                      'Application Tracker',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track your scheme applications',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.folder_open,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '$totalApplications',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white70 : Colors.black87),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              selectedColor: const Color(0xFF7C3AED),
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFF7C3AED)
                    : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildApplicationList(
    BuildContext context,
    List<String> appliedSchemes,
    bool isDark,
  ) {
    if (appliedSchemes.isEmpty) {
      return _buildEmptyState();
    }

    final schemeProvider = Provider.of<SchemeProvider>(context);
    final applications = appliedSchemes
        .map((schemeId) {
          final scheme = schemeProvider.schemes.firstWhere(
            (s) => s.id == schemeId,
            orElse: () => Scheme(
              id: schemeId,
              slug: '',
              title: 'Unknown Scheme',
              shortTitle: '',
              description: '',
              detailedDescription: '',
              ministry: '',
              benefits: '',
              eligibility: '',
              exclusions: '',
              applicationProcess: '',
              documents: [],
              faqs: [],
              references: [],
              category: '',
              deadline: '',
              link: '',
            ),
          );
          return ApplicationInfo(
            scheme: scheme,
            status: _getRandomStatus(schemeId),
            appliedDate: _getRandomDate(),
            lastUpdated: _getRandomDate(),
            applicationId:
                'APP${schemeId.hashCode.abs().toString().substring(0, 6)}',
          );
        })
        .where(
            (app) => _selectedFilter == 'All' || app.status == _selectedFilter)
        .toList();

    if (applications.isEmpty) {
      return _buildNoResultsState(_selectedFilter);
    }

    return RefreshIndicator(
      onRefresh: () async {
        final messenger = ScaffoldMessenger.of(context);
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Applications refreshed'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: applications.length,
        itemBuilder: (context, index) {
          return _buildApplicationCard(applications[index], isDark);
        },
      ),
    );
  }

  Widget _buildApplicationCard(ApplicationInfo app, bool isDark) {
    final statusColor = _getStatusColor(app.status);
    final statusIcon = _getStatusIcon(app.status);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SchemeDetailScreen(scheme: app.scheme),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: statusColor.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with status badge
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    statusColor.withValues(alpha: 0.2),
                    statusColor.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app.scheme.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          app.scheme.ministry,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      app.status,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Application details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.confirmation_number,
                    'Application ID',
                    app.applicationId,
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Applied Date',
                    _formatDate(app.appliedDate),
                    Colors.purple,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.update,
                    'Last Updated',
                    _formatDate(app.lastUpdated),
                    Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  _buildTimeline(app, statusColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(ApplicationInfo app, Color statusColor) {
    final stages = _getApplicationStages(app.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Application Progress',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 16),
          ...stages.asMap().entries.map((entry) {
            final index = entry.key;
            final stage = entry.value;
            final isLast = index == stages.length - 1;

            return _buildTimelineItem(
              stage['title']!,
              stage['subtitle']!,
              stage['completed']! == 'true',
              !isLast,
              statusColor,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String subtitle,
    bool completed,
    bool showLine,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? color : Colors.grey.withValues(alpha: 0.3),
                border: Border.all(
                  color: completed ? color : Colors.grey.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: completed
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
            if (showLine)
              Container(
                width: 2,
                height: 40,
                color: completed ? color : Colors.grey.withValues(alpha: 0.3),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: completed ? null : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
              Icons.inbox,
              size: 80,
              color: Color(0xFF7C3AED),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Applications Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start applying to schemes to track them here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(String filter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withValues(alpha: 0.1),
            ),
            child: const Icon(
              Icons.filter_list_off,
              size: 80,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No $filter Applications',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different filter',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return const Color(0xFF10B981);
      case 'Rejected':
        return const Color(0xFFEF4444);
      case 'Under Review':
        return const Color(0xFFF59E0B);
      case 'Pending':
      default:
        return const Color(0xFF6366F1);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Approved':
        return Icons.check_circle;
      case 'Rejected':
        return Icons.cancel;
      case 'Under Review':
        return Icons.pending;
      case 'Pending':
      default:
        return Icons.schedule;
    }
  }

  String _getRandomStatus(String schemeId) {
    final hash = schemeId.hashCode.abs();
    final statuses = ['Pending', 'Approved', 'Rejected', 'Under Review'];
    return statuses[hash % statuses.length];
  }

  DateTime _getRandomDate() {
    final now = DateTime.now();
    final daysAgo = DateTime.now().millisecondsSinceEpoch.hashCode.abs() % 30;
    return now.subtract(Duration(days: daysAgo));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<Map<String, String>> _getApplicationStages(String status) {
    final baseStages = [
      {
        'title': 'Application Submitted',
        'subtitle': 'Your application has been received',
        'completed': 'true',
      },
      {
        'title': 'Document Verification',
        'subtitle': 'Verifying submitted documents',
        'completed': status != 'Pending' ? 'true' : 'false',
      },
    ];

    if (status == 'Under Review') {
      baseStages.addAll([
        {
          'title': 'Under Review',
          'subtitle': 'Application is being reviewed',
          'completed': 'true',
        },
        {
          'title': 'Decision Pending',
          'subtitle': 'Awaiting final decision',
          'completed': 'false',
        },
      ]);
    } else if (status == 'Approved') {
      baseStages.addAll([
        {
          'title': 'Application Approved',
          'subtitle': 'Your application has been approved',
          'completed': 'true',
        },
        {
          'title': 'Benefit Disbursement',
          'subtitle': 'Benefits will be disbursed soon',
          'completed': 'false',
        },
      ]);
    } else if (status == 'Rejected') {
      baseStages.add({
        'title': 'Application Rejected',
        'subtitle': 'Application did not meet criteria',
        'completed': 'true',
      });
    } else {
      baseStages.add({
        'title': 'Under Review',
        'subtitle': 'Application will be reviewed soon',
        'completed': 'false',
      });
    }

    return baseStages;
  }
}

/// Application Information Model
class ApplicationInfo {
  final Scheme scheme;
  final String status;
  final DateTime appliedDate;
  final DateTime lastUpdated;
  final String applicationId;

  ApplicationInfo({
    required this.scheme,
    required this.status,
    required this.appliedDate,
    required this.lastUpdated,
    required this.applicationId,
  });
}
