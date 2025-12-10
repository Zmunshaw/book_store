class User {
  final String id;
  final String username;
  final String? firstName;
  final String? lastName;
  final DateTime dateOfBirth;

  User({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    required this.dateOfBirth,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['iud'] as String,
      username: json['uname'] as String,
      firstName: json['fname'] as String?,
      lastName: json['lname'] as String?,
      dateOfBirth: DateTime.parse(json['dob'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'uname': username,
      'fname': firstName,
      'lname': lastName,
      'dob': dateOfBirth,
    };
  }
}
