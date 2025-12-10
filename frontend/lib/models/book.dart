class Book {
  final String id;
  final String title;
  final String synopsis;
  final DateTime publishedDate;
  final String authorFirst;
  final String authorLast;
  final String coverImageUrl;
  final List<String> genres;
  
  Book({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.publishedDate,
    required this.authorFirst,
    required this.authorLast,
    required this.coverImageUrl,
    this.genres = const [],
  });
  
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['bid'] as String,
      title: json['title'] as String,
      synopsis: json['synopsis'] as String,
      publishedDate: DateTime.parse(json['date'] as String),
      authorFirst: json['authorf'] as String,
      authorLast: json['authorl'] as String,
      genres: (json['genre'] as List<dynamic>?)?.cast<String>() ?? [],
      coverImageUrl: json['image'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'synopsis': synopsis,
      'authorFirst': authorFirst,
      'authorLast': authorLast,
      'coverImageUrl': coverImageUrl,
      'genres': genres,
      'publishedDate': publishedDate.toIso8601String(),
    };
  }
}