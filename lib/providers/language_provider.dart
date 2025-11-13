import 'package:flutter/material.dart';
import 'package:myscheme_app/services/preferences_service.dart';

class LanguageProvider with ChangeNotifier {
  final PreferencesService _prefsService = PreferencesService();
  String _currentLanguage = 'English';

  String get currentLanguage => _currentLanguage;

  // Language translations map
  final Map<String, Map<String, String>> _translations = {
    'English': {
      'appTitle': 'MyScheme',
      'welcome': 'Welcome',
      'schemes': 'Schemes',
      'profile': 'Profile',
      'home': 'Home',
      'chat': 'Chat with AI Assistant',
      'search': 'Search schemes...',
      'recommended': 'Recommended for You',
      'all_schemes': 'All Schemes',
      'category': 'Category',
      'deadline': 'Deadline',
      'eligibility': 'Eligibility',
      'documents': 'Required Documents',
      'official_link': 'Visit Official Website',
      'location_error': 'Location Error',
      'fetching_weather': 'Fetching Weather...',
      'get_location': 'Get Location',
      'ai_assistant': 'AI Assistant',
      'clear_chat': 'Clear chat',
      'type_message': 'Type your message...',
      'send': 'Send',
      'no_schemes_found': 'No schemes found',
      'try_adjusting': 'Try adjusting your search or filter',
      'schemes_found': 'scheme(s) found',
      'loading': 'Loading...',
      'personal_info': 'Personal Information',
      'name': 'Name',
      'age': 'Age',
      'email': 'Email',
      'phone': 'Phone',
      'edit': 'Edit',
      'save': 'Save',
      'cancel': 'Cancel',
      'language': 'Language',
      'change_language': 'Change Language',
      'preferred_category': 'Preferred Category',
      'about': 'About',
      'version': 'Version',
      'demo_mode': 'Using demo data - API unavailable',
    },
    'Hindi': {
      'appTitle': 'मेरी योजना',
      'welcome': 'स्वागत है',
      'schemes': 'योजनाएं',
      'profile': 'प्रोफ़ाइल',
      'home': 'होम',
      'chat': 'AI सहायक से चैट करें',
      'search': 'योजनाएं खोजें...',
      'recommended': 'आपके लिए अनुशंसित',
      'all_schemes': 'सभी योजनाएं',
      'category': 'श्रेणी',
      'deadline': 'अंतिम तिथि',
      'eligibility': 'पात्रता',
      'documents': 'आवश्यक दस्तावेज़',
      'official_link': 'आधिकारिक वेबसाइट पर जाएं',
      'location_error': 'स्थान त्रुटि',
      'fetching_weather': 'मौसम प्राप्त कर रहे हैं...',
      'get_location': 'स्थान प्राप्त करें',
      'ai_assistant': 'AI सहायक',
      'clear_chat': 'चैट साफ़ करें',
      'type_message': 'अपना संदेश लिखें...',
      'send': 'भेजें',
      'no_schemes_found': 'कोई योजना नहीं मिली',
      'try_adjusting': 'अपनी खोज या फ़िल्टर समायोजित करने का प्रयास करें',
      'schemes_found': 'योजना(एं) मिलीं',
      'loading': 'लोड हो रहा है...',
      'personal_info': 'व्यक्तिगत जानकारी',
      'name': 'नाम',
      'age': 'आयु',
      'email': 'ईमेल',
      'phone': 'फ़ोन',
      'edit': 'संपादित करें',
      'save': 'सहेजें',
      'cancel': 'रद्द करें',
      'language': 'भाषा',
      'change_language': 'भाषा बदलें',
      'preferred_category': 'पसंदीदा श्रेणी',
      'about': 'के बारे में',
      'version': 'संस्करण',
      'demo_mode': 'डेमो डेटा का उपयोग - API अनुपलब्ध',
    },
    'Tamil': {
      'appTitle': 'என் திட்டம்',
      'welcome': 'வரவேற்கிறோம்',
      'schemes': 'திட்டங்கள்',
      'profile': 'சுயவிவரம்',
      'home': 'முகப்பு',
      'chat': 'AI உதவியாளருடன் அரட்டை',
      'search': 'திட்டங்களைத் தேடுங்கள்...',
      'recommended': 'உங்களுக்கு பரிந்துரைக்கப்பட்டது',
      'all_schemes': 'அனைத்து திட்டங்கள்',
      'category': 'வகை',
      'deadline': 'கடைசி தேதி',
      'eligibility': 'தகுதி',
      'documents': 'தேவையான ஆவணங்கள்',
      'official_link': 'அதிகாரப்பூர்வ இணையதளத்தைப் பார்வையிடவும்',
      'location_error': 'இடம் பிழை',
      'fetching_weather': 'வானிலை பெறுகிறது...',
      'get_location': 'இடத்தைப் பெறுங்கள்',
    },
    'Telugu': {
      'appTitle': 'నా పథకం',
      'welcome': 'స్వాగతం',
      'schemes': 'పథకాలు',
      'profile': 'ప్రొఫైల్',
      'home': 'హోమ్',
      'chat': 'AI అసిస్టెంట్‌తో చాట్',
      'search': 'పథకాలను శోధించండి...',
      'recommended': 'మీ కోసం సిఫార్సు చేయబడింది',
      'all_schemes': 'అన్ని పథకాలు',
      'category': 'వర్గం',
      'deadline': 'చివరి తేదీ',
      'eligibility': 'అర్హత',
      'documents': 'అవసరమైన పత్రాలు',
      'official_link': 'అధికారిక వెబ్‌సైట్‌ను సందర్శించండి',
      'location_error': 'లొకేషన్ లోపం',
      'fetching_weather': 'వాతావరణాన్ని పొందుతోంది...',
      'get_location': 'లొకేషన్ పొందండి',
    },
    'Bengali': {
      'appTitle': 'আমার প্রকল্প',
      'welcome': 'স্বাগতম',
      'schemes': 'প্রকল্পসমূহ',
      'profile': 'প্রোফাইল',
      'home': 'হোম',
      'chat': 'AI সহায়কের সাথে চ্যাট',
      'search': 'প্রকল্প খুঁজুন...',
      'recommended': 'আপনার জন্য সুপারিশ',
      'all_schemes': 'সব প্রকল্প',
      'category': 'বিভাগ',
      'deadline': 'শেষ তারিখ',
      'eligibility': 'যোগ্যতা',
      'documents': 'প্রয়োজনীয় নথি',
      'official_link': 'অফিসিয়াল ওয়েবসাইট দেখুন',
      'location_error': 'অবস্থান ত্রুটি',
      'fetching_weather': 'আবহাওয়া পাচ্ছি...',
      'get_location': 'অবস্থান পান',
    },
  };

  Future<void> loadLanguage() async {
    _currentLanguage = await _prefsService.getLanguage();
    notifyListeners();
  }

  Future<void> changeLanguage(String language) async {
    if (_translations.containsKey(language)) {
      _currentLanguage = language;
      await _prefsService.setLanguage(language);
      notifyListeners();
    }
  }

  String translate(String key) {
    return _translations[_currentLanguage]?[key] ?? key;
  }

  List<String> get availableLanguages => _translations.keys.toList();
}
