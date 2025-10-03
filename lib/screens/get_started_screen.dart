import 'package:flutter/material.dart';
import 'choose_role_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A6FA5), // Blue background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // VR Headset Graphic (Using a creative icon representation)
              _buildVRHeadsetGraphic(),

              const SizedBox(height: 40),

              // Arabic Quote
              const Text(
                '"ومن أحياها فكأنما أحيا الناس جميعاً"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // Description Text
              const Text(
                'A high-quality medical application designed for hospitals, enabling healthcare professionals to enhance surgical procedures, training, and patient recovery using immersive VR technology.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),

              const Spacer(flex: 2),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChooseRoleScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    foregroundColor: const Color(0xFF4A6FA5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Get started!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVRHeadsetGraphic() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Particle effect background
        SizedBox(
          width: 200,
          height: 200,
          child: CustomPaint(painter: ParticlePainter()),
        ),

        // VR Headset Icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.vrpano, size: 80, color: Colors.white),
        ),
      ],
    );
  }
}

// Custom painter for particle effect
class ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw small particles scattered around
    final random = [
      Offset(20, 30),
      Offset(160, 40),
      Offset(30, 100),
      Offset(170, 120),
      Offset(50, 170),
      Offset(150, 160),
      Offset(100, 20),
      Offset(80, 180),
      Offset(10, 80),
      Offset(180, 80),
    ];

    for (var offset in random) {
      canvas.drawCircle(offset, 2, paint);
    }

    // Draw some triangular shapes
    final trianglePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path1 = Path()
      ..moveTo(40, 50)
      ..lineTo(45, 60)
      ..lineTo(35, 60)
      ..close();

    final path2 = Path()
      ..moveTo(150, 140)
      ..lineTo(155, 150)
      ..lineTo(145, 150)
      ..close();

    canvas.drawPath(path1, trianglePaint);
    canvas.drawPath(path2, trianglePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
