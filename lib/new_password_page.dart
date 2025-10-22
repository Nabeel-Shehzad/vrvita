import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _p1 = TextEditingController();
  final _p2 = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _p1.dispose();
    _p2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const dark = Color(0xFF2F5B89);
    const bg = Color(0xFFE7EEF7);
    const panel = Colors.white;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            const _TopWaves(),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: dark, size: 26),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Create New Password',
                      style: GoogleFonts.quintessential(
                        fontSize: 28, color: dark, fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Your new password must be different from\npreviously used passwords.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: panel,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          _PasswordField(
                            controller: _p1,
                            hint: "New Password",
                            obscure: _obscure1,
                            toggle: () => setState(() => _obscure1 = !_obscure1),
                          ),
                          const SizedBox(height: 16),
                          _PasswordField(
                            controller: _p2,
                            hint: "Confirm New Password",
                            obscure: _obscure2,
                            toggle: () => setState(() => _obscure2 = !_obscure2),
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
                                final p1 = _p1.text.trim();
                                final p2 = _p2.text.trim();
                                if (p1.isEmpty || p2.isEmpty) {
                                  _showSnack(context, 'Please fill both fields', Colors.redAccent);
                                  return;
                                }
                                if (p1.length < 8) {
                                  _showSnack(context, 'Password must be at least 8 characters', Colors.orange);
                                  return;
                                }
                                if (p1 != p2) {
                                  _showSnack(context, 'Passwords do not match', Colors.redAccent);
                                  return;
                                }
                                _showSnack(context, 'Password changed successfully', Colors.green);
                                Future.delayed(const Duration(milliseconds: 900), () {
                                  if (mounted) Navigator.pop(context);
                                });
                              },
                              child: const Text(
                                "Change Password",
                                style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback toggle;
  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.toggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF4F7FB),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.black87),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.black54),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB6C3D5)),
        ),
      ),
    );
  }
}

class _TopWaves extends StatelessWidget {
  const _TopWaves();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: CustomPaint(painter: _WavesPainter()),
    );
  }
}

class _WavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final p1 = Paint()..color = const Color(0xFFCFE0F2);
    final p2 = Paint()..color = const Color(0xFFBFD4EA);

    final path1 = Path()
      ..moveTo(0, 0)
      ..lineTo(0, h * .45)
      ..quadraticBezierTo(w * .35, h * .25, w * .7, h * .38)
      ..quadraticBezierTo(w * .9, h * .46, w, h * .36)
      ..lineTo(w, 0)
      ..close();

    final path2 = Path()
      ..moveTo(0, h * .55)
      ..quadraticBezierTo(w * .3, h * .4, w * .65, h * .56)
      ..quadraticBezierTo(w * .9, h * .66, w, h * .6)
      ..lineTo(w, h * .25)
      ..quadraticBezierTo(w * .55, h * .32, 0, h * .2)
      ..close();

    canvas.drawPath(path1, p1);
    canvas.drawPath(path2, p2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
