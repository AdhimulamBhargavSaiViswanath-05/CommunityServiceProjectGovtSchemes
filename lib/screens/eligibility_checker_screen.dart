import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/scheme.dart';
import '../providers/user_profile_provider.dart';
import '../providers/scheme_provider.dart';
import '../services/ai_recommendation_service.dart';

class EligibilityCheckerScreen extends StatefulWidget {
  final Scheme? initialScheme;

  const EligibilityCheckerScreen({
    super.key,
    this.initialScheme,
  });

  @override
  State<EligibilityCheckerScreen> createState() =>
      _EligibilityCheckerScreenState();
}

class _EligibilityCheckerScreenState extends State<EligibilityCheckerScreen>
    with SingleTickerProviderStateMixin {
  final AIRecommendationService _aiService = AIRecommendationService();
  Scheme? _selectedScheme;
  EligibilityResult? _result;
  bool _isLoading = false;
  String? _error;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _selectedScheme = widget.initialScheme;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    if (_selectedScheme != null) {
      _checkEligibility();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkEligibility() async {
    if (_selectedScheme == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    _animationController.reset();

    try {
      final profileProvider =
          Provider.of<UserProfileProvider>(context, listen: false);
      final profile = profileProvider.profile;

      // Check if profile is complete enough
      if (!profile.isReadyForRecommendations) {
        setState(() {
          _error = 'Please complete your profile first';
          _isLoading = false;
        });
        return;
      }

      // Get AI eligibility result
      final result = await _aiService.calculateEligibility(
        userProfile: profile,
        scheme: _selectedScheme!,
      );

      setState(() {
        _result = result;
        _isLoading = false;
      });

      // Start animation
      _animationController.forward();
    } catch (e) {
      setState(() {
        _error = 'Failed to check eligibility: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSchemeSelector(),
                if (_isLoading)
                  _buildLoadingState()
                else if (_error != null)
                  _buildErrorState()
                else if (_result != null)
                  _buildEligibilityResult(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Eligibility Checker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7C3AED), // Purple
                Color(0xFF6366F1), // Indigo
                Color(0xFF3B82F6), // Blue
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSchemeSelector() {
    final schemeProvider = Provider.of<SchemeProvider>(context);
    final schemes = schemeProvider.schemes;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Select a Scheme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Scheme>(
            initialValue: _selectedScheme,
            decoration: InputDecoration(
              hintText: 'Choose a scheme to check eligibility',
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF7C3AED), width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            items: schemes.take(20).map((scheme) {
              return DropdownMenuItem<Scheme>(
                value: scheme,
                child: Text(
                  scheme.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }).toList(),
            onChanged: (scheme) {
              setState(() {
                _selectedScheme = scheme;
              });
              _checkEligibility();
            },
            isExpanded: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 8,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF7C3AED).withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF7C3AED),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Analyzing Eligibility...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI is checking your profile against scheme requirements',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 24),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unknown error',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _checkEligibility,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEligibilityResult() {
    if (_result == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Score Ring
        _buildScoreSection(),
        const SizedBox(height: 16),
        // Recommendation Badge
        _buildRecommendationBadge(),
        const SizedBox(height: 24),
        // AI Reasoning
        _buildReasoningCard(),
        const SizedBox(height: 16),
        // Matching Criteria
        _buildMatchingCriteria(),
        const SizedBox(height: 16),
        // Missing Requirements
        _buildMissingRequirements(),
        const SizedBox(height: 24),
        // Action Button
        _buildActionButton(),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildScoreSection() {
    final score = _result!.score;

    // Determine color based on score
    Color ringColor;
    Color backgroundColor;
    if (score >= 80) {
      ringColor = Colors.green[600]!;
      backgroundColor = Colors.green[50]!;
    } else if (score >= 60) {
      ringColor = Colors.blue[600]!;
      backgroundColor = Colors.blue[50]!;
    } else if (score >= 40) {
      ringColor = Colors.orange[600]!;
      backgroundColor = Colors.orange[50]!;
    } else {
      ringColor = Colors.red[600]!;
      backgroundColor = Colors.red[50]!;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ringColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Eligibility Score',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: score / 100),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ringColor.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        width: 160,
                        height: 160,
                        child: CircularProgressIndicator(
                          value: value,
                          strokeWidth: 12,
                          backgroundColor: ringColor.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(ringColor),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(value * 100).round()}',
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: ringColor,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'out of 100',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }

  Widget _buildRecommendationBadge() {
    final recommendation = _result!.recommendation.toUpperCase();
    Color badgeColor;
    IconData badgeIcon;
    String badgeText;

    switch (recommendation) {
      case 'YES':
        badgeColor = Colors.green[600]!;
        badgeIcon = Icons.check_circle;
        badgeText = 'You are Eligible!';
        break;
      case 'NO':
        badgeColor = Colors.red[600]!;
        badgeIcon = Icons.cancel;
        badgeText = 'Not Eligible';
        break;
      case 'MAYBE':
      default:
        badgeColor = Colors.orange[600]!;
        badgeIcon = Icons.help;
        badgeText = 'Partially Eligible';
        break;
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (_animationController.value * 0.2),
          child: Opacity(
            opacity: _animationController.value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: badgeColor.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              badgeIcon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              badgeText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasoningCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF7C3AED),
            Color(0xFF6366F1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'AI Analysis',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _result!.reasoning,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchingCriteria() {
    if (_result!.matching.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[200]!, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'You Meet These Criteria',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._result!.matching.map((criterion) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green[600],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      criterion,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMissingRequirements() {
    if (_result!.missing.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green[200]!, width: 2),
        ),
        child: Row(
          children: [
            Icon(
              Icons.celebration,
              color: Colors.green[600],
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Great! You meet all requirements!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.cancel,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Missing Requirements',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._result!.missing.map((requirement) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.red[600],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      requirement,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    final recommendation = _result!.recommendation.toUpperCase();
    String buttonText;
    Color buttonColor;
    IconData buttonIcon;

    if (recommendation == 'YES') {
      buttonText = 'View Application Guide';
      buttonColor = Colors.green[600]!;
      buttonIcon = Icons.article;
    } else if (recommendation == 'MAYBE') {
      buttonText = 'See How to Improve';
      buttonColor = Colors.orange[600]!;
      buttonIcon = Icons.lightbulb;
    } else {
      buttonText = 'Find Similar Schemes';
      buttonColor = Colors.blue[600]!;
      buttonIcon = Icons.search;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Application Guide coming soon!'),
              backgroundColor: Color(0xFF7C3AED),
            ),
          );
        },
        icon: Icon(buttonIcon, size: 24),
        label: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: buttonColor.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
