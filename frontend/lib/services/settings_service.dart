import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class SettingsService {
  static final Logger _logger = Logger();
  static SharedPreferences? _prefs;

  // Keys for storing settings
  static const String _keyDarkMode = 'dark_mode_enabled';
  static const String _keyNotifications = 'notifications_enabled';
  static const String _keyLanguage = 'selected_language';
  static const String _keyFontSize = 'font_size';

  /// Initialize the settings service
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _logger.i('SettingsService initialized');
  }

  /// Get dark mode setting
  static bool getDarkMode() {
    return _prefs?.getBool(_keyDarkMode) ?? false;
  }

  /// Set dark mode setting
  static Future<bool> setDarkMode(bool enabled) async {
    final result = await _prefs?.setBool(_keyDarkMode, enabled) ?? false;
    _logger.i('Dark mode ${enabled ? 'enabled' : 'disabled'}');
    return result;
  }

  /// Get notifications enabled setting
  static bool getNotificationsEnabled() {
    return _prefs?.getBool(_keyNotifications) ?? true;
  }

  /// Set notifications enabled setting
  static Future<bool> setNotificationsEnabled(bool enabled) async {
    final result = await _prefs?.setBool(_keyNotifications, enabled) ?? false;
    _logger.i('Notifications ${enabled ? 'enabled' : 'disabled'}');
    return result;
  }

  /// Get selected language
  static String getLanguage() {
    return _prefs?.getString(_keyLanguage) ?? 'English';
  }

  /// Set selected language
  static Future<bool> setLanguage(String language) async {
    final result = await _prefs?.setString(_keyLanguage, language) ?? false;
    _logger.i('Language set to: $language');
    return result;
  }

  /// Get font size
  static double getFontSize() {
    return _prefs?.getDouble(_keyFontSize) ?? 16.0;
  }

  /// Set font size
  static Future<bool> setFontSize(double size) async {
    final result = await _prefs?.setDouble(_keyFontSize, size) ?? false;
    _logger.i('Font size set to: $size');
    return result;
  }

  /// Clear all settings (for testing or reset)
  static Future<bool> clearAll() async {
    final result = await _prefs?.clear() ?? false;
    _logger.i('All settings cleared');
    return result;
  }
}
