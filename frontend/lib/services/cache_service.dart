import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  Database? _database;
  final Logger _logger = Logger();

  // For web platform, use in-memory storage as fallback
  final bool _isWebPlatform = kIsWeb;

  // Cache duration constants (in minutes)
  static const int searchCacheDuration = 30; // 30 minutes for search results
  static const int collectionsCacheDuration = 60; // 1 hour for collections
  static const int featuredBooksCacheDuration = 120; // 2 hours for featured books

  Future<Database?> get database async {
    if (_isWebPlatform) {
      _logger.w('SQLite not available on web platform, using SharedPreferences fallback');
      return null;
    }
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'bookify_cache.db');

    _logger.d('Initializing cache database at: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    _logger.d('Creating cache tables');

    // Table for caching API responses
    await db.execute('''
      CREATE TABLE cache_entries (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        expiration_minutes INTEGER NOT NULL
      )
    ''');

    // Table for caching book search results
    await db.execute('''
      CREATE TABLE search_cache (
        query TEXT NOT NULL,
        page INTEGER NOT NULL,
        results TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        PRIMARY KEY (query, page)
      )
    ''');

    // Table for caching collections
    await db.execute('''
      CREATE TABLE collections_cache (
        user_id TEXT NOT NULL,
        collections TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        PRIMARY KEY (user_id)
      )
    ''');
  }

  // Generic cache methods
  Future<void> set(String key, dynamic value, {int expirationMinutes = 60}) async {
    if (_isWebPlatform) {
      _logger.d('Web platform - caching disabled for key: $key');
      return;
    }

    try {
      final db = await database;
      if (db == null) return;

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final jsonValue = jsonEncode(value);

      await db.insert(
        'cache_entries',
        {
          'key': key,
          'value': jsonValue,
          'timestamp': timestamp,
          'expiration_minutes': expirationMinutes,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _logger.d('Cached entry for key: $key');
    } catch (e) {
      _logger.e('Error caching entry: $e');
    }
  }

  Future<dynamic> get(String key) async {
    if (_isWebPlatform) {
      return null;
    }

    try {
      final db = await database;
      if (db == null) return null;

      final results = await db.query(
        'cache_entries',
        where: 'key = ?',
        whereArgs: [key],
      );

      if (results.isEmpty) {
        _logger.d('Cache miss for key: $key');
        return null;
      }

      final entry = results.first;
      final timestamp = entry['timestamp'] as int;
      final expirationMinutes = entry['expiration_minutes'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;
      final expirationTime = timestamp + (expirationMinutes * 60 * 1000);

      if (now > expirationTime) {
        _logger.d('Cache expired for key: $key');
        await delete(key);
        return null;
      }

      _logger.d('Cache hit for key: $key');
      return jsonDecode(entry['value'] as String);
    } catch (e) {
      _logger.e('Error getting cached entry: $e');
      return null;
    }
  }

  Future<void> delete(String key) async {
    if (_isWebPlatform) return;

    try {
      final db = await database;
      if (db == null) return;

      await db.delete(
        'cache_entries',
        where: 'key = ?',
        whereArgs: [key],
      );
      _logger.d('Deleted cache entry for key: $key');
    } catch (e) {
      _logger.e('Error deleting cache entry: $e');
    }
  }

  // Search cache methods
  Future<void> cacheSearchResults(String query, int page, List<dynamic> results) async {
    if (_isWebPlatform) return;

    try {
      final db = await database;
      if (db == null) return;

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final jsonResults = jsonEncode(results);

      await db.insert(
        'search_cache',
        {
          'query': query.toLowerCase(),
          'page': page,
          'results': jsonResults,
          'timestamp': timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _logger.d('Cached search results for query: "$query", page: $page');
    } catch (e) {
      _logger.e('Error caching search results: $e');
    }
  }

  Future<List<dynamic>?> getSearchResults(String query, int page) async {
    if (_isWebPlatform) return null;

    try {
      final db = await database;
      if (db == null) return null;

      final results = await db.query(
        'search_cache',
        where: 'query = ? AND page = ?',
        whereArgs: [query.toLowerCase(), page],
      );

      if (results.isEmpty) {
        _logger.d('No cached search results for query: "$query", page: $page');
        return null;
      }

      final entry = results.first;
      final timestamp = entry['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;
      final expirationTime = timestamp + (searchCacheDuration * 60 * 1000);

      if (now > expirationTime) {
        _logger.d('Search cache expired for query: "$query", page: $page');
        await deleteSearchResults(query, page);
        return null;
      }

      _logger.d('Retrieved cached search results for query: "$query", page: $page');
      final jsonResults = entry['results'] as String;
      return jsonDecode(jsonResults) as List<dynamic>;
    } catch (e) {
      _logger.e('Error getting cached search results: $e');
      return null;
    }
  }

  Future<void> deleteSearchResults(String query, int page) async {
    if (_isWebPlatform) return;

    try {
      final db = await database;
      if (db == null) return;

      await db.delete(
        'search_cache',
        where: 'query = ? AND page = ?',
        whereArgs: [query.toLowerCase(), page],
      );
      _logger.d('Deleted search cache for query: "$query", page: $page');
    } catch (e) {
      _logger.e('Error deleting search cache: $e');
    }
  }

  Future<void> clearSearchCache() async {
    if (_isWebPlatform) return;

    try {
      final db = await database;
      if (db == null) return;

      await db.delete('search_cache');
      _logger.d('Cleared all search cache');
    } catch (e) {
      _logger.e('Error clearing search cache: $e');
    }
  }

  // Collections cache methods
  Future<void> cacheCollections(String userId, List<dynamic> collections) async {
    if (_isWebPlatform) return;

    try {
      final db = await database;
      if (db == null) return;

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final jsonCollections = jsonEncode(collections);

      await db.insert(
        'collections_cache',
        {
          'user_id': userId,
          'collections': jsonCollections,
          'timestamp': timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _logger.d('Cached collections for user: $userId');
    } catch (e) {
      _logger.e('Error caching collections: $e');
    }
  }

  Future<List<dynamic>?> getCollections(String userId) async {
    if (_isWebPlatform) return null;

    try {
      final db = await database;
      if (db == null) return null;

      final results = await db.query(
        'collections_cache',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      if (results.isEmpty) {
        _logger.d('No cached collections for user: $userId');
        return null;
      }

      final entry = results.first;
      final timestamp = entry['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;
      final expirationTime = timestamp + (collectionsCacheDuration * 60 * 1000);

      if (now > expirationTime) {
        _logger.d('Collections cache expired for user: $userId');
        await invalidateCollectionsCache(userId);
        return null;
      }

      _logger.d('Retrieved cached collections for user: $userId');
      final jsonCollections = entry['collections'] as String;
      return jsonDecode(jsonCollections) as List<dynamic>;
    } catch (e) {
      _logger.e('Error getting cached collections: $e');
      return null;
    }
  }

  Future<void> invalidateCollectionsCache(String userId) async {
    if (_isWebPlatform) return;

    try {
      final db = await database;
      if (db == null) return;

      await db.delete(
        'collections_cache',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
      _logger.d('Invalidated collections cache for user: $userId');
    } catch (e) {
      _logger.e('Error invalidating collections cache: $e');
    }
  }

  // Clear all cache
  Future<void> clearAllCache() async {
    if (_isWebPlatform) return;

    try {
      final db = await database;
      if (db == null) return;

      await db.delete('cache_entries');
      await db.delete('search_cache');
      await db.delete('collections_cache');
      _logger.i('Cleared all cache data');
    } catch (e) {
      _logger.e('Error clearing all cache: $e');
    }
  }

  // Get cache statistics
  Future<Map<String, int>> getCacheStats() async {
    if (_isWebPlatform) {
      return {
        'cache_entries': 0,
        'search_cache': 0,
        'collections_cache': 0,
      };
    }

    try {
      final db = await database;
      if (db == null) return {};

      final cacheCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM cache_entries')
      ) ?? 0;

      final searchCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM search_cache')
      ) ?? 0;

      final collectionsCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM collections_cache')
      ) ?? 0;

      return {
        'cache_entries': cacheCount,
        'search_cache': searchCount,
        'collections_cache': collectionsCount,
      };
    } catch (e) {
      _logger.e('Error getting cache stats: $e');
      return {};
    }
  }

  // Close database connection
  Future<void> close() async {
    if (_isWebPlatform) return;

    try {
      final db = await database;
      if (db == null) return;

      await db.close();
      _database = null;
      _logger.d('Cache database closed');
    } catch (e) {
      _logger.e('Error closing database: $e');
    }
  }
}
