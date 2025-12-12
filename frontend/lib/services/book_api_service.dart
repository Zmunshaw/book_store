import 'package:book_store/services/api_service.dart';
import 'package:book_store/services/cache_service.dart';
import 'package:logger/logger.dart';
import '../models/book.dart';

class BookApiService {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: false,
    ),
  );

  final CacheService _cacheService = CacheService();

  Future<List<Book>> searchBooks(String query, {int page = 1, bool forceRefresh = false}) async {
    _logger.i('Searching books: query="$query", page=$page, forceRefresh=$forceRefresh');

    // Try to get cached results first
    if (!forceRefresh) {
      final cachedResults = await _cacheService.getSearchResults(query, page);
      if (cachedResults != null) {
        _logger.i('Returning ${cachedResults.length} books from cache');
        return cachedResults.map((json) => _parseBook(json)).toList();
      }
    }

    try {
      final response = await ApiService.get(
        endpoint: '/books/$query?page=$page',
      );

      _logger.d('Response status: ${response['statusCode']}');

      if (response['success']) {
        final data = response['data'];
        final results = data['results'] as List<dynamic>;
        final totalCount = data['count'] ?? 0;

        _logger.i('Successfully fetched ${results.length} books from API (total: $totalCount)');

        // Cache the raw JSON results
        await _cacheService.cacheSearchResults(query, page, results);

        final books = results.map((json) => _parseBook(json)).toList();

        _logger.d('First book: ${books.isNotEmpty ? books.first.title : "none"}');
        return books;
      } else {
        _logger.e('Failed to load books: ${response['error']}');
        throw Exception('Failed to load books: ${response['error']}');
      }
    } catch (e, stackTrace) {
      _logger.e('Error fetching books', error: e, stackTrace: stackTrace);

      // Try to return cached data if API fails
      final cachedResults = await _cacheService.getSearchResults(query, page);
      if (cachedResults != null) {
        _logger.w('API failed, returning stale cached data');
        return cachedResults.map((json) => _parseBook(json)).toList();
      }

      throw Exception('Error fetching books: $e');
    }
  }

  Book _parseBook(dynamic json) {
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
  }
}