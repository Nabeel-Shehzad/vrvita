// lib/login_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import 'global.dart' as globals;
import 'role_page.dart';
import 'signup_page.dart';

// صفحات الداشبورد
import 'student_home_page.dart';
import 'doctor_home_page.dart';
import 'nurse_home_page.dart';
import 'supervisor_home_page.dart';

// البصمة
import 'package:local_auth/local_auth.dart';

// ⬇️ جديد: نسيت كلمة المرور
import 'forgot_password_page.dart';

const Color _dark = Color(0xFF2F5B89);
const Color _fieldFill = Color(0xFFDCE4F0);
const Color _fieldBorder = Color(0xFF6C737F);

enum _LoginMethod { id, bio }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();

  _LoginMethod _method = _LoginMethod.bio; // نبدأ بالبصمة، ونعدّل بعد الفحص
  bool _isLoading = false;

  final _auth = LocalAuthentication();
  bool _canCheckBiometrics = false;

  // ✅ نختار النوع الأفضل تلقائيًا
  BiometricType? _preferredBio; // face أو fingerprint

  String get _bioName {
    if (_preferredBio == BiometricType.face) return 'Face ID';
    if (_preferredBio == BiometricType.fingerprint) {
      final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
      return isIOS ? 'Touch ID' : 'Fingerprint';
    }
    return 'Biometrics';
  }

  bool get _bioSupported => _canCheckBiometrics && _preferredBio != null;
  bool get _shouldAutoPromptBio =>
      _method == _LoginMethod.bio &&
      _bioSupported &&
      globals.isSignedUp == true &&
      globals.biometricEnabled == true;

  @override
  void initState() {
    super.initState();
    _initBiometrics();

    // نسأل بالبصمة تلقائيًا فقط عند توفرها ولما يكون المستخدم مسجل ومفعّلها
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      if (_shouldAutoPromptBio) {
        final okRole = await _ensureRoleChosen();
        if (!okRole) return;

        final ok = await _authWithBiometrics();
        if (ok) {
          globals.isLoggedIn = true;
          _showSnack('$_bioName login successful', bg: Colors.green.shade600);
          final name = globals.userDisplayName.isEmpty
              ? 'Biometric User'
              : globals.userDisplayName;
          _goToHomeByRole(userName: name);
        }
      }
    });
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    super.dispose();
  }

  // ---------- Helpers ----------
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

  String? _vId(String? v) {
    if (_method == _LoginMethod.bio) return null;
    if (v == null || v.trim().isEmpty) return 'User ID is required';
    if (!RegExp(r'^\d{9}$').hasMatch(v.trim()))
      return 'User ID must be 9 digits';
    return null;
  }

  String _roleFromGlobal() => (globals.TypeUser).trim().toLowerCase();

  Future<bool> _ensureRoleChosen() async {
    if (_roleFromGlobal().isNotEmpty) return true;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RolePage()),
    );
    if (_roleFromGlobal().isEmpty) {
      _showSnack(
        'Please choose your role to continue',
        bg: Colors.orange.shade700,
      );
      return false;
    }
    return true;
  }

  // ✅ نكتشف المتاح ونختار تلقائيًا (يشمل strong/weak على أندرويد)
  Future<void> _initBiometrics() async {
    try {
      final can = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();
      final avail = await _auth.getAvailableBiometrics();

      if (!mounted) return;

      BiometricType? pick;
      if (avail.contains(BiometricType.face)) {
        pick = BiometricType.face; // iOS
      } else if (avail.contains(BiometricType.fingerprint) ||
          avail.contains(BiometricType.strong) ||
          avail.contains(BiometricType.weak)) {
        pick = BiometricType.fingerprint; // Android
      } else {
        pick = null;
      }

      setState(() {
        _canCheckBiometrics = can || supported;
        _preferredBio = pick;

        // لو ما فيه بصمة، نحول لطريقة الـ ID ونُخفي خيار البصمة
        if (_preferredBio == null) {
          _method = _LoginMethod.id;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _canCheckBiometrics = false;
        _preferredBio = null;
        _method = _LoginMethod.id;
      });
    }
  }

  Future<bool> _authWithBiometrics() async {
    try {
      if (!_bioSupported) {
        if (!mounted) return false;
        _showSnack(
          'Biometrics not available on this device',
          bg: Colors.orange.shade700,
        );
        return false;
      }
      final ok = await _auth.authenticate(
        localizedReason: 'Sign in with $_bioName',
        biometricOnly: true,
      );
      return ok;
    } on PlatformException catch (e) {
      if (!mounted) return false;
      if (e.code == 'NotEnrolled') {
        _showSnack(
          '$_bioName is not set up on this device',
          bg: Colors.orange.shade700,
        );
      } else if (e.code == 'LockedOut' || e.code == 'PermanentlyLockedOut') {
        _showSnack(
          'Biometrics locked. Use passcode then try again',
          bg: Colors.orange.shade700,
        );
      } else {
        _showSnack('Biometric error: ${e.code}', bg: Colors.red.shade700);
      }
      return false;
    }
  }

  void _goToHomeByRole({required String userName}) {
    final role = _roleFromGlobal();
    if (role == "doctor") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DoctorHomePage(userName: userName)),
      );
    } else if (role == "student") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => StudentHomePage(userName: userName)),
      );
    } else if (role == "nurse") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => NurseHomePage(userName: userName)),
      );
    } else if (role == "supervisor") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SupervisorHomePage(userName: userName),
        ),
      );
    } else {
      _showSnack('Unknown role: "$role"', bg: Colors.red.shade700);
    }
  }

  // ---------- LOGIN FLOW ----------
  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      if (!globals.isSignedUp) {
        _showSnack('Please sign up first', bg: Colors.orange.shade700);
        return;
      }

      if (_method == _LoginMethod.id) {
        if (!_formKey.currentState!.validate()) return;
        final id = _idCtrl.text.trim();
        if (globals.registeredId.isEmpty || id != globals.registeredId) {
          _showSnack('Invalid User ID', bg: Colors.red.shade700);
          return;
        }
      }

      final okRole = await _ensureRoleChosen();
      if (!okRole) return;

      if (_method == _LoginMethod.bio) {
        final ok = await _authWithBiometrics();
        if (!ok) return;
        globals.isLoggedIn = true;
        _showSnack('$_bioName login successful', bg: Colors.green.shade600);
        final name = globals.userDisplayName.isEmpty
            ? 'Biometric User'
            : globals.userDisplayName;
        _goToHomeByRole(userName: name);
        return;
      }

      globals.isLoggedIn = true;
      _showSnack('Login successful', bg: Colors.green.shade600);
      final name = globals.userDisplayName.isEmpty
          ? globals.registeredId
          : globals.userDisplayName;
      _goToHomeByRole(userName: name);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usingId = _method == _LoginMethod.id;

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
                    children: [
                      // ⛔️ شلّنا سهم الرجوع بالكامل
                      const SizedBox(height: 6),
                      Text(
                        'Welcome Back!',
                        style: GoogleFonts.quintessential(
                          fontSize: 26,
                          color: _dark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 22),

                      // اختيار الطريقة (نخفي البصمة لو غير متاحة)
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            selected: usingId,
                            label: const Text('User ID'),
                            selectedColor: _dark.withOpacity(.15),
                            onSelected: (_) =>
                                setState(() => _method = _LoginMethod.id),
                          ),
                          if (_bioSupported)
                            ChoiceChip(
                              selected: _method == _LoginMethod.bio,
                              label: Text(_bioName),
                              selectedColor: _dark.withOpacity(.15),
                              onSelected: (_) =>
                                  setState(() => _method = _LoginMethod.bio),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (usingId) ...[
                        _FormFieldBox(
                          controller: _idCtrl,
                          label: 'User ID (9 digits)',
                          hint: 'Enter your 9-digit ID',
                          icon: Icons.badge_outlined,
                          validator: _vId,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        const SizedBox(height: 8),
                        // ⬇️ زر "نسيت كلمة المرور؟"
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ForgotPasswordPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _dark,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                )
                              : Text(
                                  usingId
                                      ? 'LOG IN'
                                      : 'CONTINUE WITH $_bioName',
                                ),
                        ),
                      ),

                      const SizedBox(height: 14),
                      TextButton(
                        // ✅ يروح مباشرة لصفحة التسجيل — بدون أي اختيار رول هنا
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpPage(),
                            ),
                          );
                        },
                        child: const Text('Create a new account'),
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

class _FormFieldBox extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const _FormFieldBox({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: _fieldFill,
        prefixIcon: Icon(icon, color: Colors.black87),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _dark, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.6),
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
