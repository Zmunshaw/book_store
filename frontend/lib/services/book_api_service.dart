import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../models/book.dart';

class BookApiService {
  static const String baseUrl = 'http://localhost:8000';
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: false,
    ),
  );

  Future<List<Book>> searchBooks(String query, {int page = 1}) async {
    _logger.i('Searching books: query="$query", page=$page');

    try {
      final uri = Uri.parse('$baseUrl/books/$query?page=$page');
      _logger.d('Making request to: $uri');

      final response = await http.get(uri);
      _logger.d('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;
        final totalCount = data['count'] ?? 0;

        _logger.i('Successfully fetched ${results.length} books (total: $totalCount)');

        final books = results.map((json) {
          return Book(
            id: json['bID'] ?? 'unknown',
            title: json['title'] ?? 'Unknown Title',
            synopsis: json['sypnosis'] ?? '',
            publishedDate: json['date'] != null
                ? DateTime(json['date'] as int)
                : DateTime.now(),
            authorFirst: json['authorF'] ?? '',
            authorLast: json['authorL'] ?? '',
            coverImageUrl: json['image'] ?? '',
            genres: json['genre'] != null && json['genre'].isNotEmpty
                ? [json['genre'] as String]
                : [],
          );
        }).toList();

        _logger.d('First book: ${books.isNotEmpty ? books.first.title : "none"}');
        return books;
      } else {
        _logger.e('Failed to load books: HTTP ${response.statusCode}');
        _logger.e('Response body: ${response.body}');
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('Error fetching books', error: e, stackTrace: stackTrace);
      throw Exception('Error fetching books: $e');
    }
  }
}