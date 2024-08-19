import 'package:flutter/material.dart';
import 'package:dart_openai/openai.dart';
import 'second_page.dart';
import 'home_page.dart';
import 'image_recognize.dart';

void main() {
  // OpenAI.apiKey = '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';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Recognizer',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color.fromRGBO(77, 95, 117, 1),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
          headlineMedium: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(
              color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.grey, fontSize: 15),
          bodyLarge: TextStyle(color: Colors.white, fontSize: 20),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
      home: const HomePage(),
      // home: const SecPage(),
    );
  }
}
