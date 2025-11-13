import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:myscheme_app/l10n/app_localizations.dart';
import 'package:myscheme_app/providers/weather_provider.dart';
import 'package:myscheme_app/screens/home_screen.dart';
import 'package:myscheme_app/providers/scheme_provider.dart';
import 'package:myscheme_app/providers/location_provider.dart';
import 'package:myscheme_app/screens/scheme_list_screen.dart';
import 'package:myscheme_app/screens/profile_screen_new.dart';
import 'package:myscheme_app/screens/chat_screen_new.dart';
import 'package:myscheme_app/providers/chat_provider.dart';
import 'package:myscheme_app/screens/splash_screen.dart';
import 'package:myscheme_app/providers/language_provider.dart';
import 'package:myscheme_app/providers/enhanced_language_provider.dart';
import 'package:myscheme_app/providers/user_profile_provider.dart';
import 'package:myscheme_app/providers/theme_provider.dart';
import 'package:myscheme_app/utils/responsive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {
    // If .env is missing in some environments (CI, test), continue without it
  }

  // Initialize Gemini AI with environment variable
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  if (apiKey.isNotEmpty) {
    Gemini.init(apiKey: apiKey);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SchemeProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(
            create: (_) => LanguageProvider()..loadLanguage()),
        ChangeNotifierProvider(
            create: (_) => EnhancedLanguageProvider()..loadLanguage()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child:
          Consumer3<LanguageProvider, EnhancedLanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, enhancedLanguageProvider,
            themeProvider, child) {
          return MaterialApp(
            key: ValueKey(
                '${languageProvider.currentLanguage}_${enhancedLanguageProvider.currentLanguage}'),
            title: 'Jan Yojana Jaankari',

            // Flutter Localization Configuration
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('hi'), // Hindi
              Locale('te'), // Telugu
              Locale('bn'), // Bengali
              Locale('mr'), // Marathi
              Locale('ta'), // Tamil
            ],
            locale: Locale(enhancedLanguageProvider.currentLanguage),

            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(nextScreen: MainScreen()),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1), // Modern indigo
        brightness: Brightness.light,
        primary: const Color(0xFF6366F1),
        secondary: const Color(0xFF8B5CF6),
        tertiary: const Color(0xFF06B6D4),
        surface: const Color(0xFFFAFAFA),
      ),
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.6,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF6366F1),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF6366F1),
          side: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF6366F1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          letterSpacing: -0.5,
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      dividerColor: Colors.grey.shade200,
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1),
        brightness: Brightness.dark,
        primary: const Color(0xFF6366F1),
        secondary: const Color(0xFF8B5CF6),
        tertiary: const Color(0xFF06B6D4),
        surface: const Color(0xFF18181B),
      ),
      scaffoldBackgroundColor: const Color(0xFF09090B),
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme:
          GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.6,
          color: Colors.white70,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF18181B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
      ),
      dividerColor: Colors.white.withValues(alpha: 0.1),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final iconList = <IconData>[
    Icons.home_rounded,
    Icons.grid_view_rounded,
    Icons.chat_bubble_rounded,
    Icons.person_rounded,
  ];

  final List<String> _titles = ['Home', 'Schemes', 'Chat Assistant', 'Profile'];

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SchemeListScreen(),
    ChatScreen(),
    ProfileScreenNew(),
  ];

  void _onItemTapped(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBody: true,
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return RotationTransition(
                          turns: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        key: ValueKey(isDark),
                        color: isDark ? Colors.amber : const Color(0xFF6366F1),
                        size: 24,
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      themeProvider.toggleTheme();
                    },
                    tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                    style: IconButton.styleFrom(
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : const Color(0xFF6366F1).withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,
      body: Center(
        child: _widgetOptions
            .elementAt(_selectedIndex)
            .animate()
            .fadeIn(duration: 300.ms, curve: Curves.easeOut)
            .slideY(
                begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOut),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF000000), // Pure Black
                    Color(0xFF1a1a1a), // Dark Gray
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFFFFF), // Pure White
                    Color(0xFFF5F5F5), // Light Gray
                  ],
                ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.5)
                  : Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: Responsive.isVerySmallMobile(context) ? 68 : 72,
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isVerySmallMobile(context) ? 4 : 6,
              vertical: Responsive.isVerySmallMobile(context) ? 3 : 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  icon: iconList[0],
                  label: _titles[0],
                  index: 0,
                  isActive: _selectedIndex == 0,
                  isDark: isDark,
                ),
                _buildNavItem(
                  context,
                  icon: iconList[1],
                  label: _titles[1],
                  index: 1,
                  isActive: _selectedIndex == 1,
                  isDark: isDark,
                ),
                _buildNavItem(
                  context,
                  icon: iconList[2],
                  label: _titles[2],
                  index: 2,
                  isActive: _selectedIndex == 2,
                  isDark: isDark,
                ),
                _buildNavItem(
                  context,
                  icon: iconList[3],
                  label: _titles[3],
                  index: 3,
                  isActive: _selectedIndex == 3,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
    required bool isDark,
  }) {
    // Colors based on theme mode
    final activeColor = isDark ? Colors.white : Colors.black87;
    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : Colors.black.withValues(alpha: 0.4);

    final color = isActive ? activeColor : inactiveColor;

    // Use Responsive utility for consistent sizing
    final isVerySmall = Responsive.isVerySmallMobile(context);
    final iconSize = Responsive.iconSize(context, mobile: 24);
    final fontSize = isVerySmall ? 8.5 : 11.0;
    final basePadding = isVerySmall ? 3.0 : 6.0;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius:
            BorderRadius.circular(Responsive.borderRadius(context, base: 16)),
        splashColor: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.black.withValues(alpha: 0.05),
        highlightColor: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.02),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: isVerySmall ? 4 : 6, horizontal: isVerySmall ? 1 : 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(isActive
                    ? basePadding + (isVerySmall ? 1 : 2)
                    : basePadding),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? (isDark
                          ? Colors.white.withValues(alpha: 0.15)
                          : Colors.black.withValues(alpha: 0.08))
                      : Colors.transparent,
                ),
                child: Icon(
                  icon,
                  size: iconSize,
                  color: color,
                ),
              ),
              SizedBox(height: isVerySmall ? 2 : 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: fontSize,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
