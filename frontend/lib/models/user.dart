class User {
  final String id;
  final String email;
  final String username;
  final String? displayName;
  final DateTime createdAt;
  final List<String> favoriteBookIds;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.displayName,
    required this.createdAt,
    this.favoriteBookIds = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      favoriteBookIds:
          (json['favoriteBookIds'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'displayName': displayName,
      'createdAt': createdAt.toIso8601String(),
      'favoriteBookIds': favoriteBookIds,
    };
  }
}
