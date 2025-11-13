import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enhanced Language Provider supporting all major Indian languages
/// Uses manual translations as fallback when Google Translate API is not available
class EnhancedLanguageProvider with ChangeNotifier {
  String _currentLanguage = 'en';
  bool _isTranslating = false;
  String? _translationError;

  // All supported Indian languages
  final List<LanguageModel> _supportedLanguages = [
    LanguageModel(
        code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧'),
    LanguageModel(code: 'hi', name: 'Hindi', nativeName: 'हिंदी', flag: '🇮🇳'),
    LanguageModel(
        code: 'te', name: 'Telugu', nativeName: 'తెలుగు', flag: '🇮🇳'),
    LanguageModel(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', flag: '🇮🇳'),
    LanguageModel(
        code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇮🇳'),
    LanguageModel(
        code: 'mr', name: 'Marathi', nativeName: 'मराठी', flag: '🇮🇳'),
    LanguageModel(
        code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳'),
    LanguageModel(
        code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', flag: '🇮🇳'),
    LanguageModel(
        code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', flag: '🇮🇳'),
    LanguageModel(
        code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', flag: '🇮🇳'),
    LanguageModel(code: 'or', name: 'Odia', nativeName: 'ଓଡ଼ିଆ', flag: '🇮🇳'),
    LanguageModel(
        code: 'as', name: 'Assamese', nativeName: 'অসমীয়া', flag: '🇮🇳'),
    LanguageModel(code: 'ur', name: 'Urdu', nativeName: 'اردو', flag: '🇮🇳'),
  ];

  // Manual translation cache (fallback when API is not available)
  final Map<String, Map<String, String>> _manualTranslations = {
    // Hindi Translations
    'hi': {
      'appTitle': 'जन योजना जानकारी',
      'welcomeMessage': 'स्वागत है',
      'home': 'होम',
      'schemes': 'योजनाएं',
      'profile': 'प्रोफ़ाइल',
      'chat': 'चैट',
      'search': 'खोजें',
      'selectLanguage': 'भाषा चुनें',
      'languageChanged': 'भाषा बदल दी गई',
      'unsupportedLanguage':
          'यह भाषा अभी उपलब्ध नहीं है। Google अनुवादक कनेक्ट होने पर उपलब्ध होगी।',
      'noSchemesFound': 'कोई योजना नहीं मिली',
      'recommendedSchemes': 'अनुशंसित योजनाएं',
      'apply': 'आवेदन करें',
      'checkEligibility': 'पात्रता जांचें',
      'loading': 'लोड हो रहा है...',
      'refresh': 'ताज़ा करें',
      'settings': 'सेटिंग्स',
      'notifications': 'सूचनाएं',
      'language': 'भाषा',
      'theme': 'थीम',
      'darkMode': 'डार्क मोड',
      'lightMode': 'लाइट मोड',
      'about': 'के बारे में',
      'help': 'मदद',
      'logout': 'लॉग आउट',
      'save': 'सहेजें',
      'cancel': 'रद्द करें',
      'edit': 'संपादित करें',
      'delete': 'हटाएं',
      // New additions for Chat and Scheme screens
      'ai_assistant': 'AI सहायक',
      'clear_chat': 'चैट साफ़ करें',
      'all_schemes': 'सभी योजनाएं',
      'demo_mode': 'डेमो डेटा का उपयोग - API अनुपलब्ध',
      'schemes_found': 'योजना(एं) मिलीं',
      'no_schemes_found': 'कोई योजना नहीं मिली',
      'try_adjusting': 'अपनी खोज या फ़िल्टर समायोजित करने का प्रयास करें',
      'name': 'नाम',
      'age': 'उम्र',
      'gender': 'लिंग',
      'category': 'श्रेणी',
      'state': 'राज्य',
      'district': 'जिला',
      'income': 'आय',
      'occupation': 'व्यवसाय',
      'education': 'शिक्षा',
      'documents': 'दस्तावेज़',
      'applications': 'आवेदन',
      'eligibility': 'पात्रता',
      'details': 'विवरण',
      'description': 'विवरण',
      'benefits': 'लाभ',
      'howToApply': 'आवेदन कैसे करें',
      'eligibilityCriteria': 'पात्रता मानदंड',
      'requiredDocuments': 'आवश्यक दस्तावेज़',
      'officialWebsite': 'आधिकारिक वेबसाइट',
      'contactNumber': 'संपर्क नंबर',
      'email': 'ईमेल',
      'address': 'पता',
      'totalSchemes': 'कुल योजनाएं',
      'myApplications': 'मेरे आवेदन',
      'pendingApplications': 'लंबित आवेदन',
      'approvedApplications': 'स्वीकृत आवेदन',
      'rejectedApplications': 'अस्वीकृत आवेदन',
    },

    // Telugu Translations
    'te': {
      'appTitle': 'జన యోజన జాన్కారీ',
      'welcomeMessage': 'స్వాగతం',
      'home': 'హోమ్',
      'schemes': 'పథకాలు',
      'profile': 'ప్రొఫైల్',
      'chat': 'చాట్',
      'search': 'వెతకండి',
      'selectLanguage': 'భాషను ఎంచుకోండి',
      'languageChanged': 'భాష మార్చబడింది',
      'unsupportedLanguage':
          'ఈ భాష ఇంకా అందుబాటులో లేదు. Google అనువాదకం కనెక్ట్ అయినప్పుడు అందుబాటులో ఉంటుంది.',
      'noSchemesFound': 'పథకాలు కనుగొనబడలేదు',
      'recommendedSchemes': 'సిఫార్సు చేయబడిన పథకాలు',
      'apply': 'దరఖాస్తు చేయండి',
      'checkEligibility': 'అర్హతను తనిఖీ చేయండి',
      'loading': 'లోడ్ అవుతోంది...',
      'refresh': 'రిఫ్రెష్ చేయండి',
      'settings': 'సెట్టింగ్‌లు',
      'notifications': 'నోటిఫికేషన్‌లు',
      'language': 'భాష',
      'theme': 'థీమ్',
      'darkMode': 'డార్క్ మోడ్',
      'lightMode': 'లైట్ మోడ్',
      'about': 'గురించి',
      'help': 'సహాయం',
      'logout': 'లాగ్ అవుట్',
      'save': 'సేవ్ చేయండి',
      'cancel': 'రద్దు చేయండి',
      'edit': 'సవరించండి',
      'delete': 'తొలగించండి',
      // New additions for Chat and Scheme screens
      'ai_assistant': 'AI అసిస్టెంట్',
      'clear_chat': 'చాట్ క్లియర్ చేయండి',
      'all_schemes': 'అన్ని పథకాలు',
      'demo_mode': 'డెమో డేటా ఉపయోగం - API అందుబాటులో లేదు',
      'schemes_found': 'పథకాలు దొరికాయి',
      'no_schemes_found': 'పథకాలు కనుగొనబడలేదు',
      'try_adjusting': 'మీ శోధన లేదా ఫిల్టర్‌ను సర్దుబాటు చేయండి',
      'name': 'పేరు',
      'age': 'వయస్సు',
      'gender': 'లింగం',
      'category': 'వర్గం',
      'state': 'రాష్ట్రం',
      'district': 'జిల్లా',
      'income': 'ఆదాయం',
      'occupation': 'వృత్తి',
      'education': 'విద్య',
      'documents': 'పత్రాలు',
      'applications': 'దరఖాస్తులు',
      'eligibility': 'అర్హత',
      'details': 'వివరాలు',
      'description': 'వివరణ',
      'benefits': 'ప్రయోజనాలు',
      'howToApply': 'ఎలా దరఖాస్తు చేయాలి',
      'eligibilityCriteria': 'అర్హత ప్రమాణాలు',
      'requiredDocuments': 'అవసరమైన పత్రాలు',
      'officialWebsite': 'అధికారిక వెబ్‌సైట్',
      'contactNumber': 'సంప్రదింపు నంబర్',
      'email': 'ఇమెయిల్',
      'address': 'చిరునామా',
      'totalSchemes': 'మొత్తం పథకాలు',
      'myApplications': 'నా దరఖాస్తులు',
      'pendingApplications': 'పెండింగ్ దరఖాస్తులు',
      'approvedApplications': 'ఆమోదించిన దరఖాస్తులు',
      'rejectedApplications': 'తిరస్కరించిన దరఖాస్తులు',
    },

    // Tamil Translations
    'ta': {
      'appTitle': 'ஜன யோஜனா ஜானகாரி',
      'welcomeMessage': 'வரவேற்பு',
      'home': 'முகப்பு',
      'schemes': 'திட்டங்கள்',
      'profile': 'சுயவிவரம்',
      'chat': 'அரட்டை',
      'search': 'தேடுக',
      'selectLanguage': 'மொழியைத் தேர்ந்தெடுக்கவும்',
      'languageChanged': 'மொழி மாற்றப்பட்டது',
      'unsupportedLanguage':
          'இந்த மொழி இன்னும் கிடைக்கவில்லை. Google மொழிபெயர்ப்பாளர் இணைக்கப்படும்போது கிடைக்கும்.',
      'noSchemesFound': 'திட்டங்கள் கிடைக்கவில்லை',
      'recommendedSchemes': 'பரிந்துரைக்கப்பட்ட திட்டங்கள்',
      'apply': 'விண்ணப்பிக்கவும்',
      'checkEligibility': 'தகுதியை சரிபார்க்கவும்',
      'loading': 'ஏற்றுகிறது...',
      'refresh': 'புதுப்பிக்கவும்',
      'settings': 'அமைப்புகள்',
      'notifications': 'அறிவிப்புகள்',
      'language': 'மொழி',
      'theme': 'தீம்',
      'darkMode': 'இருண்ட பயன்முறை',
      'lightMode': 'ஒளி பயன்முறை',
      'about': 'பற்றி',
      'help': 'உதவி',
      'logout': 'வெளியேறு',
      'save': 'சேமி',
      'cancel': 'ரத்துசெய்',
      'edit': 'திருத்து',
      'delete': 'நீக்கு',
      // New additions for Chat and Scheme screens
      'ai_assistant': 'AI உதவியாளர்',
      'clear_chat': 'அரட்டையை அழி',
      'all_schemes': 'அனைத்து திட்டங்கள்',
      'demo_mode': 'டெமோ தரவு - API கிடைக்கவில்லை',
      'schemes_found': 'திட்டங்கள் கிடைத்தன',
      'no_schemes_found': 'திட்டங்கள் கிடைக்கவில்லை',
      'try_adjusting': 'உங்கள் தேடல் அல்லது வடிகட்டியை சரிசெய்யுங்கள்',
      'name': 'பெயர்',
      'age': 'வயது',
      'gender': 'பாலினம்',
      'category': 'வகை',
      'state': 'மாநிலம்',
      'district': 'மாவட்டம்',
      'income': 'வருமானம்',
      'occupation': 'தொழில்',
      'education': 'கல்வி',
      'documents': 'ஆவணங்கள்',
      'applications': 'விண்ணப்பங்கள்',
      'eligibility': 'தகுதி',
      'details': 'விவரங்கள்',
      'description': 'விளக்கம்',
      'benefits': 'நன்மைகள்',
      'howToApply': 'எப்படி விண்ணப்பிப்பது',
      'eligibilityCriteria': 'தகுதி அளவுகோல்கள்',
      'requiredDocuments': 'தேவையான ஆவணங்கள்',
      'officialWebsite': 'அதிகாரப்பூர்வ இணையதளம்',
      'contactNumber': 'தொடர்பு எண்',
      'email': 'மின்னஞ்சல்',
      'address': 'முகவரி',
      'totalSchemes': 'மொத்த திட்டங்கள்',
      'myApplications': 'எனது விண்ணப்பங்கள்',
      'pendingApplications': 'நிலுவையில் உள்ள விண்ணப்பங்கள்',
      'approvedApplications': 'அங்கீகரிக்கப்பட்ட விண்ணப்பங்கள்',
      'rejectedApplications': 'நிராகரிக்கப்பட்ட விண்ணப்பங்கள்',
    },

    // Bengali Translations
    'bn': {
      'appTitle': 'জন যোজনা জানকারী',
      'welcomeMessage': 'স্বাগতম',
      'home': 'হোম',
      'schemes': 'প্রকল্প',
      'profile': 'প্রোফাইল',
      'chat': 'চ্যাট',
      'search': 'অনুসন্ধান',
      'selectLanguage': 'ভাষা নির্বাচন করুন',
      'languageChanged': 'ভাষা পরিবর্তন হয়েছে',
      'unsupportedLanguage':
          'এই ভাষা এখনও উপলব্ধ নেই। Google অনুবাদক সংযুক্ত হলে উপলব্ধ হবে।',
      'noSchemesFound': 'কোন প্রকল্প পাওয়া যায়নি',
      'recommendedSchemes': 'প্রস্তাবিত প্রকল্প',
      'apply': 'আবেদন করুন',
      'checkEligibility': 'যোগ্যতা পরীক্ষা করুন',
      'loading': 'লোড হচ্ছে...',
      'refresh': 'রিফ্রেশ',
      'settings': 'সেটিংস',
      'notifications': 'বিজ্ঞপ্তি',
      'language': 'ভাষা',
      'theme': 'থিম',
      'darkMode': 'ডার্ক মোড',
      'lightMode': 'লাইট মোড',
      // New additions for Chat and Scheme screens
      'ai_assistant': 'AI সহায়ক',
      'clear_chat': 'চ্যাট মুছুন',
      'all_schemes': 'সমস্ত প্রকল্প',
      'demo_mode': 'ডেমো ডেটা - API অনুপলব্ধ',
      'schemes_found': 'প্রকল্প পাওয়া গেছে',
      'no_schemes_found': 'কোন প্রকল্প পাওয়া যায়নি',
      'try_adjusting': 'আপনার অনুসন্ধান বা ফিল্টার সামঞ্জস্য করার চেষ্টা করুন',
      'save': 'সংরক্ষণ',
      'cancel': 'বাতিল',
    },

    // Marathi Translations
    'mr': {
      'appTitle': 'जन योजना जानकारी',
      'welcomeMessage': 'स्वागत',
      'home': 'होम',
      'schemes': 'योजना',
      'profile': 'प्रोफाइल',
      'chat': 'चॅट',
      'search': 'शोधा',
      'selectLanguage': 'भाषा निवडा',
      'languageChanged': 'भाषा बदलली',
      'unsupportedLanguage':
          'ही भाषा अद्याप उपलब्ध नाही. Google अनुवादक कनेक्ट झाल्यावर उपलब्ध होईल.',
      'noSchemesFound': 'कोणतीही योजना आढळली नाही',
      'recommendedSchemes': 'शिफारस केलेली योजना',
      'apply': 'अर्ज करा',
      'checkEligibility': 'पात्रता तपासा',
      'loading': 'लोड होत आहे...',
      'refresh': 'रिफ्रेश',
      'settings': 'सेटिंग्ज',
      'notifications': 'सूचना',
      'language': 'भाषा',
      // New additions for Chat and Scheme screens
      'ai_assistant': 'AI सहाय्यक',
      'clear_chat': 'चॅट साफ करा',
      'all_schemes': 'सर्व योजना',
      'demo_mode': 'डेमो डेटा - API अनुपलब्ध',
      'schemes_found': 'योजना मिळाल्या',
      'no_schemes_found': 'कोणतीही योजना आढळली नाही',
      'try_adjusting': 'तुमचा शोध किंवा फिल्टर समायोजित करण्याचा प्रयत्न करा',
      'save': 'जतन करा',
    },

    // Gujarati Translations
    'gu': {
      'welcomeMessage': 'સ્વાગત',
      'home': 'હોમ',
      'schemes': 'યોજનાઓ',
      'profile': 'પ્રોફાઇલ',
      'chat': 'ચેટ',
      'search': 'શોધો',
      'noSchemesFound': 'કોઈ યોજના મળી નથી',
      'recommendedSchemes': 'ભલામણ કરેલ યોજનાઓ',
      'apply': 'અરજી કરો',
      'checkEligibility': 'પાત્રતા ચકાસો',
      'loading': 'લોડ થઈ રહ્યું છે...',
      'refresh': 'રિફ્રેશ',
      'save': 'સાચવો',
    },

    // Kannada Translations
    'kn': {
      'welcomeMessage': 'ಸ್ವಾಗತ',
      'home': 'ಮುಖಪುಟ',
      'schemes': 'ಯೋಜನೆಗಳು',
      'profile': 'ಪ್ರೊಫೈಲ್',
      'chat': 'ಚಾಟ್',
      'search': 'ಹುಡುಕಿ',
      'noSchemesFound': 'ಯಾವುದೇ ಯೋಜನೆಗಳು ಕಂಡುಬಂದಿಲ್ಲ',
      'recommendedSchemes': 'ಶಿಫಾರಸು ಮಾಡಲಾದ ಯೋಜನೆಗಳು',
      'apply': 'ಅರ್ಜಿ ಸಲ್ಲಿಸಿ',
      'checkEligibility': 'ಅರ್ಹತೆ ಪರಿಶೀಲಿಸಿ',
      'loading': 'ಲೋಡ್ ಆಗುತ್ತಿದೆ...',
      'refresh': 'ರಿಫ್ರೆಶ್',
      'save': 'ಉಳಿಸಿ',
    },

    // Malayalam Translations
    'ml': {
      'welcomeMessage': 'സ്വാഗതം',
      'home': 'ഹോം',
      'schemes': 'പദ്ധതികൾ',
      'profile': 'പ്രൊഫൈൽ',
      'chat': 'ചാറ്റ്',
      'search': 'തിരയുക',
      'noSchemesFound': 'പദ്ധതികൾ കണ്ടെത്തിയില്ല',
      'recommendedSchemes': 'ശുപാർശ ചെയ്ത പദ്ധതികൾ',
      'apply': 'അപേക്ഷിക്കുക',
      'checkEligibility': 'യോഗ്യത പരിശോധിക്കുക',
      'loading': 'ലോഡ് ചെയ്യുന്നു...',
      'refresh': 'പുതുക്കുക',
      'save': 'സംരക്ഷിക്കുക',
    },

    // Punjabi Translations
    'pa': {
      'welcomeMessage': 'ਸੁਆਗਤ ਹੈ',
      'home': 'ਘਰ',
      'schemes': 'ਸਕੀਮਾਂ',
      'profile': 'ਪ੍ਰੋਫਾਈਲ',
      'chat': 'ਚੈਟ',
      'search': 'ਖੋਜੋ',
      'noSchemesFound': 'ਕੋਈ ਸਕੀਮ ਨਹੀਂ ਮਿਲੀ',
      'recommendedSchemes': 'ਸਿਫਾਰਸ਼ ਕੀਤੀਆਂ ਸਕੀਮਾਂ',
      'apply': 'ਅਰਜ਼ੀ ਦਿਓ',
      'checkEligibility': 'ਯੋਗਤਾ ਜਾਂਚੋ',
      'loading': 'ਲੋਡ ਹੋ ਰਿਹਾ ਹੈ...',
      'refresh': 'ਤਾਜ਼ਾ ਕਰੋ',
      'save': 'ਸੰਭਾਲੋ',
    },
  };

  String get currentLanguage => _currentLanguage;
  bool get isTranslating => _isTranslating;
  String? get translationError => _translationError;
  List<LanguageModel> get supportedLanguages => _supportedLanguages;

  /// Initialize and load saved language
  Future<void> loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentLanguage = prefs.getString('language') ?? 'en';
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  /// Change language and save preference
  Future<void> changeLanguage(String languageCode) async {
    if (_currentLanguage == languageCode) return;

    // Check if language has manual translations
    final hasTranslations = _manualTranslations.containsKey(languageCode);

    // If no translations and not English, show unsupported message
    if (!hasTranslations && languageCode != 'en') {
      _translationError =
          'Language will be available when Google Translator is connected';
      notifyListeners();
      // Don't change language if unsupported
      return;
    }

    _currentLanguage = languageCode;
    _translationError = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', languageCode);
      notifyListeners();
    } catch (e) {
      _translationError = 'Failed to save language preference';
      debugPrint('Error saving language: $e');
    }
  }

  /// Check if language is supported with manual translations
  bool isLanguageSupported(String languageCode) {
    return languageCode == 'en' ||
        _manualTranslations.containsKey(languageCode);
  }

  /// Translate a key using manual translations (fallback)
  String translate(String key) {
    // If English, return the key as-is
    if (_currentLanguage == 'en') {
      return _formatKey(key);
    }

    // Try to get manual translation
    final languageTranslations = _manualTranslations[_currentLanguage];
    if (languageTranslations != null && languageTranslations.containsKey(key)) {
      return languageTranslations[key]!;
    }

    // Fallback to English (formatted key)
    return _formatKey(key);
  }

  /// Format camelCase key to Title Case for English
  String _formatKey(String key) {
    // Convert camelCase to Title Case
    final formatted = key.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)}',
    );
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  /// Future: Translate text using Google Translate API
  /// This will be implemented when API key is provided
  Future<String> translateWithAPI(String text, {String? targetLang}) async {
    _isTranslating = true;
    _translationError = null;
    notifyListeners();

    try {
      // TODO: Implement Google Cloud Translation API call here
      // final target = targetLang ?? _currentLanguage;
      // For now, return manual translation or original text
      await Future.delayed(const Duration(milliseconds: 100));

      _isTranslating = false;
      notifyListeners();

      return text; // Placeholder - will be replaced with API call
    } catch (e) {
      _isTranslating = false;
      _translationError = 'Translation failed';
      notifyListeners();
      return text;
    }
  }

  /// Get language name by code
  String getLanguageName(String code) {
    try {
      return _supportedLanguages.firstWhere((lang) => lang.code == code).name;
    } catch (e) {
      return 'English';
    }
  }

  /// Get language native name by code
  String getLanguageNativeName(String code) {
    try {
      return _supportedLanguages
          .firstWhere((lang) => lang.code == code)
          .nativeName;
    } catch (e) {
      return 'English';
    }
  }
}

/// Language Model
class LanguageModel {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  LanguageModel({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}
