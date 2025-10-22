// lib/contact_us_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// صفحات الهوم لكل دور (استخدام احتياطي لو ما نقدر نرجع بـ pop)
import 'student_home_page.dart';
import 'nurse_home_page.dart';
import 'doctor_home_page.dart';
import 'supervisor_home_page.dart';

// نحتاج الـ enum UserRole فقط
import 'quiz_score_page.dart' show UserRole;

class ContactUsPage extends StatefulWidget {
  /// نترك الـ role عشان لو ما قدرنا نرجع بـ pop نرجّع المستخدم لصفحة الهوم الخاصة بدوره
  final UserRole role;

  const ContactUsPage({
    super.key,
    this.role = UserRole.student,
  });

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController _messageController = TextEditingController();

  static const Color brandBlue = Color(0xFF2F5B89);

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // يرجّع صفحة الهوم المناسبة حسب الدور (لو احتجناها)
  Widget _homeForRole() {
    switch (widget.role) {
      case UserRole.student:
        return const StudentHomePage();
      case UserRole.nurse:
        return const NurseHomePage();
      case UserRole.doctor:
        return const DoctorHomePage();
      case UserRole.supervisor:
        return const SupervisorHomePage();
    }
  }

  void _goBack() {
    // لو نقدر نرجع للصفحة السابقة بـ pop — نرجع
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    // لو ما فيه صفحة سابقة (stack فاضي) نرجع لصفحة الهوم حسب الدور
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => _homeForRole()),
    );
  }

  void _handleSubmit() {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please write your message before submitting."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // هنا منطق الإرسال (API/email) لاحقًا
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Your message has been sent successfully!"),
        backgroundColor: brandBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===== AppBar بسهم رجوع =====
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: brandBlue),
          onPressed: _goBack,
        ),
        title: Text(
          "VRVITA",
          style: GoogleFonts.quintessential(
            color: brandBlue,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      // ===== بدون Drawer =====
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contact us",
              style: GoogleFonts.quintessential(
                fontSize: 28,
                color: brandBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We are excited to hear from you! Whether you have questions, suggestions, or need support, our team is here to assist you.",
              style: GoogleFonts.openSans(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // حقل الرسالة
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Your messages",
                hintStyle: GoogleFonts.openSans(color: Colors.grey.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: brandBlue),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),

            // زر الإرسال
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Submit",
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // معلومات التواصل
            Text(
              "General Inquiries",
              style: GoogleFonts.quintessential(
                fontSize: 22,
                color: brandBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Saudi Arabia - Madinah\n"
                  "King Faisal Specialist Hospital & Research Centre\n"
                  "Madinah, Saudi Arabia\n"
                  "Email: info@VRVITA.com\n"
                  "Phone: +966 14 820 0000",
              style: GoogleFonts.openSans(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            Text(
              "Social Media",
              style: GoogleFonts.quintessential(
                fontSize: 20,
                color: brandBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "• Facebook: @VRVITA\n"
                  "• Twitter: @VRVITA\n"
                  "• LinkedIn: VRVITA\n"
                  "• Instagram: @VRVITA",
              style: GoogleFonts.openSans(fontSize: 15, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
