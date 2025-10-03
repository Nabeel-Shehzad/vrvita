// Hardcoded user credentials for testing
class AuthService {
  static const Map<String, Map<String, String>> userCredentials = {
    'doctor': {'email': 'doctor@gmail.com', 'password': '12345678'},
    'nurse': {'email': 'nurse@gmail.com', 'password': '12345678'},
    'team supervisor': {
      'email': 'supervisor@gmail.com',
      'password': '12345678',
    },
    'training student': {'email': 'student@gmail.com', 'password': '12345678'},
  };

  static bool validateLogin(String role, String email, String password) {
    final roleKey = role.toLowerCase();
    if (userCredentials.containsKey(roleKey)) {
      return userCredentials[roleKey]!['email'] == email &&
          userCredentials[roleKey]!['password'] == password;
    }
    return false;
  }

  static String getEmailForRole(String role) {
    final roleKey = role.toLowerCase();
    return userCredentials[roleKey]?['email'] ?? '';
  }
}
