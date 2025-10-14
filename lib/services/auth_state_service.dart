import 'package:shared_preferences/shared_preferences.dart';

class AuthStateService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyHasLoggedInBefore = 'has_logged_in_before';
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';
  static const String _keyRole = 'role';

  // Check if user has ever logged in before
  static Future<bool> hasLoggedInBefore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasLoggedInBefore) ?? false;
  }

  // Check if user is currently logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Save login state after successful authentication
  static Future<void> saveLoginState({
    required String username,
    required String email,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setBool(_keyHasLoggedInBefore, true);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyRole, role);
  }

  // Get saved user data
  static Future<Map<String, String?>> getSavedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString(_keyUsername),
      'email': prefs.getString(_keyEmail),
      'role': prefs.getString(_keyRole),
    };
  }

  // Logout - clear only the current session, keep the "has logged in before" flag
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    // Don't clear _keyHasLoggedInBefore - we want to remember they've logged in before
    // Don't clear username, email, role - we'll use them for biometric login
  }

  // Complete logout - clear all data (for testing or complete reset)
  static Future<void> completeLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
