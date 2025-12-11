class User {
  // final String userID;
  // final String firstName;
  // final String lastName;
  // final DateTime dateOfBirth;
  final String username;
  final String password;

  User({
    // required this.userID,
    required this.username,
    // required this.firstName,
    // required this.lastName,
    // required this.dateOfBirth,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // userID: json['userID'] as String,
      // firstName: json['firstName'] as String,
      username: json['username'] as String,
      // lastName: json['lastName'] as String,
      password: json['password'] as String,
      // dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'userID': userID,
      // 'firstName': firstName,
      'username': username,
      // 'lastName': lastName,
      // 'dateOfBirth': dateOfBirth.toIso8601String(),
      'password': password,
    };
  }
}
