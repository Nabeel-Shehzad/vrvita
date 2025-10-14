import 'auth_state_service.dart';

// Authentication service - accepts any credentials
class AuthService {
  // Store the current logged-in user information
  static String? currentUsername;
  static String? currentEmail;
  static String? currentRole;

  // Initialize from saved data
  static Future<void> initFromSavedData() async {
    final savedData = await AuthStateService.getSavedUserData();
    currentUsername = savedData['username'];
    currentEmail = savedData['email'];
    currentRole = savedData['role'];
  }

  static Future<bool> validateLogin(
    String role,
    String email,
    String password,
  ) async {
    // Accept any username and password
    // Store the credentials for display
    currentEmail = email;
    currentRole = role;

    // Extract username from email or use the email itself
    if (email.contains('@')) {
      currentUsername = email.split('@')[0];
    } else {
      currentUsername = email;
    }

    // Save to persistent storage
    await AuthStateService.saveLoginState(
      username: currentUsername!,
      email: currentEmail!,
      role: currentRole!,
    );

    // Always return true - no restrictions
    return true;
  }

  static String getEmailForRole(String role) {
    return currentEmail ?? '';
  }

  static String getCurrentUsername() {
    return currentUsername ?? 'User';
  }

  static String getDisplayName() {
    // Special handling for 'Nabeel'
    if (currentUsername?.toLowerCase() == 'nabeel') {
      return 'Nabeel';
    }
    // Capitalize first letter
    if (currentUsername != null && currentUsername!.isNotEmpty) {
      return currentUsername![0].toUpperCase() + currentUsername!.substring(1);
    }
    return 'User';
  }

  static Future<void> logout() async {
    await AuthStateService.logout();
    // Keep the data for biometric login but mark as logged out
  }
}
