import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseURL = 'http://127.0.0.1:8000';

  Future<String> getToken(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseURL/users/login/'),
      body: jsonEncode(<String, dynamic>{'uName': username, 'uPass': password}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      //throw Exception('Login Error!');
      return 'Login Error! $response';
    }
  }

  factory UserService() {
    return UserService();
  }
}
