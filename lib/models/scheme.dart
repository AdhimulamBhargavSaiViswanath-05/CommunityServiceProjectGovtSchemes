class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      question: json['q'] ?? '',
      answer: json['a'] ?? '',
    );
  }
}

class Reference {
  final String title;
  final String url;

  Reference({required this.title, required this.url});

  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class Scheme {
  final String id;
  final String slug;
  final String title;
  final String shortTitle;
  final String description;
  final String detailedDescription;
  final String benefits;
  final String eligibility;
  final String exclusions;
  final String ministry;
  final String applicationProcess;
  final List<String> documents;
  final List<FAQ> faqs;
  final List<Reference> references;
  final String category;
  final String deadline;
  final String link;
  final String imageUrl;

  Scheme({
    required this.id,
    required this.slug,
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.detailedDescription,
    required this.benefits,
    required this.eligibility,
    required this.exclusions,
    required this.ministry,
    required this.applicationProcess,
    required this.documents,
    required this.faqs,
    required this.references,
    required this.category,
    required this.deadline,
    required this.link,
    this.imageUrl = '',
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    // Parse FAQs
    List<FAQ> faqsList = [];
    if (json['faqs'] != null && json['faqs'] is List) {
      faqsList =
          (json['faqs'] as List).map((faq) => FAQ.fromJson(faq)).toList();
    }

    // Parse References
    List<Reference> refsList = [];
    if (json['references'] != null && json['references'] is List) {
      refsList = (json['references'] as List)
          .map((ref) => Reference.fromJson(ref))
          .toList();
    }

    // Parse Documents
    List<String> docsList = [];
    if (json['documents'] != null && json['documents'] is List) {
      docsList = List<String>.from(json['documents']);
    }

    return Scheme(
      id: json['id'] ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? 'No Title',
      shortTitle: json['shortTitle'] ?? '',
      description: json['description'] ?? 'No Description',
      detailedDescription: json['detailedDescription'] ?? '',
      benefits: json['benefits'] ?? '',
      eligibility: json['eligibility'] ?? '',
      exclusions: json['exclusions'] ?? '',
      ministry: json['ministry'] ?? 'Unknown Ministry',
      applicationProcess: json['applicationProcess'] ?? '',
      documents: docsList,
      faqs: faqsList,
      references: refsList,
      category: json['category'] ?? 'Uncategorized',
      deadline: json['deadline'] ?? 'No Deadline',
      link: json['link'] ?? '',
      imageUrl: json['image'] ?? json['imageUrl'] ?? '',
    );
  }
}
