import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:language_translator/models/language_model.dart';
import 'package:language_translator/services/translation_service.dart';
import 'package:provider/provider.dart';

class TranslationScreen extends StatefulWidget {
  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  TextEditingController sourceTextController = TextEditingController();
  String? sourceLanguage;
  String? targetLanguage;

  @override
  void initState() {
    super.initState();
    Provider.of<TranslationService>(context, listen: false).loadLanguages();
  }

  @override
  Widget build(BuildContext context) {
    final translationService = Provider.of<TranslationService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Translator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: sourceTextController,
              decoration: InputDecoration(
                labelText: 'Enter text to translate',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton2<String>(
                  hint: const Text('Select Source Language'),
                  value: sourceLanguage,
                  items: translationService.languages.map((LanguageModel language) => DropdownMenuItem<String>(
                    value: language.code,
                    child: Text(language.name),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      sourceLanguage = value;
                    });
                  },
                ),
                DropdownButton2<String>(
                  hint: const Text('Select Target Language'),
                  value: targetLanguage,
                  items: translationService.languages.map((LanguageModel language) => DropdownMenuItem<String>(
                    value: language.code,
                    child: Text(language.name),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      targetLanguage = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (sourceLanguage != null && targetLanguage != null && sourceTextController.text.isNotEmpty) {
                  await translationService.translateText(
                      sourceTextController.text, sourceLanguage!, targetLanguage!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select languages and enter text.'),
                    ),
                  );
                }
              },
              child: Text('Translate'),
            ),
            SizedBox(height: 20),
            Text(
              'Translation: ${translationService.translatedText}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}