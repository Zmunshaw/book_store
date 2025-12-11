import 'book.dart';

class Collection {
  final String id;
  final String name;
  final String imageURL;
  final List<Book> books;
  final String userID;

  Collection({
    required this.id,
    required this.name,
    required this.imageURL,
    required this.userID,
    this.books = const [],
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['cID'] as String,
      name: json['name'] as String,
      imageURL: json['image'] as String? ?? '',
      userID: json['uID'] as String,
      books: (json['books'] as List<dynamic>?)
              ?.map((bookJson) =>
                  Book.fromBackendJson(bookJson as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cID': id,
      'name': name,
      'image': imageURL,
      'uID': userID,
      'books': books.map((book) => book.toBackendJson()).toList(),
    };
  }
}

class CollectionCreate {
  final String name;
  final String image;

  CollectionCreate({
    required this.name,
    this.image = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
    };
  }
}
