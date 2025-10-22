// lib/faqs_page.dart
import 'package:flutter/material.dart';

const kBrand = Color(0xFF2F5B89);
const kPill = Color(0xFFE8F1FF);

class FaqsPage extends StatelessWidget {
  const FaqsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, toolbarHeight: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          children: const [
            _TopBrandBar(),
            SizedBox(height: 10),
            Text(
              "Frequently Asked\nQuestions:",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black87, height: 1.2),
            ),
            SizedBox(height: 10),
            _FaqSection(
              title: "General Questions:",
              bullets: [
                "What is VRVITA, and who can use it?",
                "Do I need a VR headset to use VRVITA?",
                "Can I access training modules without an internet connection?",
                "How do I track my progress in the training modules?",
                "Is VRVITA suitable for both students and experienced professionals?",
                "How often are new training modules added to the platform?",
              ],
            ),
            _FaqSection(
              title: "Technical Support:",
              bullets: [
                "The app is not loading—what should I do?",
                "Videos are buffering—how can I improve performance?",
                "Which devices and OS versions are supported?",
              ],
            ),
            _FaqSection(
              title: "Account & Security:",
              bullets: [
                "How do I reset my password?",
                "How do I update my email or phone number?",
                "How does VRVITA protect my data?",
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqSection extends StatefulWidget {
  final String title;
  final List<String> bullets;
  const _FaqSection({required this.title, required this.bullets});

  @override
  State<_FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<_FaqSection> {
  bool open = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          // header pill
          InkWell(
            onTap: () => setState(() => open = !open),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(color: kPill, borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: kBrand,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Icon(open ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: kBrand),
                ],
              ),
            ),
          ),
          if (open)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: kPill, borderRadius: BorderRadius.circular(14)),
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Getting Started with VRVITA:",
                      style: TextStyle(fontWeight: FontWeight.w700, color: kBrand)),
                  const SizedBox(height: 8),
                  ...List.generate(widget.bullets.length, (i) {
                    final t = widget.bullets[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${i + 1}. ",
                              style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                          Expanded(
                            child: Text(
                              t,
                              style: const TextStyle(color: Colors.black54, height: 1.25),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TopBrandBar extends StatelessWidget {
  const _TopBrandBar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(height: 70, width: double.infinity, child: CustomPaint(painter: _HeaderShapePainter())),
        Row(
          children: const [
            BackButton(color: Colors.black87),
            Spacer(),
            Text(
              "VRVITA",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: kBrand, letterSpacing: 1.2),
            ),
            Spacer(),
            Icon(Icons.headset_mic_rounded, color: Colors.black87),
            SizedBox(width: 4),
            Icon(Icons.notifications_rounded, color: Colors.black87),
          ],
        ),
      ],
    );
  }
}

class _HeaderShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final edgePaint = Paint()..color = Colors.black26..strokeWidth = 1.8..style = PaintingStyle.stroke;
    final p1 = Path()..moveTo(size.width * 0.06, size.height * 0.32)..lineTo(size.width * 0.94, size.height * 0.60);
    canvas.drawPath(p1, edgePaint);

    final p2Paint = Paint()..color = Colors.black38..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final p2 = Path()..moveTo(size.width * 0.22, size.height * 0.72)..lineTo(size.width * 0.98, size.height * 0.42);
    canvas.drawPath(p2, p2Paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
