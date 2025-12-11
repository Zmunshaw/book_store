import 'package:flutter/material.dart';
import 'widgets/main_navigation.dart';

void main() {
  runApp(const BookStoreApp());
}

class BookStoreApp extends StatelessWidget {
  const BookStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF41),
          secondary: Color(0xFF00D9FF),
          surface: Color(0xFF0D1117),
          error: Color(0xFFFF0055),
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Color(0xFF00FF41),
        ),
        scaffoldBackgroundColor: const Color(0xFF010409),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 8,
          color: const Color(0xFF0D1117),
          shadowColor: const Color(0xFF00FF41).withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: const Color(0xFF00FF41).withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF00FF41)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: const Color(0xFF00FF41).withValues(alpha: 0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF00FF41), width: 2),
          ),
          filled: true,
          fillColor: const Color(0xFF0D1117),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF010409),
          foregroundColor: Color(0xFF00FF41),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF00FF41)),
          bodyMedium: TextStyle(color: Color(0xFF00FF41)),
          bodySmall: TextStyle(color: Color(0xFF00FF41)),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const MainNavigation(),
    );
  }
}
