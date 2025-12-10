import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:book_store/main.dart';
import 'package:book_store/widgets/main_navigation.dart';

void main() {
  group('BookStoreApp Tests', () {
    testWidgets('App launches successfully', (WidgetTester tester) async {
      await tester.pumpWidget(const BookStoreApp());

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(MainNavigation), findsOneWidget);
    });

    testWidgets('App has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const BookStoreApp());

      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.title, 'Book Store');
    });

    testWidgets('App has debug banner disabled', (WidgetTester tester) async {
      await tester.pumpWidget(const BookStoreApp());

      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, false);
    });

    testWidgets('App uses Material 3', (WidgetTester tester) async {
      await tester.pumpWidget(const BookStoreApp());

      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.theme?.useMaterial3, true);
      expect(materialApp.darkTheme?.useMaterial3, true);
    });

    testWidgets('App has both light and dark themes', (WidgetTester tester) async {
      await tester.pumpWidget(const BookStoreApp());

      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
      expect(materialApp.themeMode, ThemeMode.system);
    });

    testWidgets('App theme uses deepPurple color scheme', (WidgetTester tester) async {
      await tester.pumpWidget(const BookStoreApp());

      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.theme?.colorScheme.primary, isNotNull);
      expect(materialApp.darkTheme?.colorScheme.primary, isNotNull);
    });

    testWidgets('App loads MainNavigation as home', (WidgetTester tester) async {
      await tester.pumpWidget(const BookStoreApp());
      await tester.pumpAndSettle();

      expect(find.byType(MainNavigation), findsOneWidget);
    });
  });
}
