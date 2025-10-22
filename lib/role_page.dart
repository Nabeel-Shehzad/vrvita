// lib/role_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 👇 المتغيّر العام للرول
import 'global.dart' as globals;

// 👇 صفحات الهوم لكل دور
import 'supervisor_home_page.dart';
import 'doctor_home_page.dart';
import 'nurse_home_page.dart';
import 'student_home_page.dart';

class RolePage extends StatelessWidget {
  const RolePage({super.key});

  void _selectRole(BuildContext context, String role) {
    // خزّن الدور عالميًا
    globals.TypeUser = role;

    // وجّه لصفحة الهوم المناسبة
    switch (role) {
      case 'supervisor':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SupervisorHomePage()),
        );
        break;
      case 'doctor':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DoctorHomePage()),
        );
        break;
      case 'nurse':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NurseHomePage()),
        );
        break;
      case 'student':
      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentHomePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF2F5B89);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              IconButton(
                icon: const Icon(Icons.arrow_back, color: blue, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Choose your Role',
                  style: GoogleFonts.quintessential(
                    fontSize: 30,
                    color: blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              _RoleCard(
                label: 'Team Supervisor',
                imagePath: 'assets/images/role_supervisor.jpg',
                onTap: () => _selectRole(context, 'supervisor'),
              ),
              const SizedBox(height: 20),

              _RoleCard(
                label: 'Doctor',
                imagePath: 'assets/images/role_doctor.jpg',
                onTap: () => _selectRole(context, 'doctor'),
              ),
              const SizedBox(height: 20),

              _RoleCard(
                label: 'Nurse',
                imagePath: 'assets/images/role_nurse.jpg',
                onTap: () => _selectRole(context, 'nurse'),
              ),
              const SizedBox(height: 20),

              _RoleCard(
                label: 'Training Student',
                imagePath: 'assets/images/role_student.jpg',
                onTap: () => _selectRole(context, 'student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;
  const _RoleCard({
    required this.label,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade400, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              Container(color: Colors.white.withOpacity(0.6)),
              Center(
                child: Text(
                  label,
                  style: GoogleFonts.quintessential(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
