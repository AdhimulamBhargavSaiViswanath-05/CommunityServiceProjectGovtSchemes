/// Enhanced User Profile Model with AI-ready fields
class UserProfile {
  final String id;
  final String name;
  final String photoUrl;
  final int age;
  final String gender;
  final String occupation;
  final String education;
  final double annualIncome;
  final String state;
  final String district;
  final String category; // General, OBC, SC, ST, etc.
  final bool hasAadhar;
  final bool hasPAN;
  final bool hasIncomeCertificate;
  final bool hasBankAccount;
  final List<String> documents;
  final List<String> appliedSchemes;
  final List<String> savedSchemes;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    this.photoUrl = '',
    required this.age,
    required this.gender,
    required this.occupation,
    required this.education,
    required this.annualIncome,
    required this.state,
    required this.district,
    required this.category,
    this.hasAadhar = false,
    this.hasPAN = false,
    this.hasIncomeCertificate = false,
    this.hasBankAccount = false,
    this.documents = const [],
    this.appliedSchemes = const [],
    this.savedSchemes = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Calculate profile completion percentage
  int get completionPercentage {
    int total = 14;
    int completed = 0;

    if (name.isNotEmpty) completed++;
    if (age > 0) completed++;
    if (gender.isNotEmpty) completed++;
    if (occupation.isNotEmpty) completed++;
    if (education.isNotEmpty) completed++;
    if (annualIncome > 0) completed++;
    if (state.isNotEmpty) completed++;
    if (district.isNotEmpty) completed++;
    if (category.isNotEmpty) completed++;
    if (hasAadhar) completed++;
    if (hasPAN) completed++;
    if (hasIncomeCertificate) completed++;
    if (hasBankAccount) completed++;
    if (documents.isNotEmpty) completed++;

    return ((completed / total) * 100).round();
  }

  /// Get profile readiness for AI recommendations
  bool get isReadyForRecommendations {
    return name.isNotEmpty &&
        age > 0 &&
        occupation.isNotEmpty &&
        annualIncome > 0 &&
        state.isNotEmpty;
  }

  /// Convert to JSON for AI processing
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'age': age,
      'gender': gender,
      'occupation': occupation,
      'education': education,
      'annualIncome': annualIncome,
      'state': state,
      'district': district,
      'category': category,
      'hasAadhar': hasAadhar,
      'hasPAN': hasPAN,
      'hasIncomeCertificate': hasIncomeCertificate,
      'hasBankAccount': hasBankAccount,
      'documents': documents,
      'appliedSchemes': appliedSchemes,
      'savedSchemes': savedSchemes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      occupation: json['occupation'] ?? '',
      education: json['education'] ?? '',
      annualIncome: (json['annualIncome'] ?? 0).toDouble(),
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      category: json['category'] ?? '',
      hasAadhar: json['hasAadhar'] ?? false,
      hasPAN: json['hasPAN'] ?? false,
      hasIncomeCertificate: json['hasIncomeCertificate'] ?? false,
      hasBankAccount: json['hasBankAccount'] ?? false,
      documents: List<String>.from(json['documents'] ?? []),
      appliedSchemes: List<String>.from(json['appliedSchemes'] ?? []),
      savedSchemes: List<String>.from(json['savedSchemes'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Create empty profile
  factory UserProfile.empty() {
    return UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '',
      photoUrl: '',
      age: 0,
      gender: '',
      occupation: '',
      education: '',
      annualIncome: 0,
      state: '',
      district: '',
      category: '',
    );
  }

  /// Copy with method for updates
  UserProfile copyWith({
    String? id,
    String? name,
    String? photoUrl,
    int? age,
    String? gender,
    String? occupation,
    String? education,
    double? annualIncome,
    String? state,
    String? district,
    String? category,
    bool? hasAadhar,
    bool? hasPAN,
    bool? hasIncomeCertificate,
    bool? hasBankAccount,
    List<String>? documents,
    List<String>? appliedSchemes,
    List<String>? savedSchemes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      annualIncome: annualIncome ?? this.annualIncome,
      state: state ?? this.state,
      district: district ?? this.district,
      category: category ?? this.category,
      hasAadhar: hasAadhar ?? this.hasAadhar,
      hasPAN: hasPAN ?? this.hasPAN,
      hasIncomeCertificate: hasIncomeCertificate ?? this.hasIncomeCertificate,
      hasBankAccount: hasBankAccount ?? this.hasBankAccount,
      documents: documents ?? this.documents,
      appliedSchemes: appliedSchemes ?? this.appliedSchemes,
      savedSchemes: savedSchemes ?? this.savedSchemes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Generate AI prompt for recommendations
  String toAIPrompt() {
    return '''
User Profile:
- Name: $name
- Age: $age years
- Gender: $gender
- Occupation: $occupation
- Education: $education
- Annual Income: ₹${annualIncome.toStringAsFixed(0)}
- Location: $district, $state
- Category: $category
- Documents: ${hasAadhar ? 'Aadhar ✓' : ''} ${hasPAN ? 'PAN ✓' : ''} ${hasIncomeCertificate ? 'Income Certificate ✓' : ''} ${hasBankAccount ? 'Bank Account ✓' : ''}
''';
  }
}
