import 'package:flutter_test/flutter_test.dart';
import 'package:book_store/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('User constructor creates instance correctly', () {
      final dateOfBirth = DateTime(1990, 5, 15);
      final user = User(
        uID: '123',
        uName: 'johndoe',
        fName: 'John',
        lName: 'Doe',
        dob: dateOfBirth,
      );

      expect(user.uID, '123');
      expect(user.uName, 'johndoe');
      expect(user.fName, 'John');
      expect(user.lName, 'Doe');
      expect(user.dob, dateOfBirth);
    });

    test('User.fromJson creates User from valid JSON', () {
      final json = {
        'uID': '123',
        'uName': 'johndoe',
        'fName': 'John',
        'lName': 'Doe',
        'dob': '1990-05-15',
      };

      final user = User.fromJson(json);

      expect(user.uID, '123');
      expect(user.uName, 'johndoe');
      expect(user.fName, 'John');
      expect(user.lName, 'Doe');
      expect(user.dob, DateTime(1990, 5, 15));
    });

    test('User.toJson converts User to JSON correctly', () {
      final dateOfBirth = DateTime(1990, 5, 15);
      final user = User(
        uID: '123',
        uName: 'johndoe',
        fName: 'John',
        lName: 'Doe',
        dob: dateOfBirth,
      );

      final json = user.toJson();

      expect(json['uID'], '123');
      expect(json['uName'], 'johndoe');
      expect(json['fName'], 'John');
      expect(json['lName'], 'Doe');
      expect(json['dob'], '1990-05-15');
    });

    test('User fromJson and toJson round trip', () {
      final originalJson = {
        'uID': '123',
        'uName': 'johndoe',
        'fName': 'John',
        'lName': 'Doe',
        'dob': '1990-05-15',
      };

      final user = User.fromJson(originalJson);
      final resultJson = user.toJson();

      expect(resultJson['uID'], originalJson['uID']);
      expect(resultJson['uName'], originalJson['uName']);
      expect(resultJson['fName'], originalJson['fName']);
      expect(resultJson['lName'], originalJson['lName']);
      expect(resultJson['dob'], originalJson['dob']);
    });
  });
}
