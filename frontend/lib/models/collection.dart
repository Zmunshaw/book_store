import 'book.dart';

class Collection {
  final String id;
  final String name;
  final String? imageURL;
  final List<Book> books;
  final String? userID;
  
  Collection({
    required this.id,
    required this.name,
    this.imageURL,
    this.userID,
    this.books = const [],
  });
  
  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] as String,
      name: json['name'] as String,
      imageURL: json['image'] as String?,
      userID: json['userID'] as String?,
      books: (json['books'] as List<dynamic>?)
          ?.map((bookJson) => Book.fromJson(bookJson as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': imageURL,
      'userID': userID,
      'books': books.map((book) => book.toJson()).toList(),
    };
  }
}