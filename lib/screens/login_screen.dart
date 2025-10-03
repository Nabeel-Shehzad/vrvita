import 'package:flutter/material.dart';
import 'auth/signup_screen.dart';
import 'auth/login_credentials_screen.dart';

class LoginScreen extends StatelessWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -50,
              right: -50,
              child: _buildDecorativeCircle(150, const Color(0xFF4A6FA5)),
            ),
            Positioned(
              top: -30,
              right: -20,
              child: _buildDecorativeCircle(100, const Color(0xFF7BA5D8)),
            ),
            Positioned(
              bottom: -50,
              right: -50,
              child: _buildDecorativeCircle(150, const Color(0xFF4A6FA5)),
            ),
            Positioned(
              bottom: -30,
              right: -20,
              child: _buildDecorativeCircle(100, const Color(0xFF7BA5D8)),
            ),

            // Main content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 2),

                    // VRVITA Logo/Title
                    const Text(
                      'VRVITA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 80),

                    // Sign up button
                    SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          print('Selected role: $role');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(role: role),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7BA5D8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'sign up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Log in button
                    SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          print('Log in button pressed'); // Debug print
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoginCredentialsScreen(role: role),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7BA5D8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
