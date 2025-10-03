import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import '../../services/auth_service.dart';
import '../home/doctor_home_screen.dart';
import '../home/nurse_home_screen.dart';
import '../home/supervisor_home_screen.dart';
import '../home/student_home_screen.dart';

class LoginCredentialsScreen extends StatefulWidget {
  final String role;

  const LoginCredentialsScreen({super.key, required this.role});

  @override
  State<LoginCredentialsScreen> createState() => _LoginCredentialsScreenState();
}

class _LoginCredentialsScreenState extends State<LoginCredentialsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Validate with hardcoded credentials
    if (AuthService.validateLogin(widget.role, email, password)) {
      // Navigate to appropriate home screen based on role
      Widget homeScreen;
      switch (widget.role.toLowerCase()) {
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
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid credentials. Use ${AuthService.getEmailForRole(widget.role)} with password: 12345678',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative curved background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 200),
                painter: CurvedHeaderPainter(),
              ),
            ),

            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),

                      // Title
                      const Text(
                        'Welcome Back!',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A6FA5),
                          fontFamily: 'serif',
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Precision in every move, success in\nevery surgery !',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),

                      const SizedBox(height: 50),

                      // Username Field
                      _buildTextField(
                        controller: _usernameController,
                        hint: 'User name',
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 16),

                      // Password Field
                      _buildTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        onTogglePassword: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      // Remember me checkbox
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFF4A6FA5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Remember me',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Log in button
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _handleLogin();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A6FA5),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Forgot password link
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFF4A6FA5),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Divider with "or"
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Social login buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(
                            icon: Icons.facebook,
                            color: const Color(0xFF1877F2),
                            onTap: () {
                              // TODO: Facebook login
                            },
                          ),
                          const SizedBox(width: 20),
                          _buildSocialButton(
                            icon: Icons.apple,
                            color: Colors.black,
                            onTap: () {
                              // TODO: Apple login
                            },
                          ),
                          const SizedBox(width: 20),
                          _buildSocialButton(
                            icon: Icons.g_mobiledata,
                            color: const Color(0xFFDB4437),
                            onTap: () {
                              // TODO: Google login
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Sign up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Color(0xFF4A6FA5),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

class CurvedHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFFE8EEF5), Colors.white.withOpacity(0.3)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 1.2,
        size.width,
        size.height * 0.7,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
