import 'package:flutter_test/flutter_test.dart';
import 'package:book_store/models/book.dart';

void main() {
  group('Book Model Tests', () {
    test('Book constructor creates instance correctly', () {
      final publishedDate = DateTime(2020, 3, 15);
      final book = Book(
        id: 'book123',
        title: 'The Great Adventure',
        synopsis: 'An exciting story about adventures',
        publishedDate: publishedDate,
        authorFirst: 'John',
        authorLast: 'Smith',
        coverImageUrl: 'https://example.com/cover.jpg',
        genres: ['Fiction', 'Adventure'],
      );

      expect(book.id, 'book123');
      expect(book.title, 'The Great Adventure');
      expect(book.synopsis, 'An exciting story about adventures');
      expect(book.publishedDate, publishedDate);
      expect(book.authorFirst, 'John');
      expect(book.authorLast, 'Smith');
      expect(book.coverImageUrl, 'https://example.com/cover.jpg');
      expect(book.genres, ['Fiction', 'Adventure']);
    });

    test('Book constructor defaults genres to empty list', () {
      final publishedDate = DateTime(2020, 3, 15);
      final book = Book(
        id: 'book123',
        title: 'The Great Adventure',
        synopsis: 'An exciting story',
        publishedDate: publishedDate,
        authorFirst: 'John',
        authorLast: 'Smith',
        coverImageUrl: 'https://example.com/cover.jpg',
      );

      expect(book.genres, isEmpty);
    });

    test('Book.fromJson creates Book from valid JSON', () {
      final json = {
        'bid': 'book123',
        'title': 'The Great Adventure',
        'synopsis': 'An exciting story about adventures',
        'date': '2020-03-15T00:00:00.000',
        'authorf': 'John',
        'authorl': 'Smith',
        'image': 'https://example.com/cover.jpg',
        'genre': ['Fiction', 'Adventure'],
      };

      final book = Book.fromJson(json);

      expect(book.id, 'book123');
      expect(book.title, 'The Great Adventure');
      expect(book.synopsis, 'An exciting story about adventures');
      expect(book.publishedDate, DateTime(2020, 3, 15));
      expect(book.authorFirst, 'John');
      expect(book.authorLast, 'Smith');
      expect(book.coverImageUrl, 'https://example.com/cover.jpg');
      expect(book.genres, ['Fiction', 'Adventure']);
    });

    test('Book.fromJson handles null or missing genres', () {
      final json = {
        'bid': 'book123',
        'title': 'The Great Adventure',
        'synopsis': 'An exciting story',
        'date': '2020-03-15T00:00:00.000',
        'authorf': 'John',
        'authorl': 'Smith',
        'image': 'https://example.com/cover.jpg',
      };

      final book = Book.fromJson(json);

      expect(book.genres, isEmpty);
    });

    test('Book.fromJson handles empty genres list', () {
      final json = {
        'bid': 'book123',
        'title': 'The Great Adventure',
        'synopsis': 'An exciting story',
        'date': '2020-03-15T00:00:00.000',
        'authorf': 'John',
        'authorl': 'Smith',
        'image': 'https://example.com/cover.jpg',
        'genre': [],
      };

      final book = Book.fromJson(json);

      expect(book.genres, isEmpty);
    });

    test('Book.toJson converts Book to JSON correctly', () {
      final publishedDate = DateTime(2020, 3, 15);
      final book = Book(
        id: 'book123',
        title: 'The Great Adventure',
        synopsis: 'An exciting story about adventures',
        publishedDate: publishedDate,
        authorFirst: 'John',
        authorLast: 'Smith',
        coverImageUrl: 'https://example.com/cover.jpg',
        genres: ['Fiction', 'Adventure'],
      );

      final json = book.toJson();

      expect(json['id'], 'book123');
      expect(json['title'], 'The Great Adventure');
      expect(json['synopsis'], 'An exciting story about adventures');
      expect(json['authorFirst'], 'John');
      expect(json['authorLast'], 'Smith');
      expect(json['coverImageUrl'], 'https://example.com/cover.jpg');
      expect(json['genres'], ['Fiction', 'Adventure']);
      expect(json['publishedDate'], publishedDate.toIso8601String());
    });

    test('Book.toJson handles empty genres', () {
      final publishedDate = DateTime(2020, 3, 15);
      final book = Book(
        id: 'book123',
        title: 'The Great Adventure',
        synopsis: 'An exciting story',
        publishedDate: publishedDate,
        authorFirst: 'John',
        authorLast: 'Smith',
        coverImageUrl: 'https://example.com/cover.jpg',
      );

      final json = book.toJson();

      expect(json['genres'], isEmpty);
    });

    test('Book fromJson and toJson handles date serialization', () {
      final json = {
        'bid': 'book123',
        'title': 'The Great Adventure',
        'synopsis': 'An exciting story',
        'date': '2020-03-15T10:30:00.000Z',
        'authorf': 'John',
        'authorl': 'Smith',
        'image': 'https://example.com/cover.jpg',
        'genre': ['Fiction'],
      };

      final book = Book.fromJson(json);
      final resultJson = book.toJson();

      expect(book.publishedDate, DateTime.parse('2020-03-15T10:30:00.000Z'));
      expect(resultJson['publishedDate'], book.publishedDate.toIso8601String());
    });

    test('Book handles multiple genres correctly', () {
      final json = {
        'bid': 'book123',
        'title': 'The Great Adventure',
        'synopsis': 'An exciting story',
        'date': '2020-03-15T00:00:00.000',
        'authorf': 'John',
        'authorl': 'Smith',
        'image': 'https://example.com/cover.jpg',
        'genre': ['Fiction', 'Adventure', 'Mystery', 'Thriller'],
      };

      final book = Book.fromJson(json);

      expect(book.genres.length, 4);
      expect(book.genres, containsAll(['Fiction', 'Adventure', 'Mystery', 'Thriller']));
    });
  });
}
