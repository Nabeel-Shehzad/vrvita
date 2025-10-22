import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_page.dart' as su;
import 'login_page.dart' as li;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const dark = Color(0xFF2F5B89);
    const light = Color(0xFF9FBEEC);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: dark, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Stack(
          children: [
            Positioned(
              top: -42,
              left: -42,
              child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  color: dark,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: -70,
            right: -70,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: light,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "VRVITA",
                  style: GoogleFonts.quintessential(
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                _PrimaryButton(
                  text: "Sign Up",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const su.SignUpPage()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _PrimaryButton(
                  text: "Log In",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const li.LoginPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _PrimaryButton({required this.text, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: 260,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF9FBEEC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.quintessential(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}