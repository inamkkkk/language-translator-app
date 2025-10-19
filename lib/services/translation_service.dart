import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:language_translator/models/language_model.dart';

class TranslationService with ChangeNotifier {
  String _translatedText = '';
  String get translatedText => _translatedText;
  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;

  // Replace with your actual API key
  final String apiKey = 'YOUR_API_KEY';
  final String apiUrl = 'https://translation.googleapis.com/language/translate/v2';
  final String languageListUrl = 'https://translation.googleapis.com/language/translate/v2/languages';

  Future<void> translateText(String text, String sourceLanguage, String targetLanguage) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'q': text,
        'target': targetLanguage,
        'source': sourceLanguage,
        'format': 'text',
        'key': apiKey,
      }),
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      _translatedText = decodedResponse['data']['translations'][0]['translatedText'];
      notifyListeners();
    } else {
      _translatedText = 'Translation failed. Status code: ${response.statusCode}';
      notifyListeners();
    }
  }

  Future<void> loadLanguages() async {
    final response = await http.get(Uri.parse('$languageListUrl?key=$apiKey&target=en'));

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      List<dynamic> languageData = decodedResponse['data']['languages'];
      _languages = languageData.map((data) => LanguageModel(
        code: data['language'],
        name: data['name'],
      )).toList();
      notifyListeners();
    } else {
      // Handle error (e.g., show a message to the user)
      print('Failed to load languages: ${response.statusCode}');
    }
  }
}