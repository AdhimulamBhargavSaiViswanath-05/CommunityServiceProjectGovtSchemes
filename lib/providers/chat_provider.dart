import 'package:flutter/foundation.dart';
import 'package:myscheme_app/models/chat_message.dart';
import 'package:myscheme_app/services/chat_service.dart';
import 'package:myscheme_app/models/scheme.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  List<Scheme> _schemes = [];

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  void setSchemeContext(List<Scheme> schemes) {
    _schemes = schemes;
  }

  String _buildContextPrompt(String userMessage) {
    if (_schemes.isEmpty) {
      return userMessage;
    }

    // Build a summary of available schemes for context
    final schemeContext = StringBuffer();
    schemeContext.writeln(
        'Available Government Schemes (use this context to answer questions):');

    for (var scheme in _schemes.take(10)) {
      // Limit to first 10 to avoid token limits
      schemeContext.writeln(
          '- ${scheme.title} (${scheme.category}): ${scheme.description.length > 100 ? scheme.description.substring(0, 100) : scheme.description}');
    }

    schemeContext.writeln('\nUser Question: $userMessage');
    return schemeContext.toString();
  }

  Future<void> sendMessage(String text) async {
    _messages.add(ChatMessage(text: text, isUser: true));
    _isLoading = true;
    notifyListeners();

    try {
      final contextualMessage = _buildContextPrompt(text);
      final response = await _chatService.sendMessage(contextualMessage);
      _messages.add(ChatMessage(text: response, isUser: false));
    } catch (e) {
      _messages.add(
        ChatMessage(
          text: 'Error: Could not get a response.',
          isUser: false,
          isError: true,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
