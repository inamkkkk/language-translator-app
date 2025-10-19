import 'package:flutter/material.dart';
import 'package:language_translator/screens/translation_screen.dart';
import 'package:provider/provider.dart';

import 'models/language_model.dart';
import 'services/translation_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TranslationService()),
      ],
      child: MaterialApp(
        title: 'Language Translator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TranslationScreen(),
      ),
    );
  }
}