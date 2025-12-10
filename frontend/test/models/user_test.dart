import 'package:flutter_test/flutter_test.dart';
import 'package:book_store/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('User constructor creates instance correctly', () {
      final dateOfBirth = DateTime(1990, 5, 15);
      final user = User(
        id: '123',
        username: 'johndoe',
        firstName: 'John',
        lastName: 'Doe',
        dateOfBirth: dateOfBirth,
      );

      expect(user.id, '123');
      expect(user.username, 'johndoe');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.dateOfBirth, dateOfBirth);
    });

    test('User can be created with null firstName and lastName', () {
      final dateOfBirth = DateTime(1990, 5, 15);
      final user = User(
        id: '123',
        username: 'johndoe',
        dateOfBirth: dateOfBirth,
      );

      expect(user.id, '123');
      expect(user.username, 'johndoe');
      expect(user.firstName, isNull);
      expect(user.lastName, isNull);
      expect(user.dateOfBirth, dateOfBirth);
    });

    test('User.fromJson creates User from valid JSON', () {
      final json = {
        'iud': '123',
        'uname': 'johndoe',
        'fname': 'John',
        'lname': 'Doe',
        'dob': '1990-05-15T00:00:00.000',
      };

      final user = User.fromJson(json);

      expect(user.id, '123');
      expect(user.username, 'johndoe');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.dateOfBirth, DateTime(1990, 5, 15));
    });

    test('User.fromJson handles null firstName and lastName', () {
      final json = {
        'iud': '123',
        'uname': 'johndoe',
        'fname': null,
        'lname': null,
        'dob': '1990-05-15T00:00:00.000',
      };

      final user = User.fromJson(json);

      expect(user.id, '123');
      expect(user.username, 'johndoe');
      expect(user.firstName, isNull);
      expect(user.lastName, isNull);
    });

    test('User.toJson converts User to JSON correctly', () {
      final dateOfBirth = DateTime(1990, 5, 15);
      final user = User(
        id: '123',
        username: 'johndoe',
        firstName: 'John',
        lastName: 'Doe',
        dateOfBirth: dateOfBirth,
      );

      final json = user.toJson();

      expect(json['uid'], '123');
      expect(json['uname'], 'johndoe');
      expect(json['fname'], 'John');
      expect(json['lname'], 'Doe');
      expect(json['dob'], dateOfBirth);
    });

    test('User.toJson handles null firstName and lastName', () {
      final dateOfBirth = DateTime(1990, 5, 15);
      final user = User(
        id: '123',
        username: 'johndoe',
        dateOfBirth: dateOfBirth,
      );

      final json = user.toJson();

      expect(json['uid'], '123');
      expect(json['uname'], 'johndoe');
      expect(json['fname'], isNull);
      expect(json['lname'], isNull);
      expect(json['dob'], dateOfBirth);
    });

    test('User fromJson and toJson round trip', () {
      final originalJson = {
        'iud': '123',
        'uname': 'johndoe',
        'fname': 'John',
        'lname': 'Doe',
        'dob': '1990-05-15T00:00:00.000',
      };

      final user = User.fromJson(originalJson);
      final resultJson = user.toJson();

      expect(resultJson['uid'], originalJson['iud']);
      expect(resultJson['uname'], originalJson['uname']);
      expect(resultJson['fname'], originalJson['fname']);
      expect(resultJson['lname'], originalJson['lname']);
    });
  });
}
