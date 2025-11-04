import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'new_password_page.dart';
import 'otp_verification_page.dart'; // ✅ Add OTP verification

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  static const Color dark = Color(0xFF2F5B89);
  static const Color fieldFill = Color(0xFFDCE4F0);
  static const Color fieldBorder = Color(0xFF6C737F);

  final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  String? _vEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!_emailRe.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            const _TopWedge(),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 18,
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: dark,
                            size: 26,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Forgot Password',
                        style: GoogleFonts.quintessential(
                          fontSize: 30,
                          color: dark,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter your email and we’ll send you a reset link.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        validator: _vEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email address',
                          hintText: 'example@mail.com',
                          filled: true,
                          fillColor: fieldFill,
                          prefixIcon: const Icon(
                            Icons.mail_outline,
                            color: Colors.black87,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: fieldBorder,
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: dark,
                              width: 1.4,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.4,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: dark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Navigate to OTP verification
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OtpVerificationPage(
                                    email: _emailController.text.trim(),
                                    purpose: 'forgot_password',
                                    onVerified: () {
                                      // After OTP is verified, go to new password page
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const NewPasswordPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Send OTP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
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
}

class _TopWedge extends StatelessWidget {
  const _TopWedge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      width: double.infinity,
      child: CustomPaint(painter: _WedgePainter()),
    );
  }
}

class _WedgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = const Color(0xFFF2F3F6);
    final w = size.width, h = size.height;

    final wedge = Path()
      ..moveTo(w, 0)
      ..lineTo(w * 0.62, 0)
      ..quadraticBezierTo(w * 0.34, h * 0.58, 0, h * 0.78)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(wedge, fill);

    final stroke = Paint()
      ..color = const Color(0xFFE1E3E6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final slant = Path()
      ..moveTo(8, h * 0.78)
      ..quadraticBezierTo(w * 0.45, h * 0.48, w - 8, h * 0.12);
    canvas.drawPath(slant, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
