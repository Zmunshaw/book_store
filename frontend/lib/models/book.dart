class Book {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final double price;
  final String? description;
  final String? coverImageUrl;
  final List<String> genres;
  final DateTime? publishedDate;
  final int stockQuantity;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.price,
    this.description,
    this.coverImageUrl,
    this.genres = const [],
    this.publishedDate,
    this.stockQuantity = 0,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      isbn: json['isbn'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>() ?? [],
      publishedDate: json['publishedDate'] != null
          ? DateTime.parse(json['publishedDate'] as String)
          : null,
      stockQuantity: json['stockQuantity'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'price': price,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'genres': genres,
      'publishedDate': publishedDate?.toIso8601String(),
      'stockQuantity': stockQuantity,
    };
  }
}
