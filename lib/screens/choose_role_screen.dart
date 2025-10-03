import 'package:flutter/material.dart';
import 'login_screen.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

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
              left: -50,
              child: _buildDecorativeCircle(150, const Color(0xFF4A6FA5)),
            ),
            Positioned(
              top: -30,
              left: -20,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),

                  // Title
                  const Text(
                    'Choose your Role',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B8CB8),
                      fontFamily: 'serif',
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Role buttons
                  _buildRoleButton(
                    context,
                    'Team Supervisor',
                    'assets/images/supervisor.jpg',
                  ),
                  const SizedBox(height: 20),

                  _buildRoleButton(
                    context,
                    'Doctor',
                    'assets/images/doctor.jpg',
                  ),
                  const SizedBox(height: 20),

                  _buildRoleButton(context, 'Nurse', 'assets/images/nurse.jpg'),
                  const SizedBox(height: 20),

                  _buildRoleButton(
                    context,
                    'Training Student',
                    'assets/images/student.jpg',
                  ),

                  const SizedBox(height: 60),
                ],
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

  Widget _buildRoleButton(BuildContext context, String role, String imagePath) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: const Color(0xFF6B8CB8), width: 2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(35),
          onTap: () {
            // Navigate to login screen with selected role
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen(role: role)),
            );
          },
          child: Center(
            child: Text(
              role,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
