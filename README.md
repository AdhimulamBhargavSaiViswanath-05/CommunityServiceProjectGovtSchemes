# MyScheme App

A comprehensive Flutter application that provides citizens with easy access to information about government schemes in India.

## Features

### ✨ Core Features
- **Government Schemes Database**: Browse and search through various government schemes
- **AI-Powered Chatbot**: Context-aware chatbot using Google Gemini AI to answer queries about schemes
- **Smart Search & Filter**: Search by keywords and filter by categories
- **Location-Based Weather**: Real-time weather information based on user location
- **Text-to-Speech**: Accessibility feature to read out scheme details
- **Favorites**: Save and bookmark your favorite schemes
- **User Profile**: Personalized profile with preferences and settings
- **Multi-language Support**: Choose from multiple Indian languages
- **Beautiful UI**: Modern Material Design 3 with smooth animations

### 🔧 Technical Features
- Cross-platform (Android, iOS, Web)
- Provider state management
- API integration with retry mechanism
- Local data persistence with SharedPreferences
- Responsive and adaptive UI
- Error handling and graceful fallbacks
- CORS proxy support for web platform

## Getting Started

### Prerequisites
- Flutter SDK (>=3.4.3)
- Dart SDK (>=3.4.3)
- Android Studio / VS Code
- Active internet connection

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd myscheme_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Keys** (Important!)
   
   Open `lib/utils/constants.dart` and replace the API keys with your own:
   
   - **Weather API**: Get free API key from [OpenWeatherMap](https://openweathermap.org/api)
   - **Gemini AI API**: Get API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
   
   ```dart
   const String weatherApiKey = "YOUR_WEATHER_API_KEY";
   const String geminiApiKey = "YOUR_GEMINI_API_KEY";
   ```

   > ⚠️ **Security Warning**: Never commit API keys to version control. In production, use environment variables or secure storage.

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- No additional setup required
- Minimum SDK: 21

#### iOS
- Update `ios/Runner/Info.plist` with location permissions:
  ```xml
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>We need your location to provide weather updates</string>
  ```

#### Web
- Run with: `flutter run -d chrome`
- CORS proxies are configured for API access

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── scheme.dart
│   ├── weather_model.dart
│   └── chat_message.dart
├── providers/                # State management
│   ├── scheme_provider.dart
│   ├── weather_provider.dart
│   ├── location_provider.dart
│   └── chat_provider.dart
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── scheme_list_screen.dart
│   ├── scheme_detail_screen.dart
│   ├── chat_screen.dart
│   ├── weather_detail_screen.dart
│   └── profile_screen.dart
├── services/                 # Business logic & API
│   ├── api_service.dart
│   ├── api_service_mobile.dart
│   ├── api_service_web.dart
│   ├── weather_service.dart
│   ├── chat_service.dart
│   ├── location_service.dart
│   ├── tts_service.dart
│   └── preferences_service.dart
├── widgets/                  # Reusable widgets
│   ├── scheme_card.dart
│   ├── weather_summary.dart
│   └── bottom_nav_bar.dart
└── utils/                    # Constants & helpers
    ├── constants.dart
    └── mock_data.dart
```

## Key Dependencies

- `provider` - State management
- `google_generative_ai` - Gemini AI integration
- `http` - HTTP requests
- `geolocator` - Location services
- `flutter_tts` - Text-to-speech
- `shared_preferences` - Local storage
- `url_launcher` - Open external URLs
- `google_fonts` - Custom fonts

## Usage

### Browse Schemes
1. Open the app to see recommended schemes on the home screen
2. Navigate to "Schemes" tab to see all available schemes
3. Use the search bar to find specific schemes
4. Filter by category using the category chips

### Chat with AI Assistant
1. Tap the floating chat button on the home screen
2. Ask questions about schemes, eligibility, or documents
3. The AI assistant is context-aware and knows about loaded schemes

### Save Favorites
1. Tap the bookmark icon on any scheme card
2. View saved schemes count in your profile

### Customize Profile
1. Go to Profile tab
2. Edit your personal information
3. Change language preferences
4. Toggle notifications

## Improvements Made

### Security
- ✅ Added security warning for API keys
- ✅ Recommended using environment variables

### Features
- ✅ Updated Gemini model to `gemini-1.5-flash`
- ✅ Added URL launcher for scheme official links
- ✅ Implemented search functionality
- ✅ Added category-based filtering
- ✅ Enhanced profile with user preferences
- ✅ Added favorites/bookmark feature
- ✅ Implemented splash screen
- ✅ Made chatbot context-aware of schemes
- ✅ Added local storage with SharedPreferences

### UX/UI
- ✅ Improved error messages
- ✅ Added retry mechanism for API calls
- ✅ Better loading states
- ✅ Enhanced scheme cards with categories and deadlines
- ✅ Added clear chat functionality
- ✅ Improved empty states

### Code Quality
- ✅ Better error handling
- ✅ Code documentation
- ✅ Consistent styling
- ✅ Proper state management

## Known Limitations

1. **API Keys**: Currently hardcoded in constants.dart - move to environment variables for production
2. **Authentication**: No user authentication system implemented yet
3. **Offline Mode**: Limited offline functionality
4. **Push Notifications**: Not implemented yet
5. **Saved Schemes List**: Favorites are saved but dedicated view not implemented

## Future Enhancements

- [ ] User authentication (Firebase/OAuth)
- [ ] Push notifications for scheme updates
- [ ] Offline mode with local database
- [ ] Advanced filtering (age, income, state)
- [ ] Application tracking system
- [ ] Share schemes feature
- [ ] Dark mode
- [ ] More language support
- [ ] In-app tutorials
- [ ] Analytics integration

## Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Support

For support, email support@myscheme.gov.in or open an issue in the repository.

## Acknowledgments

- MyScheme.gov.in for the schemes API
- OpenWeatherMap for weather data
- Google for Gemini AI
- Flutter team for the amazing framework

---

**Version**: 1.0.0  
**Last Updated**: October 19, 2025


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
