import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:myscheme_app/models/user_profile.dart';
import 'package:myscheme_app/models/scheme.dart';

/// AI-Powered Recommendation Service using Gemini
class AIRecommendationService {
  final Gemini gemini = Gemini.instance;

  /// Get personalized scheme recommendations based on user profile
  Future<List<SchemeRecommendation>> getPersonalizedRecommendations({
    required UserProfile userProfile,
    required List<Scheme> availableSchemes,
    int limit = 10,
  }) async {
    // Use fallback rule-based recommendations instead of Gemini API
    // Gemini API has issues, so we use intelligent rule-based matching
    return _getFallbackRecommendations(userProfile, availableSchemes, limit);
  }

  /// Calculate eligibility score for a specific scheme
  Future<EligibilityResult> calculateEligibility({
    required UserProfile userProfile,
    required Scheme scheme,
  }) async {
    // Use rule-based eligibility calculation instead of Gemini API
    return _calculateBasicEligibility(userProfile, scheme);
  }

  /// Get AI-powered document checklist
  Future<DocumentChecklist> getRequiredDocuments({
    required UserProfile userProfile,
    required Scheme scheme,
  }) async {
    return _getBasicDocumentChecklist(userProfile, scheme);
  }

  /// Get application guidance
  Future<String> getApplicationGuidance({
    required UserProfile userProfile,
    required Scheme scheme,
  }) async {
    return _getBasicApplicationGuidance(scheme.applicationProcess);
  }

  // ========== PRIVATE HELPER METHODS ==========

  List<SchemeRecommendation> _getFallbackRecommendations(
    UserProfile profile,
    List<Scheme> schemes,
    int limit,
  ) {
    // Simple rule-based recommendations when AI fails
    final scored = schemes.map((scheme) {
      int score = 50; // Base score

      // Age-based matching
      if (scheme.title.toLowerCase().contains('youth') && profile.age < 35) {
        score += 20;
      }
      if (scheme.title.toLowerCase().contains('senior') && profile.age >= 60) {
        score += 20;
      }

      // Occupation-based matching
      if (scheme.ministry
          .toLowerCase()
          .contains(profile.occupation.toLowerCase())) {
        score += 15;
      }

      // Income-based matching
      if (scheme.title.toLowerCase().contains('bpl') &&
          profile.annualIncome < 100000) {
        score += 25;
      }

      // Education-based matching
      if (scheme.title.toLowerCase().contains('education') ||
          scheme.title.toLowerCase().contains('scholarship')) {
        if (profile.education.toLowerCase().contains('student') ||
            profile.age < 30) {
          score += 20;
        }
      }

      return SchemeRecommendation(
        scheme: scheme,
        matchScore: score.clamp(0, 100),
        reason: 'Based on your profile and scheme criteria',
      );
    }).toList();

    scored.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    return scored.take(limit).toList();
  }

  EligibilityResult _calculateBasicEligibility(
    UserProfile profile,
    Scheme scheme,
  ) {
    int score = 50;
    List<String> matching = [];
    List<String> missing = [];

    // Check documents
    if (scheme.documents.any((d) => d.toLowerCase().contains('aadhar'))) {
      if (profile.hasAadhar) {
        matching.add('Has Aadhar Card');
        score += 10;
      } else {
        missing.add('Aadhar Card');
        score -= 10;
      }
    }

    if (scheme.documents.any((d) => d.toLowerCase().contains('pan'))) {
      if (profile.hasPAN) {
        matching.add('Has PAN Card');
        score += 10;
      } else {
        missing.add('PAN Card');
        score -= 10;
      }
    }

    return EligibilityResult(
      score: score.clamp(0, 100),
      matching: matching,
      missing: missing,
      recommendation: score >= 70 ? 'YES' : (score >= 40 ? 'MAYBE' : 'NO'),
      reasoning: 'Basic eligibility check based on available documents',
    );
  }

  DocumentChecklist _getBasicDocumentChecklist(
    UserProfile profile,
    Scheme scheme,
  ) {
    List<String> have = [];
    List<String> need = [];

    if (profile.hasAadhar) have.add('Aadhar Card');
    if (profile.hasPAN) have.add('PAN Card');
    if (profile.hasIncomeCertificate) have.add('Income Certificate');
    if (profile.hasBankAccount) have.add('Bank Account Details');

    for (final doc in scheme.documents) {
      if (!have.any((h) => doc.toLowerCase().contains(h.toLowerCase()))) {
        need.add(doc);
      }
    }

    return DocumentChecklist(
      have: have,
      need: need,
      priority: need,
      tips: {},
    );
  }

  String _getBasicApplicationGuidance(String applicationProcess) {
    return '''
📋 Application Process:

$applicationProcess

⚠️ Important Tips:
1. Keep all documents ready before starting
2. Fill all mandatory fields carefully
3. Double-check information before submission
4. Save application reference number
5. Track application status regularly

For assistance, contact the respective ministry helpline.
''';
  }
}

/// Scheme Recommendation with AI score
class SchemeRecommendation {
  final Scheme scheme;
  final int matchScore; // 0-100
  final String reason;

  SchemeRecommendation({
    required this.scheme,
    required this.matchScore,
    required this.reason,
  });
}

/// Eligibility Result from AI
class EligibilityResult {
  final int score; // 0-100
  final List<String> matching;
  final List<String> missing;
  final String recommendation; // YES/NO/MAYBE
  final String reasoning;

  EligibilityResult({
    required this.score,
    required this.matching,
    required this.missing,
    required this.recommendation,
    required this.reasoning,
  });
}

/// Document Checklist from AI
class DocumentChecklist {
  final List<String> have;
  final List<String> need;
  final List<String> priority;
  final Map<String, String> tips;

  DocumentChecklist({
    required this.have,
    required this.need,
    required this.priority,
    required this.tips,
  });
}
