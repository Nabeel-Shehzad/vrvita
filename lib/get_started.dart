// lib/get_started.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart'; // ✅ بدل role_page إلى home_page

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F5B89),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png", width: 160),
                const SizedBox(height: 20),
                Text(
                  "“وَمَنْ أَحْيَاهَا فَكَأَنَّمآ أَحْيَا النَّاسَ جَمِيعًا”",
                  style: GoogleFonts.youngSerif(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Text(
                  "A virtual reality medical application designed for hospitals, enabling healthcare professionals to enhance surgical procedures, train effectively, and improve patient outcomes using immersive VR technology.",
                  style: GoogleFonts.yanoneKaffeesatz(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9FBEEC),
                    minimumSize: const Size(220, 50),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()), // ✅ يروح للهوم
                    );
                  },
                  child: Text(
                    "Get started!",
                    style: GoogleFonts.yanoneKaffeesatz(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
