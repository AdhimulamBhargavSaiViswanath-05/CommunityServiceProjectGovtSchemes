import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:myscheme_app/providers/scheme_provider.dart';
import 'package:myscheme_app/providers/enhanced_language_provider.dart';
import 'package:myscheme_app/widgets/scheme_card.dart';
import 'package:myscheme_app/widgets/empty_state_widget.dart';
import 'package:myscheme_app/models/scheme.dart';

class SchemeListScreen extends StatefulWidget {
  const SchemeListScreen({super.key});

  @override
  State<SchemeListScreen> createState() => _SchemeListScreenState();
}

class _SchemeListScreenState extends State<SchemeListScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Scheme> _filterSchemes(List<Scheme> schemes) {
    return schemes.where((scheme) {
      final matchesSearch = scheme.title
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          scheme.description.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == 'All' || scheme.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  Set<String> _getCategories(List<Scheme> schemes) {
    return schemes.map((s) => s.category).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final schemeProvider = Provider.of<SchemeProvider>(context);
    final enhancedLanguageProvider =
        Provider.of<EnhancedLanguageProvider>(context);
    final filteredSchemes = _filterSchemes(schemeProvider.schemes);
    final categories = _getCategories(schemeProvider.schemes);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(enhancedLanguageProvider.translate('all_schemes')),
        actions: [
          // Filter button
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(
                Icons.filter_list_rounded,
                color: isDark ? Colors.white : Colors.black87,
              ),
              onPressed: () {
                _showFilterBottomSheet(context, categories, isDark);
              },
              tooltip: 'Filter Schemes',
              style: IconButton.styleFrom(
                backgroundColor: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          if (schemeProvider.isDemoMode)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Tooltip(
                message: enhancedLanguageProvider.translate('demo_mode'),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                ),
              ),
            ),
        ],
      ),
      body: schemeProvider.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.2),
                          Theme.of(context)
                              .colorScheme
                              .secondary
                              .withValues(alpha: 0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .scale(
                        duration: 1000.ms,
                        begin: const Offset(1.0, 1.0),
                        end: const Offset(1.2, 1.2),
                        curve: Curves.easeInOut,
                      )
                      .then()
                      .scale(
                        duration: 1000.ms,
                        begin: const Offset(1.2, 1.2),
                        end: const Offset(1.0, 1.0),
                        curve: Curves.easeInOut,
                      ),
                  const SizedBox(height: 24),
                  Text(
                    enhancedLanguageProvider.translate('loading'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .fadeIn(duration: 800.ms)
                      .then()
                      .fadeOut(duration: 800.ms),
                ],
              ),
            )
          : Column(
              children: [
                if (schemeProvider.isDemoMode)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.orange.shade100,
                    child: Text(
                      schemeProvider.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF18181B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: enhancedLanguageProvider.translate('search'),
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color:
                                      isDark ? Colors.white60 : Colors.black54,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),
                // Category Filter - Hidden, use filter button instead
                // Results count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Text(
                        '${filteredSchemes.length} ${enhancedLanguageProvider.translate('schemes_found')}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      if (_selectedCategory != 'All') ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            _selectedCategory,
                            style: const TextStyle(fontSize: 12),
                          ),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedCategory = 'All';
                            });
                          },
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Scheme List
                Expanded(
                  child: filteredSchemes.isEmpty
                      ? EmptyStateWidget(
                          icon: Icons.search_off,
                          title: enhancedLanguageProvider
                              .translate('no_schemes_found'),
                          message: enhancedLanguageProvider
                              .translate('try_adjusting'),
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      : ListView.builder(
                          itemCount: filteredSchemes.length,
                          itemBuilder: (context, index) {
                            final scheme = filteredSchemes[index];
                            return SchemeCard(scheme: scheme)
                                .animate()
                                .fadeIn(
                                  duration: 300.ms,
                                  delay: (50 * index).ms,
                                  curve: Curves.easeOut,
                                )
                                .slideX(
                                  begin: 0.1,
                                  end: 0,
                                  duration: 300.ms,
                                  delay: (50 * index).ms,
                                  curve: Curves.easeOut,
                                );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void _showFilterBottomSheet(
      BuildContext context, Set<String> categories, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF18181B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.filter_list_rounded,
                      color: Color(0xFF6366F1),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Filter by Category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterChip('All', isDark),
                  ...categories
                      .map((category) => _buildFilterChip(category, isDark)),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String category, bool isDark) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      label: Text(category),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = category;
        });
        Navigator.pop(context);
      },
      backgroundColor:
          isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
      selectedColor: const Color(0xFF6366F1).withValues(alpha: 0.15),
      checkmarkColor: const Color(0xFF6366F1),
      labelStyle: TextStyle(
        color: isSelected
            ? const Color(0xFF6366F1)
            : (isDark ? Colors.white70 : Colors.black87),
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      side: BorderSide(
        color: isSelected
            ? const Color(0xFF6366F1)
            : (isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.shade300),
        width: isSelected ? 1.5 : 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }
}
