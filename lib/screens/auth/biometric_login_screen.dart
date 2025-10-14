import 'package:flutter/material.dart';
import 'login_credentials_screen.dart';
import '../../services/auth_service.dart';
import '../../services/auth_state_service.dart';
import '../home/doctor_home_screen.dart';
import '../home/nurse_home_screen.dart';
import '../home/supervisor_home_screen.dart';
import '../home/student_home_screen.dart';

class BiometricLoginScreen extends StatelessWidget {
  final String role;

  const BiometricLoginScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7BA5D8), Color(0xFF4A6FA5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const Spacer(),

                // Logo/Title
                const Text(
                  'VRVITA',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 60),

                // Biometric Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fingerprint,
                    size: 80,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  'Login with Biometrics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Use Face ID or Touch ID to login quickly',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),

                const Spacer(),

                // Face ID Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Simulate Face ID authentication
                      _showBiometricDialog(context, 'Face ID', Icons.face);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4A6FA5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.face, size: 28),
                    label: const Text(
                      'Login with Face ID',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Touch ID Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Simulate Touch ID authentication
                      _showBiometricDialog(
                        context,
                        'Touch ID',
                        Icons.fingerprint,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4A6FA5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.fingerprint, size: 28),
                    label: const Text(
                      'Login with Touch ID',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Skip to traditional login
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LoginCredentialsScreen(role: role),
                      ),
                    );
                  },
                  child: const Text(
                    'Use Email/Password Instead',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBiometricDialog(
    BuildContext context,
    String method,
    IconData icon,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 60, color: const Color(0xFF4A6FA5)),
              const SizedBox(height: 20),
              Text(
                'Authenticating with $method',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A6FA5)),
              ),
            ],
          ),
        );
      },
    );

    // Load saved user data
    await AuthService.initFromSavedData();
    final savedData = await AuthStateService.getSavedUserData();

    // Mark as logged in
    await AuthStateService.saveLoginState(
      username: savedData['username'] ?? 'User',
      email: savedData['email'] ?? 'user@email.com',
      role: savedData['role'] ?? role,
    );

    // Simulate biometric authentication delay
    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;
    Navigator.of(context).pop(); // Close dialog

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$method authentication successful!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );

    // Navigate to home screen based on role
    await Future.delayed(const Duration(milliseconds: 500));

    if (!context.mounted) return;

    final userRole = savedData['role'] ?? role;
    Widget homeScreen;

    switch (userRole.toLowerCase()) {
      case 'doctor':
        homeScreen = const DoctorHomeScreen();
        break;
      case 'nurse':
        homeScreen = const NurseHomeScreen();
        break;
      case 'team supervisor':
        homeScreen = const SupervisorHomeScreen();
        break;
      case 'training student':
        homeScreen = const StudentHomeScreen();
        break;
      default:
        homeScreen = const DoctorHomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => homeScreen),
    );
  }
}
