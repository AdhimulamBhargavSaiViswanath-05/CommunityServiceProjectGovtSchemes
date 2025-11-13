import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@myscheme.gov.in',
      query: 'subject=Help Request&body=Please describe your issue:',
    );

    if (!await launchUrl(emailUri)) {
      debugPrint('Could not launch email');
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+911800111363');
    if (!await launchUrl(phoneUri)) {
      debugPrint('Could not launch phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Help & Support',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF06B6D4),
                      const Color(0xFF0891B2),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.support_agent_rounded,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About Section
                  _buildSectionCard(
                    context,
                    title: 'About MyScheme',
                    icon: Icons.info_rounded,
                    color: const Color(0xFF6366F1),
                    isDark: isDark,
                    children: [
                      const Text(
                        'MyScheme is a government initiative that helps citizens discover and apply for various welfare schemes.',
                        style: TextStyle(fontSize: 15, height: 1.6),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Version: 1.0.0',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Last Updated: November 2025',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Contact Support
                  _buildSectionCard(
                    context,
                    title: 'Contact Support',
                    icon: Icons.contact_support_rounded,
                    color: const Color(0xFF10B981),
                    isDark: isDark,
                    children: [
                      _buildContactTile(
                        icon: Icons.email_rounded,
                        title: 'Email Support',
                        subtitle: 'support@myscheme.gov.in',
                        onTap: _launchEmail,
                        color: const Color(0xFF10B981),
                      ),
                      const SizedBox(height: 12),
                      _buildContactTile(
                        icon: Icons.phone_rounded,
                        title: 'Helpline',
                        subtitle: '1800-111-363 (Toll Free)',
                        onTap: _launchPhone,
                        color: const Color(0xFF3B82F6),
                      ),
                      const SizedBox(height: 12),
                      _buildContactTile(
                        icon: Icons.language_rounded,
                        title: 'Official Website',
                        subtitle: 'www.myscheme.gov.in',
                        onTap: () => _launchURL('https://www.myscheme.gov.in'),
                        color: const Color(0xFF8B5CF6),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // FAQs
                  _buildSectionCard(
                    context,
                    title: 'Frequently Asked Questions',
                    icon: Icons.quiz_rounded,
                    color: const Color(0xFFF59E0B),
                    isDark: isDark,
                    children: [
                      _buildFAQItem(
                        question: 'How do I check my eligibility?',
                        answer:
                            'Navigate to any scheme and tap "Check Eligibility". Complete your profile for accurate results.',
                        isDark: isDark,
                      ),
                      const Divider(height: 24),
                      _buildFAQItem(
                        question: 'How to apply for a scheme?',
                        answer:
                            'Select a scheme, check eligibility, and tap "Apply Now". You will be redirected to the official application portal.',
                        isDark: isDark,
                      ),
                      const Divider(height: 24),
                      _buildFAQItem(
                        question: 'Is my data secure?',
                        answer:
                            'Yes! Your data is stored securely on your device and only used to match you with relevant schemes.',
                        isDark: isDark,
                      ),
                      const Divider(height: 24),
                      _buildFAQItem(
                        question: 'How often are schemes updated?',
                        answer:
                            'We update our scheme database daily to ensure you get the latest information.',
                        isDark: isDark,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Quick Links
                  _buildSectionCard(
                    context,
                    title: 'Quick Links',
                    icon: Icons.link_rounded,
                    color: const Color(0xFFEF4444),
                    isDark: isDark,
                    children: [
                      _buildLinkButton(
                        context,
                        icon: Icons.policy_rounded,
                        label: 'Privacy Policy',
                        onTap: () =>
                            _launchURL('https://www.myscheme.gov.in/privacy'),
                      ),
                      const SizedBox(height: 12),
                      _buildLinkButton(
                        context,
                        icon: Icons.description_rounded,
                        label: 'Terms & Conditions',
                        onTap: () =>
                            _launchURL('https://www.myscheme.gov.in/terms'),
                      ),
                      const SizedBox(height: 12),
                      _buildLinkButton(
                        context,
                        icon: Icons.feedback_rounded,
                        label: 'Send Feedback',
                        onTap: _launchEmail,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Footer
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.verified_user_rounded,
                            size: 32, color: Color(0xFF10B981)),
                        const SizedBox(height: 12),
                        const Text(
                          'Government of India Initiative',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Making government schemes accessible to all citizens',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDark
            ? Border.all(color: Colors.white.withValues(alpha: 0.1))
            : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.1),
                  color.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: color.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.help_outline,
                color: Color(0xFFF59E0B),
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                question,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 34),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLinkButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: Theme.of(context).colorScheme.primary, size: 20),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.open_in_new, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
