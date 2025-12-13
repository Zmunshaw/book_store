import 'package:book_store/app_data/app_globals.dart';
import 'package:book_store/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthService.init();

  runApp(const BookStoreApp());
}

class BookStoreApp extends StatelessWidget {
  const BookStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const MainNavigation(),
    );
  }
}
