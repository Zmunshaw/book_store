import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseURL = 'http://127.0.0.1:8000';

  Future<String> getToken(String username, String password) async {
    try {
      print('Starting Await');
      final response = await http.post(
        Uri.parse('$baseURL/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            //json.encode(<String, dynamic>{
            //   "uName": username,
            //   "uPass": password,
            // }),
            jsonEncode(<String, dynamic>{"uName": username, "uPass": password}),
      );
      //final response = await http.get(Uri.parse('$baseURL/books/lord'));
      print('Await finished');
      String bod = response.body;
      if (response.statusCode == 200) {
        print('Attempting return as json');
        print('Response $bod');
        return response
            .body; // Error Found, difference in string vs json string
      } else {
        print("Response not 200");
        return 'Login Error! $bod';
      }
    } catch (Erro) {
      print("Catch Error occurred: $Erro");
      return 'Login error! $Erro';
    }
  }

  // factory UserService() {
  //   return UserService();
  // }
}
