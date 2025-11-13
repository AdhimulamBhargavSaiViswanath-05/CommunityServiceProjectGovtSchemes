import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:myscheme_app/models/scheme.dart';
import 'package:myscheme_app/services/tts_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SchemeDetailScreen extends StatefulWidget {
  final Scheme scheme;

  const SchemeDetailScreen({super.key, required this.scheme});

  @override
  State<SchemeDetailScreen> createState() => _SchemeDetailScreenState();
}

class _SchemeDetailScreenState extends State<SchemeDetailScreen>
    with SingleTickerProviderStateMixin {
  final TtsService _ttsService = TtsService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No URL available')),
      );
      return;
    }

    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Gradient App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.scheme.shortTitle.isNotEmpty
                    ? widget.scheme.shortTitle
                    : widget.scheme.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            const Color(0xFF6B21A8), // Deep Purple
                            const Color(0xFF7C3AED), // Violet
                            const Color(0xFF2563EB), // Blue
                          ]
                        : [
                            const Color(0xFF8B5CF6), // Purple
                            const Color(0xFF6366F1), // Indigo
                            const Color(0xFF3B82F6), // Blue
                          ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () {
                  _ttsService.speak(widget.scheme.description);
                },
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Ministry Badge
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              const Color(0xFF1E293B),
                              const Color(0xFF334155),
                            ]
                          : [
                              Colors.white,
                              const Color(0xFFF1F5F9),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [
                                    const Color(0xFF7C3AED),
                                    const Color(0xFF6366F1),
                                  ]
                                : [
                                    const Color(0xFF8B5CF6),
                                    const Color(0xFF6366F1),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.account_balance,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ministry',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.scheme.ministry,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Description Card
                _buildGradientCard(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDark
                                    ? [
                                        const Color(0xFFEC4899),
                                        const Color(0xFFEF4444),
                                      ]
                                    : [
                                        const Color(0xFFF472B6),
                                        const Color(0xFFFB7185),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.description,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.scheme.description,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Tabs
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              const Color(0xFF1E293B),
                              const Color(0xFF334155),
                            ]
                          : [
                              Colors.white,
                              const Color(0xFFF8FAFC),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                const Color(0xFF6B21A8),
                                const Color(0xFF7C3AED),
                              ]
                            : [
                                const Color(0xFF8B5CF6),
                                const Color(0xFF6366F1),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor:
                        colorScheme.onSurface.withValues(alpha: 0.6),
                    tabs: const [
                      Tab(text: 'Benefits'),
                      Tab(text: 'Eligibility'),
                      Tab(text: 'How to Apply'),
                      Tab(text: 'Documents'),
                      Tab(text: 'FAQs'),
                      Tab(text: 'References'),
                    ],
                  ),
                ),

                // Tab Content
                SizedBox(
                  height: 600,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBenefitsTab(isDark, colorScheme),
                      _buildEligibilityTab(isDark, colorScheme),
                      _buildApplicationTab(isDark, colorScheme),
                      _buildDocumentsTab(isDark, colorScheme),
                      _buildFAQsTab(isDark, colorScheme),
                      _buildReferencesTab(isDark, colorScheme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientCard({
    required bool isDark,
    required Widget child,
    EdgeInsets? margin,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1E293B),
                  const Color(0xFF334155),
                ]
              : [
                  Colors.white,
                  const Color(0xFFF8FAFC),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildBenefitsTab(bool isDark, ColorScheme colorScheme) {
    if (widget.scheme.benefits.isEmpty) {
      return _buildEmptyState(isDark, 'No benefits information available');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildGradientCard(
        isDark: isDark,
        margin: EdgeInsets.zero,
        child: MarkdownBody(
          data: widget.scheme.benefits,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            h1: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            h2: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            listBullet: TextStyle(
              color: colorScheme.primary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEligibilityTab(bool isDark, ColorScheme colorScheme) {
    if (widget.scheme.eligibility.isEmpty) {
      return _buildEmptyState(isDark, 'No eligibility information available');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildGradientCard(
        isDark: isDark,
        margin: EdgeInsets.zero,
        child: MarkdownBody(
          data: widget.scheme.eligibility,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            listBullet: TextStyle(
              color: colorScheme.primary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationTab(bool isDark, ColorScheme colorScheme) {
    if (widget.scheme.applicationProcess.isEmpty) {
      return _buildEmptyState(isDark, 'No application process information');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildGradientCard(
        isDark: isDark,
        margin: EdgeInsets.zero,
        child: MarkdownBody(
          data: widget.scheme.applicationProcess,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            listBullet: TextStyle(
              color: colorScheme.primary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsTab(bool isDark, ColorScheme colorScheme) {
    if (widget.scheme.documents.isEmpty) {
      return _buildEmptyState(isDark, 'No documents information available');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.scheme.documents.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color(0xFF1E293B),
                      const Color(0xFF334155),
                    ]
                  : [
                      Colors.white,
                      const Color(0xFFF8FAFC),
                    ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF10B981),
                          const Color(0xFF059669),
                        ]
                      : [
                          const Color(0xFF34D399),
                          const Color(0xFF10B981),
                        ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.insert_drive_file,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(
              widget.scheme.documents[index],
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFAQsTab(bool isDark, ColorScheme colorScheme) {
    if (widget.scheme.faqs.isEmpty) {
      return _buildEmptyState(isDark, 'No FAQs available');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.scheme.faqs.length,
      itemBuilder: (context, index) {
        final faq = widget.scheme.faqs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color(0xFF1E293B),
                      const Color(0xFF334155),
                    ]
                  : [
                      Colors.white,
                      const Color(0xFFF8FAFC),
                    ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFFF59E0B),
                          const Color(0xFFD97706),
                        ]
                      : [
                          const Color(0xFFFBBF24),
                          const Color(0xFFF59E0B),
                        ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.help_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(
              faq.question,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  faq.answer,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReferencesTab(bool isDark, ColorScheme colorScheme) {
    if (widget.scheme.references.isEmpty) {
      return _buildEmptyState(isDark, 'No references available');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.scheme.references.length,
      itemBuilder: (context, index) {
        final ref = widget.scheme.references[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color(0xFF1E293B),
                      const Color(0xFF334155),
                    ]
                  : [
                      Colors.white,
                      const Color(0xFFF8FAFC),
                    ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF3B82F6),
                          const Color(0xFF2563EB),
                        ]
                      : [
                          const Color(0xFF60A5FA),
                          const Color(0xFF3B82F6),
                        ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.link,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(
              ref.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            trailing: const Icon(Icons.open_in_new, size: 20),
            onTap: () => _launchUrl(ref.url),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        const Color(0xFF1E293B),
                        const Color(0xFF334155),
                      ]
                    : [
                        const Color(0xFFF1F5F9),
                        const Color(0xFFE2E8F0),
                      ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline,
              size: 48,
              color: isDark ? Colors.white54 : Colors.black38,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
