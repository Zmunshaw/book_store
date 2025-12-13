import 'package:book_store/models/collection.dart';
import 'package:book_store/models/book.dart';
import 'package:book_store/services/api_service.dart';
import 'package:book_store/services/auth_service.dart';
import 'package:book_store/services/cache_service.dart';
import 'package:logger/logger.dart';

class CollectionService {
  static final Logger _logger = Logger();
  static final CacheService _cacheService = CacheService();

  static Future<Map<String, dynamic>> getUserCollections({bool forceRefresh = false}) async {
    try {
      if (!AuthService.isLoggedIn()) {
        return {
          'success': false,
          'error': 'User not logged in',
        };
      }

      final userId = AuthService.accessToken ?? '';

      if (!forceRefresh) {
        final cachedData = await _cacheService.getCollections(userId);
        if (cachedData != null) {
          final collections = cachedData
              .map((json) => Collection.fromJson(json))
              .toList();
          _logger.i('Returning ${collections.length} collections from cache');
          return {
            'success': true,
            'collections': collections,
            'fromCache': true,
          };
        }
      }

      final response = await ApiService.get(
        endpoint: '/collections/',
        token: AuthService.accessToken,
      );

      if (response['success']) {
        final collectionsData = response['data'] as List;
        final collections = collectionsData
            .map((json) => Collection.fromJson(json))
            .toList();

        _logger.i('Fetched ${collections.length} collections from API');

        await _cacheService.cacheCollections(userId, collectionsData);

        return {
          'success': true,
          'collections': collections,
          'fromCache': false,
        };
      } else {
        _logger.w('Failed to fetch collections: ${response['error']}');

        final cachedData = await _cacheService.getCollections(userId);
        if (cachedData != null) {
          final collections = cachedData
              .map((json) => Collection.fromJson(json))
              .toList();
          _logger.w('API failed, returning ${collections.length} stale cached collections');
          return {
            'success': true,
            'collections': collections,
            'fromCache': true,
            'warning': 'Using cached data due to API error',
          };
        }

        return {
          'success': false,
          'error': response['error'],
        };
      }
    } catch (e) {
      _logger.e('Error fetching collections: $e');

      if (AuthService.isLoggedIn()) {
        final userId = AuthService.accessToken ?? '';
        final cachedData = await _cacheService.getCollections(userId);
        if (cachedData != null) {
          final collections = cachedData
              .map((json) => Collection.fromJson(json))
              .toList();
          _logger.w('Exception occurred, returning ${collections.length} cached collections');
          return {
            'success': true,
            'collections': collections,
            'fromCache': true,
            'warning': 'Using cached data due to error',
          };
        }
      }

      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }

  static Future<void> _invalidateCollectionsCache() async {
    if (AuthService.isLoggedIn()) {
      final userId = AuthService.accessToken ?? '';
      await _cacheService.invalidateCollectionsCache(userId);
      _logger.d('Invalidated collections cache');
    }
  }

  static Future<Map<String, dynamic>> createCollection({
    required String name,
    String image = '',
  }) async {
    try {
      if (!AuthService.isLoggedIn()) {
        return {
          'success': false,
          'error': 'User not logged in',
        };
      }

      final collectionCreate = CollectionCreate(
        name: name,
        image: image,
      );

      final response = await ApiService.post(
        endpoint: '/collections/',
        body: collectionCreate.toJson(),
        token: AuthService.accessToken,
      );

      if (response['success']) {
        final collection = Collection.fromJson(response['data']);

        _logger.i('Created collection: ${collection.name}');

        await _invalidateCollectionsCache();

        return {
          'success': true,
          'collection': collection,
        };
      } else {
        _logger.w('Failed to create collection: ${response['error']}');
        return {
          'success': false,
          'error': response['error'],
        };
      }
    } catch (e) {
      _logger.e('Error creating collection: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }

  static Future<Map<String, dynamic>> addBookToCollection({
    required String collectionId,
    required Book book,
  }) async {
    try {
      if (!AuthService.isLoggedIn()) {
        return {
          'success': false,
          'error': 'User not logged in',
        };
      }

      final response = await ApiService.post(
        endpoint: '/collections/$collectionId/books',
        body: book.toBackendJson(),
        token: AuthService.accessToken,
      );

      if (response['success']) {
        final collection = Collection.fromJson(response['data']);

        _logger.i('Added book "${book.title}" to collection');

        await _invalidateCollectionsCache();

        return {
          'success': true,
          'collection': collection,
        };
      } else {
        _logger.w('Failed to add book to collection: ${response['error']}');
        return {
          'success': false,
          'error': response['error'],
        };
      }
    } catch (e) {
      _logger.e('Error adding book to collection: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }

  static Future<Map<String, dynamic>> removeBookFromCollection({
    required String collectionId,
    required String bookId,
  }) async {
    try {
      if (!AuthService.isLoggedIn()) {
        return {
          'success': false,
          'error': 'User not logged in',
        };
      }

      final response = await ApiService.delete(
        endpoint: '/collections/$collectionId/books/$bookId',
        token: AuthService.accessToken,
      );

      if (response['success']) {
        _logger.i('Removed book from collection');

        await _invalidateCollectionsCache();

        return {
          'success': true,
          'message': 'Book removed successfully',
        };
      } else {
        _logger.w('Failed to remove book: ${response['error']}');
        return {
          'success': false,
          'error': response['error'],
        };
      }
    } catch (e) {
      _logger.e('Error removing book: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }

  static Future<Map<String, dynamic>> deleteCollection({
    required String collectionId,
  }) async {
    try {
      if (!AuthService.isLoggedIn()) {
        return {
          'success': false,
          'error': 'User not logged in',
        };
      }

      final response = await ApiService.delete(
        endpoint: '/collections/$collectionId',
        token: AuthService.accessToken,
      );

      if (response['success']) {
        _logger.i('Deleted collection');

        await _invalidateCollectionsCache();

        return {
          'success': true,
          'message': 'Collection deleted successfully',
        };
      } else {
        _logger.w('Failed to delete collection: ${response['error']}');
        return {
          'success': false,
          'error': response['error'],
        };
      }
    } catch (e) {
      _logger.e('Error deleting collection: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }
}
