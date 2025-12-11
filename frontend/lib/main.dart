import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
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
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const MainNavigation(),
    );
  }
}
