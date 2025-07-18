import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'test_screen.dart';

void main() {
  runApp(const MathKeyboardDemoApp());
}

class MathKeyboardDemoApp extends StatelessWidget {
  const MathKeyboardDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Keyboard Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7349F2)),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
      ],
      home: const TestExerciseScreen(),
    );
  }
}
