import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:myscheme_app/providers/user_profile_provider.dart';
import 'package:myscheme_app/widgets/modern_ui_components.dart';

// Dark text color for high contrast
const _darkTextColor = Color(0xFF000000); // Pure black for maximum contrast
const _labelTextColor = Color(0xFF4B5563); // Dark grey for labels
const _hintTextColor = Color(0xFF9CA3AF); // Medium grey for hints

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _occupationController = TextEditingController();
  final _educationController = TextEditingController();
  final _incomeController = TextEditingController();

  String _selectedGender = '';
  String _selectedCategory = '';
  String _selectedState = '';
  String _selectedDistrict = '';

  bool _hasAadhar = false;
  bool _hasPAN = false;
  bool _hasIncomeCertificate = false;
  bool _hasBankAccount = false;

  bool _isLoading = false;
  bool _isSaving = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _categories = ['General', 'OBC', 'SC', 'ST', 'EWS'];

  // Indian states
  final Map<String, List<String>> _statesAndDistricts = {
    'Andhra Pradesh': [
      'Visakhapatnam',
      'Vijayawada',
      'Guntur',
      'Nellore',
      'Kurnool'
    ],
    'Karnataka': ['Bengaluru', 'Mysuru', 'Mangaluru', 'Hubballi', 'Belagavi'],
    'Kerala': [
      'Thiruvananthapuram',
      'Kochi',
      'Kozhikode',
      'Thrissur',
      'Kollam'
    ],
    'Tamil Nadu': [
      'Chennai',
      'Coimbatore',
      'Madurai',
      'Tiruchirappalli',
      'Salem'
    ],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Aurangabad'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Bhavnagar'],
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Udaipur', 'Kota', 'Ajmer'],
    'Delhi': [
      'Central Delhi',
      'North Delhi',
      'South Delhi',
      'East Delhi',
      'West Delhi'
    ],
    'West Bengal': ['Kolkata', 'Howrah', 'Durgapur', 'Siliguri', 'Asansol'],
    'Telangana': [
      'Hyderabad',
      'Warangal',
      'Nizamabad',
      'Khammam',
      'Karimnagar'
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    _educationController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    final profile = provider.profile;

    _nameController.text = profile.name;
    _ageController.text = profile.age == 0 ? '' : profile.age.toString();
    _occupationController.text = profile.occupation;
    _educationController.text = profile.education;
    _incomeController.text = profile.annualIncome == 0
        ? ''
        : profile.annualIncome.toStringAsFixed(0);

    setState(() {
      _selectedGender = profile.gender;
      _selectedCategory = profile.category;
      _selectedState = profile.state;
      _selectedDistrict = profile.district;
      _hasAadhar = profile.hasAadhar;
      _hasPAN = profile.hasPAN;
      _hasIncomeCertificate = profile.hasIncomeCertificate;
      _hasBankAccount = profile.hasBankAccount;
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final provider = Provider.of<UserProfileProvider>(context, listen: false);

      // Update basic info
      await provider.updateBasicInfo(
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        gender: _selectedGender,
      );

      // Update professional info
      await provider.updateProfessionalInfo(
        occupation: _occupationController.text.trim(),
        education: _educationController.text.trim(),
        annualIncome: double.parse(_incomeController.text.trim()),
      );

      // Update location
      await provider.updateLocation(
        state: _selectedState,
        district: _selectedDistrict,
      );

      // Update category
      await provider.updateCategory(_selectedCategory);

      // Update documents
      await provider.updateDocuments(
        hasAadhar: _hasAadhar,
        hasPAN: _hasPAN,
        hasIncomeCertificate: _hasIncomeCertificate,
        hasBankAccount: _hasBankAccount,
      );

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Profile saved successfully!'),
            ],
          ),
          backgroundColor: Color(0xFF10B981),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF09090B) : Colors.white,
        appBar: AppBar(title: const Text('Edit Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF09090B) : const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6366F1), // Indigo - softer primary
                Color(0xFF8B5CF6), // Purple - elegant secondary
              ],
            ),
          ),
        ),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          else
            TextButton.icon(
              onPressed: _saveProfile,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'Save',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Progress Indicator
            _buildProgressIndicator(),
            const SizedBox(height: 24),

            // Personal Information Section
            _buildSectionHeader('Personal Information', Icons.person_rounded),
            const SizedBox(height: 16),
            _buildNameField(),
            const SizedBox(height: 16),
            _buildAgeField(),
            const SizedBox(height: 16),
            _buildGenderDropdown(),
            const SizedBox(height: 16),
            _buildCategoryDropdown(),
            const SizedBox(height: 32),

            // Professional Details Section
            _buildSectionHeader('Professional Details', Icons.work_rounded),
            const SizedBox(height: 16),
            _buildOccupationField(),
            const SizedBox(height: 16),
            _buildEducationField(),
            const SizedBox(height: 16),
            _buildIncomeField(),
            const SizedBox(height: 32),

            // Location Section
            _buildSectionHeader('Location', Icons.location_on_rounded),
            const SizedBox(height: 16),
            _buildStateDropdown(),
            const SizedBox(height: 16),
            _buildDistrictDropdown(),
            const SizedBox(height: 32),

            // Documents Section
            _buildSectionHeader('Documents', Icons.description_rounded),
            const SizedBox(height: 16),
            _buildDocumentCheckboxes(),
            const SizedBox(height: 32),

            // Save Button
            _buildSaveButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final provider = Provider.of<UserProfileProvider>(context);
    final percentage = provider.getCompletionPercentage();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile Completion',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  percentage < 100
                      ? 'Complete all fields to unlock AI features'
                      : '✅ Profile complete! AI features enabled',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF374151),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: _nameController,
      style: TextStyle(
        color: isDark ? Colors.white : _darkTextColor,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: 'Full Name *',
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : _labelTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hintText: 'Enter your full name',
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : _hintTextColor,
          fontSize: 14,
        ),
        prefixIcon: Icon(Icons.person_outline, color: Color(0xFF6366F1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor:
            isDark ? Colors.white.withValues(alpha: 0.05) : Color(0xFFF9FAFB),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Name is required';
        }
        if (value.trim().length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildAgeField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: _ageController,
      style: TextStyle(
        color: isDark ? Colors.white : _darkTextColor,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: 'Age *',
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : _labelTextColor,
          fontSize: 14,
        ),
        hintText: 'Enter your age',
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : _hintTextColor,
          fontSize: 14,
        ),
        prefixIcon: Icon(Icons.cake_outlined, color: Color(0xFF6366F1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor:
            isDark ? Colors.white.withValues(alpha: 0.05) : Color(0xFFF9FAFB),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Age is required';
        }
        final age = int.tryParse(value);
        if (age == null || age < 1 || age > 120) {
          return 'Please enter a valid age (1-120)';
        }
        return null;
      },
    );
  }

  Widget _buildGenderDropdown() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownButtonFormField<String>(
      initialValue: _selectedGender.isEmpty ? null : _selectedGender,
      style: TextStyle(
        color: isDark ? Colors.white : _darkTextColor,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      dropdownColor: isDark ? Color(0xFF18181B) : Colors.white,
      decoration: InputDecoration(
        labelText: 'Gender *',
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : _labelTextColor,
          fontSize: 14,
        ),
        prefixIcon: Icon(Icons.wc_outlined, color: Color(0xFF6366F1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor:
            isDark ? Colors.white.withValues(alpha: 0.05) : Color(0xFFF9FAFB),
      ),
      hint: Text(
        'Select gender',
        style: TextStyle(
            color: isDark ? Colors.white38 : _hintTextColor, fontSize: 14),
      ),
      items: _genders.map((gender) {
        return DropdownMenuItem(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => _selectedGender = value ?? '');
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Gender is required';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory.isEmpty ? null : _selectedCategory,
      style: TextStyle(
        color: isDark ? Colors.white : _darkTextColor,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      dropdownColor: isDark ? Color(0xFF18181B) : Colors.white,
      decoration: InputDecoration(
        labelText: 'Category *',
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : _labelTextColor,
          fontSize: 14,
        ),
        prefixIcon: Icon(Icons.category_outlined, color: Color(0xFF6366F1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor:
            isDark ? Colors.white.withValues(alpha: 0.05) : Color(0xFFF9FAFB),
      ),
      hint: Text(
        'Select category',
        style: TextStyle(
            color: isDark ? Colors.white38 : _hintTextColor, fontSize: 14),
      ),
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => _selectedCategory = value ?? '');
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Category is required';
        }
        return null;
      },
    );
  }

  Widget _buildOccupationField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: _occupationController,
      style: TextStyle(
        color: isDark ? Colors.white : _darkTextColor,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: 'Occupation *',
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : _labelTextColor,
          fontSize: 14,
        ),
        hintText: 'e.g., Software Engineer, Farmer, Student',
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : _hintTextColor,
          fontSize: 14,
        ),
        prefixIcon: Icon(Icons.work_outline, color: Color(0xFF6366F1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor:
            isDark ? Colors.white.withValues(alpha: 0.05) : Color(0xFFF9FAFB),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Occupation is required';
        }
        return null;
      },
    );
  }

  Widget _buildEducationField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: _educationController,
      style: TextStyle(
        color: isDark ? Colors.white : _darkTextColor,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: 'Education *',
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : _labelTextColor,
          fontSize: 14,
        ),
        hintText: 'e.g., B.Tech, 10th Pass, Graduate',
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : _hintTextColor,
          fontSize: 14,
        ),
        prefixIcon: Icon(Icons.school_outlined, color: Color(0xFF6366F1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor:
            isDark ? Colors.white.withValues(alpha: 0.05) : Color(0xFFF9FAFB),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Education is required';
        }
        return null;
      },
    );
  }

  Widget _buildIncomeField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: _incomeController,
      style: TextStyle(
        color: isDark ? Colors.white : _darkTextColor,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: 'Annual Income (₹) *',
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : _labelTextColor,
          fontSize: 14,
        ),
        hintText: 'Enter annual income in rupees',
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : _hintTextColor,
          fontSize: 14,
        ),
        prefixIcon:
            Icon(Icons.currency_rupee_outlined, color: Color(0xFF6366F1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor:
            isDark ? Colors.white.withValues(alpha: 0.05) : Color(0xFFF9FAFB),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Annual income is required';
        }
        final income = double.tryParse(value);
        if (income == null || income < 0) {
          return 'Please enter a valid income';
        }
        return null;
      },
    );
  }

  Widget _buildStateDropdown() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownButtonFormField<String>(
      initialValue: _selectedState.isEmpty ? null : _selectedState,
      style: TextStyle(
        color: isDark ? Colors.white : _darkTextColor,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      dropdownColor: isDark ? Color(0xFF18181B) : Colors.white,
      decoration: InputDecoration(
        labelText: 'State *',
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : _labelTextColor,
          fontSize: 14,
        ),
        prefixIcon: Icon(Icons.map_outlined, color: Color(0xFF6366F1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor:
            isDark ? Colors.white.withValues(alpha: 0.05) : Color(0xFFF9FAFB),
      ),
      hint: Text(
        'Select state',
        style: TextStyle(
            color: isDark ? Colors.white38 : _hintTextColor, fontSize: 14),
      ),
      items: _statesAndDistricts.keys.map((state) {
        return DropdownMenuItem(
          value: state,
          child: Text(state),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedState = value ?? '';
          _selectedDistrict = ''; // Reset district when state changes
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'State is required';
        }
        return null;
      },
    );
  }

  Widget _buildDistrictDropdown() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final districts = _selectedState.isEmpty
        ? <String>[]
        : _statesAndDistricts[_selectedState] ?? [];

    return DropdownButtonFormField<String>(
      initialValue:
          _selectedDistrict.isEmpty || !districts.contains(_selectedDistrict)
              ? null
              : _selectedDistrict,
      style: TextStyle(
        color: isDark ? Colors.white : _darkTextColor,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      dropdownColor: isDark ? Color(0xFF18181B) : Colors.white,
      decoration: InputDecoration(
        labelText: 'District *',
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : _labelTextColor,
          fontSize: 14,
        ),
        prefixIcon:
            Icon(Icons.location_city_outlined, color: Color(0xFF6366F1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: isDark ? Colors.white24 : Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor:
            isDark ? Colors.white.withValues(alpha: 0.05) : Color(0xFFF9FAFB),
      ),
      hint: Text(
        _selectedState.isEmpty ? 'Select state first' : 'Select district',
        style: TextStyle(
            color: isDark ? Colors.white38 : _hintTextColor, fontSize: 14),
      ),
      items: districts.map((district) {
        return DropdownMenuItem(
          value: district,
          child: Text(district),
        );
      }).toList(),
      onChanged: _selectedState.isEmpty
          ? null
          : (value) {
              setState(() => _selectedDistrict = value ?? '');
            },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'District is required';
        }
        return null;
      },
    );
  }

  Widget _buildDocumentCheckboxes() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: isDark ? Colors.white24 : Color(0xFFE5E7EB), width: 1),
      ),
      color: isDark ? Colors.white.withValues(alpha: 0.05) : Color(0xFFF9FAFB),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'I have the following documents:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : _labelTextColor,
              ),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: Text('Aadhar Card',
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black)),
              subtitle: Text('12-digit unique identification number',
                  style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black54)),
              secondary:
                  const Icon(Icons.credit_card, color: Color(0xFF6366F1)),
              value: _hasAadhar,
              activeColor: Color(0xFF6366F1),
              onChanged: (value) {
                setState(() => _hasAadhar = value ?? false);
              },
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: Text('PAN Card',
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black)),
              subtitle: Text('Permanent Account Number',
                  style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black54)),
              secondary: const Icon(Icons.account_balance_wallet,
                  color: Color(0xFF6366F1)),
              value: _hasPAN,
              activeColor: Color(0xFF6366F1),
              onChanged: (value) {
                setState(() => _hasPAN = value ?? false);
              },
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: Text('Income Certificate',
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black)),
              subtitle: Text('Proof of annual income',
                  style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black54)),
              secondary:
                  const Icon(Icons.receipt_long, color: Color(0xFF6366F1)),
              value: _hasIncomeCertificate,
              activeColor: Color(0xFF6366F1),
              onChanged: (value) {
                setState(() => _hasIncomeCertificate = value ?? false);
              },
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: Text('Bank Account',
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black)),
              subtitle: Text('Active bank account',
                  style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black54)),
              secondary:
                  const Icon(Icons.account_balance, color: Color(0xFF6366F1)),
              value: _hasBankAccount,
              activeColor: Color(0xFF6366F1),
              onChanged: (value) {
                setState(() => _hasBankAccount = value ?? false);
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ModernUIComponents.gradientButton(
      text: 'Save Profile',
      icon: Icons.save_rounded,
      onPressed: _isSaving
          ? () {}
          : () {
              _saveProfile();
            },
      isLoading: _isSaving,
      colors: const [
        Color(0xFF6366F1),
        Color(0xFF8B5CF6),
      ],
    );
  }
}
