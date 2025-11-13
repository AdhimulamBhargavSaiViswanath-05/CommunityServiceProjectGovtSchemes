import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:myscheme_app/utils/constants.dart';
import 'package:flutter/foundation.dart';

class ChatService {
  final GenerativeModel _model;

  ChatService()
      : _model = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: geminiApiKey,
        );

  Future<String> sendMessage(String message) async {
    try {
      final content = [Content.text(message)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Sorry, I could not process that.';
    } catch (e) {
      // Add detailed logging to the debug console
      if (kDebugMode) {
        print('Error sending message to Gemini: $e');
      }
      // Return a helpful message suggesting model alternatives
      return 'The AI service is currently unavailable. This could be due to:\n'
          '1. Invalid or expired API key\n'
          '2. Network connectivity issues\n'
          '3. Model availability in your region\n\n'
          'Please verify your Gemini API key at: https://makersuite.google.com/app/apikey';
    }
  }
}
