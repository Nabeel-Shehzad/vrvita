// lib/signup_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// المتغيرات العامة
import 'global.dart' as globals;

// صفحات الهوم لكل دور
import 'student_home_page.dart';
import 'doctor_home_page.dart';
import 'nurse_home_page.dart';
import 'supervisor_home_page.dart';

// صفحة اختيار الدور
import 'role_page.dart';

// (اختياري) صفحة تسجيل الدخول
import 'login_page.dart';

// ✅ OTP Verification
import 'otp_verification_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const Color dark = Color(0xFF2F5B89);
  static const Color fieldFill = Color(0xFFDCE4F0);
  static const Color fieldBorder = Color(0xFF6C737F);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _fullNameCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  // Regex rules
  final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  final _fullNameRe = RegExp(r'^[A-Za-z]+\s+[A-Za-z]+.*$'); // على الأقل اسمين
  final _idRe = RegExp(r'^\d{9}$'); // 9 أرقام
  final _phoneRe = RegExp(
    r'^(?:05\d{8}|\+9665\d{8}|009665\d{8})$',
  ); // صيغ السعودية
  final _hasSpecial = RegExp(
    r'''[!@#\$%^&*()\-\_=+\{\}\[\]:;"'<>,\.?\/\\|~`]''',
  );

  // Validators
  String? _vName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Full name is required';
    if (!_fullNameRe.hasMatch(v.trim())) {
      return 'Full name: enter at least two names (e.g., Zahra Ali)';
    }
    return null;
  }

  String? _vId(String? v) {
    if (v == null || v.isEmpty) return 'User ID is required';
    if (!_idRe.hasMatch(v)) return 'User ID must be exactly 9 digits';
    return null;
  }

  String? _vPhone(String? v) {
    if (v == null || v.isEmpty) return 'Phone number is required';
    if (!_phoneRe.hasMatch(v)) {
      return 'Use Saudi format (05XXXXXXXX or +9665XXXXXXXX)';
    }
    return null;
  }

  String? _vPassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8 || v.length > 12)
      return 'Password must be 8–12 characters';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Include lowercase letter';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Include uppercase letter';
    if (!RegExp(r'\d').hasMatch(v)) return 'Include number';
    if (!_hasSpecial.hasMatch(v)) return 'Include special symbol';
    return null;
  }

  String? _vEmail(String? v) {
    if (v == null || v.isEmpty) return 'Email is required';
    if (!_emailRe.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _idCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg, {Color bg = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _goToRoleHome(String name) {
    final role = globals.TypeUser.trim().toLowerCase();
    switch (role) {
      case "doctor":
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => DoctorHomePage(userName: name)),
          (r) => false,
        );
        return;
      case "student":
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => StudentHomePage(userName: name)),
          (r) => false,
        );
        return;
      case "nurse":
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => NurseHomePage(userName: name)),
          (r) => false,
        );
        return;
      case "supervisor":
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => SupervisorHomePage(userName: name)),
          (r) => false,
        );
        return;
      default:
        _showSnack("Please choose your role first", bg: Colors.red.shade700);
        return;
    }
  }

  Future<void> _submit() async {
    // تحقّق الحقول
    if (!_formKey.currentState!.validate()) {
      _showSnack("Please fix the highlighted fields", bg: Colors.red.shade700);
      return;
    }

    final name = _fullNameCtrl.text.trim();
    final email = _emailCtrl.text.trim();

    // ✅ Navigate to OTP verification page FIRST
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerificationPage(
          email: email,
          purpose: 'signup',
          onVerified: () async {
            // After OTP is verified, go back and then ask for role
            Navigator.pop(context); // Close OTP page

            // Now ask for role selection
            if (globals.TypeUser.isEmpty) {
              final before = globals.TypeUser;
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RolePage()),
              );
              if (globals.TypeUser.isEmpty || globals.TypeUser == before) {
                _showSnack(
                  "Please choose your role to continue",
                  bg: Colors.orange.shade700,
                );
                return;
              }
            }

            // Finally complete the signup
            _completeSignup(name);
          },
        ),
      ),
    );
  }

  void _completeSignup(String name) {
    // ✅ ثبّت حالة الحساب والجلسة + البيانات محليًا
    globals.isSignedUp = true; // صار عنده حساب
    globals.isLoggedIn = true; // جلسة فعّالة الآن
    globals.userDisplayName = name; // الاسم
    globals.registeredId = _idCtrl.text.trim(); // رقم المستخدم (9 أرقام)
    globals.biometricEnabled =
        true; // فعّل البصمة لمرات الدخول القادمة (اختياري)
    globals.TypeUser = globals.TypeUser.trim().toLowerCase(); // تأكيد الدور

    // رسالة نجاح
    _showSnack(
      "Signed up successfully! Redirecting to ${globals.TypeUser} dashboard…",
      bg: Colors.green.shade600,
    );

    // توجيه مباشر لصفحة الدور
    _goToRoleHome(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            _TopWedge(),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                            color: SignUpPage.dark,
                            size: 28,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Welcome To VRVITA',
                        style: GoogleFonts.quintessential(
                          color: SignUpPage.dark,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Achieve excellence in every step!',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      const SizedBox(height: 22),

                      _Field(
                        controller: _fullNameCtrl,
                        label: 'Full name',
                        hint: 'e.g., Zahra Ali',
                        icon: Icons.badge,
                        validator: _vName,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),

                      _Field(
                        controller: _idCtrl,
                        label: 'User ID',
                        hint: '9 digits',
                        icon: Icons.perm_identity,
                        validator: _vId,
                        keyboard: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),

                      _Field(
                        controller: _phoneCtrl,
                        label: 'Phone number',
                        hint: '05XXXXXXXX',
                        icon: Icons.phone,
                        keyboard: TextInputType.phone,
                        validator: _vPhone,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),

                      _Field(
                        controller: _passwordCtrl,
                        label: 'Password',
                        hint: '8–12 chars (Aa1@)',
                        icon: Icons.lock,
                        obscure: true,
                        validator: _vPassword,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),

                      _Field(
                        controller: _emailCtrl,
                        label: 'Email',
                        hint: 'Enter your email',
                        icon: Icons.email,
                        keyboard: TextInputType.emailAddress,
                        validator: _vEmail,
                      ),

                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SignUpPage.dark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _submit,
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Have an account? ',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Log in',
                                style: TextStyle(
                                  color: SignUpPage.dark,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Role: ${globals.TypeUser.isEmpty ? "Not selected" : globals.TypeUser}",
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 12,
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

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType keyboard;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;

  const _Field({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboard = TextInputType.text,
    this.validator,
    this.inputFormatters,
    this.textInputAction,
  });

  OutlineInputBorder _b(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: c, width: 1.4),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      validator: validator,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: SignUpPage.fieldFill,
        prefixIcon: Icon(icon, color: SignUpPage.dark),
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 14,
        ),
        enabledBorder: _b(SignUpPage.fieldBorder),
        focusedBorder: _b(SignUpPage.dark),
        errorBorder: _b(Colors.red),
        focusedErrorBorder: _b(Colors.red),
      ),
    );
  }
}
