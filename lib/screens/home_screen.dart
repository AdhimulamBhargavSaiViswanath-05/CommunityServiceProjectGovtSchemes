import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:myscheme_app/providers/location_provider.dart';
import 'package:myscheme_app/providers/scheme_provider.dart';
import 'package:myscheme_app/providers/weather_provider.dart';
import 'package:myscheme_app/providers/enhanced_language_provider.dart';
import 'package:myscheme_app/widgets/weather_summary.dart';
import 'package:myscheme_app/widgets/scheme_card.dart';
import 'package:myscheme_app/widgets/search_widget.dart';
import 'package:myscheme_app/widgets/shimmer_loading.dart';
import 'package:myscheme_app/widgets/empty_state_widget.dart';
import 'package:myscheme_app/widgets/modern_ui_components.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:myscheme_app/utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    final schemeProvider = Provider.of<SchemeProvider>(context, listen: false);

    // Always auto-request location permission on app start
    await locationProvider.determinePosition(weatherProvider);

    // Fetch schemes
    await schemeProvider.fetchSchemes();
  }

  @override
  Widget build(BuildContext context) {
    final schemeProvider = Provider.of<SchemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA),
      body: RefreshIndicator(
        onRefresh: () async {
          final locationProvider =
              Provider.of<LocationProvider>(context, listen: false);
          final weatherProvider =
              Provider.of<WeatherProvider>(context, listen: false);
          final schemeProvider =
              Provider.of<SchemeProvider>(context, listen: false);

          await locationProvider.determinePosition(weatherProvider);
          if (!mounted) return;
          await schemeProvider.fetchSchemes();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Modern App Bar
            SliverAppBar(
              expandedHeight: Responsive.appBarHeight(context),
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              const Color(0xFF6366F1).withValues(alpha: 0.2),
                              const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                            ]
                          : [
                              const Color(0xFF6366F1).withValues(alpha: 0.05),
                              const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                            ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        Responsive.horizontalPadding(context),
                        Responsive.verticalPadding(context),
                        Responsive.horizontalPadding(context),
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: Responsive.isVerySmallMobile(context)
                                    ? 30
                                    : 36,
                                height: Responsive.isVerySmallMobile(context)
                                    ? 30
                                    : 36,
                                margin: EdgeInsets.only(
                                    right:
                                        Responsive.spacing(context, mobile: 8)),
                                child: Image.asset(
                                  'assets/jan_yojana_logo.png.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.account_balance,
                                      size:
                                          Responsive.isVerySmallMobile(context)
                                              ? 24
                                              : 28,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Citizen-Centric Awareness Platform',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontSize: Responsive.fontSize(context,
                                            mobile: 16),
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                        letterSpacing:
                                            Responsive.isVerySmallMobile(
                                                    context)
                                                ? 0.2
                                                : 0.5,
                                        height: 1.1,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: Responsive.spacing(context, mobile: 3)),
                          Text(
                            'For Government Schemes',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontSize:
                                      Responsive.fontSize(context, mobile: 12),
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                  height: 1.1,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                              height: Responsive.spacing(context, mobile: 6)),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isVerySmall =
                                  Responsive.isVerySmallMobile(context);
                              final locationPadding = isVerySmall ? 5.0 : 10.0;
                              final iconSize = isVerySmall ? 12.0 : 14.0;
                              final fontSize = isVerySmall ? 10.0 : 13.0;

                              return Row(
                                children: [
                                  Expanded(
                                    flex: isVerySmall ? 6 : 5,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: locationPadding,
                                        vertical: locationPadding * 0.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.white
                                                .withValues(alpha: 0.1)
                                            : Colors.black
                                                .withValues(alpha: 0.05),
                                        borderRadius: BorderRadius.circular(
                                            Responsive.borderRadius(context,
                                                base: 20)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: iconSize,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          SizedBox(width: isVerySmall ? 2 : 4),
                                          Flexible(
                                            child: Consumer<WeatherProvider>(
                                              builder: (context,
                                                  weatherProvider, _) {
                                                final location = weatherProvider
                                                        .weather?.city ??
                                                    'India';
                                                return Text(
                                                  location,
                                                  style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.w500,
                                                    color: isDark
                                                        ? Colors.white70
                                                        : Colors.black54,
                                                    height: 1.2,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: Responsive.spacing(context,
                                          mobile: 4)),
                                  IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(
                                      minWidth: isVerySmall ? 18 : 24,
                                      minHeight: isVerySmall ? 18 : 24,
                                    ),
                                    iconSize: Responsive.iconSize(context,
                                        mobile: 20),
                                    onPressed: () {
                                      showSearch(
                                        context: context,
                                        delegate: SchemeSearchDelegate(
                                          schemes: schemeProvider.schemes,
                                          isDark: isDark,
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                      width: Responsive.spacing(context,
                                          mobile: 2)),
                                  Expanded(
                                    flex: isVerySmall ? 4 : 3,
                                    child: const WeatherSummary(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildRecommendedSchemes(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedSchemes(BuildContext context) {
    final schemeProvider = Provider.of<SchemeProvider>(context);
    final enhancedLanguageProvider =
        Provider.of<EnhancedLanguageProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate statistics
    final totalSchemes = schemeProvider.schemes.length;
    final uniqueCategories = schemeProvider.schemes
        .map((s) => s.ministry)
        .where((m) => m.isNotEmpty)
        .toSet()
        .length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics Dashboard (Compact)
          if (!schemeProvider.isLoading &&
              schemeProvider.schemes.isNotEmpty) ...[
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.apps_rounded,
                    label: 'Total Schemes',
                    value: totalSchemes.toString(),
                    color: const Color(0xFF6366F1),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.category_rounded,
                    label: 'Categories',
                    value: uniqueCategories.toString(),
                    color: const Color(0xFF8B5CF6),
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],

          // Header Row - Modern
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    enhancedLanguageProvider.translate('recommendedSchemes'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Discover schemes for you',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white60 : Colors.black45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              if (schemeProvider.isDemoMode)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.offline_bolt_rounded,
                        color: Colors.orange.shade700,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Demo',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Error Message
          if (schemeProvider.errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        schemeProvider.errorMessage,
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Loading State with Shimmer
          if (schemeProvider.isLoading)
            Column(
              children: List.generate(
                5,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SchemeCardSkeleton(),
                ),
              ),
            )
          // Empty State
          else if (schemeProvider.schemes.isEmpty)
            EmptyStateWidget(
              icon: Icons.inbox_outlined,
              title: enhancedLanguageProvider.translate('noSchemesFound'),
              message: 'Pull down to refresh or try again later',
              actionText: 'Refresh',
              onAction: () async {
                final ctx = context;
                final locationProvider =
                    Provider.of<LocationProvider>(ctx, listen: false);
                final weatherProvider =
                    Provider.of<WeatherProvider>(ctx, listen: false);
                final sp = Provider.of<SchemeProvider>(ctx, listen: false);

                await locationProvider.determinePosition(weatherProvider);
                if (!mounted) return;
                await sp.fetchSchemes();
              },
              color: Theme.of(context).colorScheme.primary,
            )
          // Schemes List
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: schemeProvider.schemes.length > 5
                  ? 5
                  : schemeProvider.schemes.length,
              itemBuilder: (context, index) {
                return SchemeCard(scheme: schemeProvider.schemes[index])
                    .animate()
                    .fadeIn(
                      duration: 400.ms,
                      delay: (100 * index).ms,
                      curve: Curves.easeOut,
                    )
                    .slideX(
                      begin: 0.2,
                      end: 0,
                      duration: 400.ms,
                      delay: (100 * index).ms,
                      curve: Curves.easeOut,
                    );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: ModernUIComponents.statsCard(
        title: label,
        value: value,
        icon: icon,
        color: color,
        onTap: () {
          HapticFeedback.lightImpact();
        },
      ),
    );
  }
}
