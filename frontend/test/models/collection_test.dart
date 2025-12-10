import 'package:flutter_test/flutter_test.dart';
import 'package:book_store/models/collection.dart';
import 'package:book_store/models/book.dart';

void main() {
  group('Collection Model Tests', () {
    test('Collection constructor creates instance correctly', () {
      final book1 = Book(
        id: 'book1',
        title: 'Book One',
        synopsis: 'First book',
        publishedDate: DateTime(2020, 1, 1),
        authorFirst: 'John',
        authorLast: 'Doe',
        coverImageUrl: 'https://example.com/book1.jpg',
      );

      final collection = Collection(
        id: 'col123',
        name: 'My Favorites',
        imageURL: 'https://example.com/collection.jpg',
        userID: 'user123',
        books: [book1],
      );

      expect(collection.id, 'col123');
      expect(collection.name, 'My Favorites');
      expect(collection.imageURL, 'https://example.com/collection.jpg');
      expect(collection.userID, 'user123');
      expect(collection.books.length, 1);
      expect(collection.books[0].id, 'book1');
    });

    test('Collection constructor defaults books to empty list', () {
      final collection = Collection(
        id: 'col123',
        name: 'My Favorites',
      );

      expect(collection.books, isEmpty);
      expect(collection.imageURL, isNull);
      expect(collection.userID, isNull);
    });

    test('Collection.fromJson creates Collection from valid JSON with books', () {
      final json = {
        'id': 'col123',
        'name': 'My Favorites',
        'image': 'https://example.com/collection.jpg',
        'userID': 'user123',
        'books': [
          {
            'bid': 'book1',
            'title': 'Book One',
            'synopsis': 'First book',
            'date': '2020-01-01T00:00:00.000',
            'authorf': 'John',
            'authorl': 'Doe',
            'image': 'https://example.com/book1.jpg',
            'genre': ['Fiction'],
          },
          {
            'bid': 'book2',
            'title': 'Book Two',
            'synopsis': 'Second book',
            'date': '2021-01-01T00:00:00.000',
            'authorf': 'Jane',
            'authorl': 'Smith',
            'image': 'https://example.com/book2.jpg',
            'genre': ['Non-Fiction'],
          },
        ],
      };

      final collection = Collection.fromJson(json);

      expect(collection.id, 'col123');
      expect(collection.name, 'My Favorites');
      expect(collection.imageURL, 'https://example.com/collection.jpg');
      expect(collection.userID, 'user123');
      expect(collection.books.length, 2);
      expect(collection.books[0].title, 'Book One');
      expect(collection.books[1].title, 'Book Two');
    });

    test('Collection.fromJson handles null books list', () {
      final json = {
        'id': 'col123',
        'name': 'My Favorites',
        'image': 'https://example.com/collection.jpg',
        'userID': 'user123',
      };

      final collection = Collection.fromJson(json);

      expect(collection.books, isEmpty);
    });

    test('Collection.fromJson handles null imageURL and userID', () {
      final json = {
        'id': 'col123',
        'name': 'My Favorites',
      };

      final collection = Collection.fromJson(json);

      expect(collection.id, 'col123');
      expect(collection.name, 'My Favorites');
      expect(collection.imageURL, isNull);
      expect(collection.userID, isNull);
      expect(collection.books, isEmpty);
    });

    test('Collection.fromJson handles empty books list', () {
      final json = {
        'id': 'col123',
        'name': 'My Favorites',
        'books': [],
      };

      final collection = Collection.fromJson(json);

      expect(collection.books, isEmpty);
    });

    test('Collection.toJson converts Collection to JSON correctly', () {
      final book1 = Book(
        id: 'book1',
        title: 'Book One',
        synopsis: 'First book',
        publishedDate: DateTime(2020, 1, 1),
        authorFirst: 'John',
        authorLast: 'Doe',
        coverImageUrl: 'https://example.com/book1.jpg',
        genres: ['Fiction'],
      );

      final collection = Collection(
        id: 'col123',
        name: 'My Favorites',
        imageURL: 'https://example.com/collection.jpg',
        userID: 'user123',
        books: [book1],
      );

      final json = collection.toJson();

      expect(json['id'], 'col123');
      expect(json['name'], 'My Favorites');
      expect(json['image'], 'https://example.com/collection.jpg');
      expect(json['userID'], 'user123');
      expect(json['books'], isList);
      expect((json['books'] as List).length, 1);
      expect((json['books'] as List)[0]['id'], 'book1');
    });

    test('Collection.toJson handles empty books list', () {
      final collection = Collection(
        id: 'col123',
        name: 'My Favorites',
      );

      final json = collection.toJson();

      expect(json['books'], isEmpty);
    });

    test('Collection.toJson handles null imageURL and userID', () {
      final collection = Collection(
        id: 'col123',
        name: 'My Favorites',
      );

      final json = collection.toJson();

      expect(json['image'], isNull);
      expect(json['userID'], isNull);
    });

    test('Collection fromJson and toJson round trip with books', () {
      final originalJson = {
        'id': 'col123',
        'name': 'My Favorites',
        'image': 'https://example.com/collection.jpg',
        'userID': 'user123',
        'books': [
          {
            'bid': 'book1',
            'title': 'Book One',
            'synopsis': 'First book',
            'date': '2020-01-01T00:00:00.000',
            'authorf': 'John',
            'authorl': 'Doe',
            'image': 'https://example.com/book1.jpg',
            'genre': ['Fiction'],
          },
        ],
      };

      final collection = Collection.fromJson(originalJson);
      final resultJson = collection.toJson();

      expect(resultJson['id'], originalJson['id']);
      expect(resultJson['name'], originalJson['name']);
      expect(resultJson['image'], originalJson['image']);
      expect(resultJson['userID'], originalJson['userID']);
      expect((resultJson['books'] as List).length, 1);
    });

    test('Collection handles multiple books correctly', () {
      final books = List.generate(
        5,
        (index) => Book(
          id: 'book$index',
          title: 'Book $index',
          synopsis: 'Synopsis $index',
          publishedDate: DateTime(2020 + index, 1, 1),
          authorFirst: 'Author',
          authorLast: 'Name$index',
          coverImageUrl: 'https://example.com/book$index.jpg',
        ),
      );

      final collection = Collection(
        id: 'col123',
        name: 'Large Collection',
        books: books,
      );

      expect(collection.books.length, 5);
      expect(collection.books[0].title, 'Book 0');
      expect(collection.books[4].title, 'Book 4');
    });
  });
}
