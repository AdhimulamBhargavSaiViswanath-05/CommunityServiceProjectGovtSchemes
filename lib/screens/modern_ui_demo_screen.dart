import 'package:flutter/material.dart';
import 'package:myscheme_app/widgets/modern_ui_components.dart';

/// Demo Screen showing Professional UI Components
/// This demonstrates how apps like PhonePe, Google Pay look
class ModernUIDemoScreen extends StatefulWidget {
  const ModernUIDemoScreen({super.key});

  @override
  State<ModernUIDemoScreen> createState() => _ModernUIDemoScreenState();
}

class _ModernUIDemoScreenState extends State<ModernUIDemoScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6366F1).withValues(alpha: 0.1),
              const Color(0xFF8B5CF6).withValues(alpha: 0.1),
              const Color(0xFF06B6D4).withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Modern App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Professional UI',
                    style: TextStyle(
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF6366F1).withValues(alpha: 0.3),
                          const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Stats Cards Section
                    const Text(
                      'Dashboard Stats',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stats Cards Grid
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ModernUIComponents.statsCard(
                          title: 'Total Schemes',
                          value: '45',
                          icon: Icons.grid_view_rounded,
                          color: const Color(0xFF6366F1),
                          subtitle: '+12%',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              ModernUIComponents.modernSnackbar(
                                message: 'Viewing total schemes',
                                isError: false,
                              ),
                            );
                          },
                        ),
                        ModernUIComponents.statsCard(
                          title: 'Applications',
                          value: '12',
                          icon: Icons.description_outlined,
                          color: const Color(0xFF8B5CF6),
                          subtitle: '+5%',
                          onTap: () {},
                        ),
                        ModernUIComponents.statsCard(
                          title: 'Approved',
                          value: '8',
                          icon: Icons.check_circle_outline,
                          color: const Color(0xFF10B981),
                          subtitle: '67%',
                          onTap: () {},
                        ),
                        ModernUIComponents.statsCard(
                          title: 'Pending',
                          value: '4',
                          icon: Icons.access_time,
                          color: const Color(0xFFF59E0B),
                          subtitle: '33%',
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Glass Cards Section
                    const Text(
                      'Modern Glass Cards',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ModernUIComponents.glassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6366F1),
                                      Color(0xFF8B5CF6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Premium Account',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    Text(
                                      'Active since 2024',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '₹50,000',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                  Text(
                                    'Benefits Received',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '98%',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6366F1),
                                    ),
                                  ),
                                  Text(
                                    'Success Rate',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Neumorphic Card
                    ModernUIComponents.neumorphicCard(
                      child: const Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Color(0xFFF59E0B),
                            size: 32,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pro Tip',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Complete your profile to unlock more scheme recommendations',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Buttons Section
                    const Text(
                      'Modern Buttons',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ModernUIComponents.gradientButton(
                      text: 'Primary Action',
                      icon: Icons.rocket_launch,
                      onPressed: () {
                        setState(() => _isLoading = true);
                        final messenger = ScaffoldMessenger.of(context);
                        Future.delayed(const Duration(seconds: 2), () {
                          if (!mounted) return;
                          setState(() => _isLoading = false);
                          messenger.showSnackBar(
                            ModernUIComponents.modernSnackbar(
                              message: 'Action completed successfully!',
                              isError: false,
                              actionLabel: 'VIEW',
                              onAction: () {},
                            ),
                          );
                        });
                      },
                      isLoading: _isLoading,
                    ),

                    const SizedBox(height: 16),

                    ModernUIComponents.gradientButton(
                      text: 'Success Action',
                      icon: Icons.check_circle,
                      colors: const [
                        Color(0xFF10B981),
                        Color(0xFF059669),
                      ],
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          ModernUIComponents.modernSnackbar(
                            message: 'Success! Operation completed.',
                            isError: false,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    ModernUIComponents.gradientButton(
                      text: 'Error Action',
                      icon: Icons.error_outline,
                      colors: const [
                        Color(0xFFEF4444),
                        Color(0xFFDC2626),
                      ],
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          ModernUIComponents.modernSnackbar(
                            message: 'Error! Something went wrong.',
                            isError: true,
                            actionLabel: 'RETRY',
                            onAction: () {},
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Feature List
                    const Text(
                      'Features Used',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildFeatureItem(
                      '✨ Glassmorphism',
                      'Frosted glass effect for modern cards',
                    ),
                    _buildFeatureItem(
                      '🎨 Gradient Backgrounds',
                      'Beautiful color transitions',
                    ),
                    _buildFeatureItem(
                      '💫 Smooth Animations',
                      'Professional micro-interactions',
                    ),
                    _buildFeatureItem(
                      '📱 Haptic Feedback',
                      'Native-like touch responses',
                    ),
                    _buildFeatureItem(
                      '🎯 Neumorphism',
                      'Soft UI design elements',
                    ),

                    const SizedBox(height: 80),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
