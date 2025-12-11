import 'package:book_store/models/user.dart';
import 'package:book_store/models/token.dart';
import 'package:book_store/services/api_service.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final Logger _logger = Logger();
  static String? _accessToken;
  static const String _tokenKey = 'access_token';

  static String? get accessToken => _accessToken;

  /// Initialize AuthService and load saved token
  static Future<void> init() async {
    await _loadToken();
  }

  /// Load access token from storage
  static Future<void> _loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString(_tokenKey);
      if (_accessToken != null) {
        _logger.i('Access token loaded from storage');
      }
    } catch (e) {
      _logger.e('Error loading token: $e');
    }
  }

  /// Save access token to storage
  static Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      _logger.i('Access token saved to storage');
    } catch (e) {
      _logger.e('Error saving token: $e');
    }
  }

  /// Clear access token from storage
  static Future<void> _clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      _logger.i('Access token cleared from storage');
    } catch (e) {
      _logger.e('Error clearing token: $e');
    }
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final userLogin = UserLogin(
        uName: username,
        uPass: password,
      );

      final response = await ApiService.post(
        endpoint: '/user/login',
        body: userLogin.toJson(),
      );

      if (response['success']) {
        final token = Token.fromJson(response['data']);
        _accessToken = token.accessToken;
        await _saveToken(token.accessToken);

        _logger.i('Login successful for user: $username');

        return {
          'success': true,
          'token': token,
          'message': 'Login successful',
        };
      } else {
        _logger.w('Login failed: ${response['error']}');
        return {
          'success': false,
          'error': response['error'],
        };
      }
    } catch (e) {
      _logger.e('Error during login: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String username,
    required String password,
  }) async {
    try {
      final userCreate = UserCreate(
        fName: firstName,
        lName: lastName,
        dob: dateOfBirth,
        uName: username,
        uPass: password,
      );

      final response = await ApiService.post(
        endpoint: '/user/create',
        body: userCreate.toJson(),
      );

      if (response['success']) {
        final user = User.fromJson(response['data']);

        _logger.i('User created successfully: ${user.uName}');

        final loginResult = await login(
          username: username,
          password: password,
        );

        if (loginResult['success']) {
          return {
            'success': true,
            'user': user,
            'message': 'Registration successful',
          };
        } else {
          return {
            'success': true,
            'user': user,
            'message': 'Registration successful, but auto-login failed. Please log in manually.',
          };
        }
      } else {
        _logger.w('Registration failed: ${response['error']}');
        return {
          'success': false,
          'error': response['error'],
        };
      }
    } catch (e) {
      _logger.e('Error during registration: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }

  static Future<void> logout() async {
    _accessToken = null;
    await _clearToken();
    _logger.i('User logged out');
  }

  static bool isLoggedIn() {
    return _accessToken != null;
  }

  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      if (!isLoggedIn()) {
        return {
          'success': false,
          'error': 'Not logged in',
        };
      }

      final response = await ApiService.put(
        endpoint: '/user/change-password',
        body: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
        token: _accessToken,
      );

      if (response['success']) {
        _logger.i('Password changed successfully');
        return {
          'success': true,
          'message': 'Password changed successfully',
        };
      } else {
        _logger.w('Password change failed: ${response['error']}');
        return {
          'success': false,
          'error': response['error'],
        };
      }
    } catch (e) {
      _logger.e('Error changing password: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }

  static Future<Map<String, dynamic>> deleteAccount() async {
    try {
      if (!isLoggedIn()) {
        return {
          'success': false,
          'error': 'Not logged in',
        };
      }

      final response = await ApiService.delete(
        endpoint: '/user/delete-account',
        token: _accessToken,
      );

      if (response['success']) {
        _logger.i('Account deleted successfully');
        await logout(); // Clear the token after deletion
        return {
          'success': true,
          'message': 'Account deleted successfully',
        };
      } else {
        _logger.w('Account deletion failed: ${response['error']}');
        return {
          'success': false,
          'error': response['error'],
        };
      }
    } catch (e) {
      _logger.e('Error deleting account: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }
}
