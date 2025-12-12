class Book {
  final String id;
  final String title;
  final String synopsis;
  final DateTime? publishedDate;
  final String authorFirst;
  final String authorLast;
  final String coverImageUrl;
  final List<String> genres;

  Book({
    required this.id,
    required this.title,
    required this.synopsis,
    this.publishedDate,
    required this.authorFirst,
    required this.authorLast,
    required this.coverImageUrl,
    this.genres = const [],
  });

  // For backend collection API (uses bID, authorF, authorL format)
  factory Book.fromBackendJson(Map<String, dynamic> json) {
    return Book(
      id: json['bID'] as String,
      title: json['title'] as String,
      synopsis: json['synopsis'] ?? '',
      publishedDate: json['date'] != null ? DateTime(json['date'] as int) : null,
      authorFirst: json['authorF'] as String,
      authorLast: json['authorL'] as String,
      genres: json['genre'] != null && json['genre'] != ''
          ? [json['genre'] as String]
          : [],
      coverImageUrl: json['image'] as String? ?? '',
    );
  }

  // For OpenLibrary search API
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['bid'] as String? ?? json['bID'] as String,
      title: json['title'] as String,
      synopsis: json['synopsis'] as String? ?? json['sypnosis'] as String? ?? '',
      publishedDate: json['date'] != null
          ? (json['date'] is int
              ? DateTime(json['date'] as int)
              : DateTime.parse(json['date'] as String))
          : null,
      authorFirst: json['authorf'] as String? ?? json['authorF'] as String? ?? '',
      authorLast: json['authorl'] as String? ?? json['authorL'] as String? ?? '',
      genres: json['genre'] != null && json['genre'] != ''
          ? (json['genre'] is List
              ? (json['genre'] as List).cast<String>()
              : [json['genre'] as String])
          : [],
      coverImageUrl: json['image'] as String? ?? json['coverImageUrl'] as String? ?? '',
    );
  }

  // For backend API (AddBookToCollection format)
  Map<String, dynamic> toBackendJson() {
    return {
      'bID': id,
      'title': title,
      'authorF': authorFirst,
      'authorL': authorLast,
      'date': publishedDate?.year,
      'genre': genres.isNotEmpty ? genres.first : '',
      'image': coverImageUrl,
    };
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
      'publishedDate': publishedDate?.toIso8601String(),
    };
  }
}
