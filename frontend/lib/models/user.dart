class User {
  final String uID;
  final String uName;
  final String fName;
  final String lName;
  final DateTime dob;

  User({
    required this.uID,
    required this.uName,
    required this.fName,
    required this.lName,
    required this.dob,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uID: json['uID'] as String,
      uName: json['uName'] as String,
      fName: json['fName'] as String,
      lName: json['lName'] as String,
      dob: DateTime.parse(json['dob'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uID': uID,
      'uName': uName,
      'fName': fName,
      'lName': lName,
      'dob': dob.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
    };
  }
}

class UserCreate {
  final String fName;
  final String lName;
  final DateTime dob;
  final String uName;
  final String uPass;

  UserCreate({
    required this.fName,
    required this.lName,
    required this.dob,
    required this.uName,
    required this.uPass,
  });

  Map<String, dynamic> toJson() {
    return {
      'fName': fName,
      'lName': lName,
      'dob': dob.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
      'uName': uName,
      'uPass': uPass,
    };
  }
}

class UserLogin {
  final String uName;
  final String uPass;

  UserLogin({
    required this.uName,
    required this.uPass,
  });

  Map<String, dynamic> toJson() {
    return {
      'uName': uName,
      'uPass': uPass,
    };
  }
}
