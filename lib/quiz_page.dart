// lib/quiz_page.dart
import 'package:flutter/material.dart';
import 'mixed_quiz_page.dart';             // Mixed Quiz (Advanced only)
import 'basic_tf_quiz_page.dart';         // Basic True/False Quiz
import 'basic_mcq_quiz_page.dart';        // Basic MCQ Quiz
import 'intermediate_tf_quiz_page.dart';  // Intermediate True/False Quiz
import 'intermediate_mcq_quiz_page.dart'; // Intermediate MCQ Quiz
import 'advanced_tf_quiz_page.dart';      // Advanced True/False Quiz
import 'advanced_mcq_quiz_page.dart';     // ✅ Advanced MCQ Quiz (NEW)

const kBrand = Color(0xFF2F5B89);
const kPill = Color(0xFFE8F1FF);

enum Level { basic, intermediate, advanced }
enum ScenarioType { tf, mcq, mixed }

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Level _trainingLevel = Level.basic;
  Level _scenarioLevel = Level.basic;
  ScenarioType? _scenarioType;

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _levelLabel(Level l) {
    switch (l) {
      case Level.basic:
        return "Basic";
      case Level.intermediate:
        return "Intermediate";
      case Level.advanced:
        return "Advanced";
    }
  }

  String _scenarioTypeLabel(ScenarioType t) {
    switch (t) {
      case ScenarioType.tf:
        return "True / False";
      case ScenarioType.mcq:
        return "Multiple Choice (MCQ)";
      case ScenarioType.mixed:
        return "Mixed (Hard)";
    }
  }

  // ===== Training mode (عرض فقط) =====
  void _checkEquipment() {
    showDialog(
      context: context,
      builder: (_) => const _NiceDialog(
        title: "Check Equipment & Environment",
        lines: [
          "✔ Headset connected",
          "✔ Sensors active",
          "✔ Room space verified",
        ],
      ),
    );
  }

  void _startTraining() {
    showDialog(
      context: context,
      builder: (_) => _NiceDialog(
        title: "Training started",
        lines: [
          "Level: ${_levelLabel(_trainingLevel)}",
          "Mode: VR Training",
        ],
      ),
    );
  }

  // ===== Scenario selection =====
  void _startWith(ScenarioType t) {
    // 1) Mixed (Hard) — Advanced فقط
    if (t == ScenarioType.mixed) {
      if (_scenarioLevel != Level.advanced) {
        _snack("Mixed (Hard) is available only with Advanced level.");
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MixedQuizPage()));
      return;
    }

    // 2) True / False — Basic و Intermediate و Advanced
    if (t == ScenarioType.tf) {
      if (_scenarioLevel == Level.basic) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const BasicTfQuizPage()));
        return;
      }
      if (_scenarioLevel == Level.intermediate) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const IntermediateTfQuizPage()));
        return;
      }
      if (_scenarioLevel == Level.advanced) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdvancedTfQuizPage()));
        return;
      }
    }

    // 3) MCQ — Basic و Intermediate و Advanced (NEW)
    if (t == ScenarioType.mcq) {
      if (_scenarioLevel == Level.basic) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const BasicMcqQuizPage()));
        return;
      }
      if (_scenarioLevel == Level.intermediate) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const IntermediateMcqQuizPage()));
        return;
      }
      if (_scenarioLevel == Level.advanced) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdvancedMcqQuizPage()));
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
      AppBar(backgroundColor: Colors.white, elevation: 0, toolbarHeight: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            const _TopBrandBar(),
            const SizedBox(height: 16),

            // ===== Training Mode Selection =====
            const Text(
              "Training Mode Selection",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (final l in Level.values) ...[
                  ChoiceChip(
                    label: Text(_levelLabel(l)),
                    selected: _trainingLevel == l,
                    onSelected: (_) => setState(() => _trainingLevel = l),
                    selectedColor: kPill,
                  ),
                  const SizedBox(width: 8),
                ]
              ],
            ),
            const SizedBox(height: 10),
            Text("Current level: ${_levelLabel(_trainingLevel)}",
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _checkEquipment,
                    style: FilledButton.styleFrom(
                      backgroundColor: kBrand,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Check Equipment & Environment"),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: _startTraining,
                  style: FilledButton.styleFrom(
                    backgroundColor: kBrand,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Start"),
                ),
              ],
            ),

            const Divider(height: 36),

            // ===== Scenario selection =====
            const Text(
              "Scenario selection",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87),
            ),
            const SizedBox(height: 14),

            const Text("Choose Level:",
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
            const SizedBox(height: 6),
            Row(
              children: [
                for (final l in Level.values) ...[
                  ChoiceChip(
                    label: Text(_levelLabel(l)),
                    selected: _scenarioLevel == l,
                    onSelected: (_) => setState(() => _scenarioLevel = l),
                    selectedColor: kPill,
                  ),
                  const SizedBox(width: 8),
                ]
              ],
            ),
            const SizedBox(height: 14),

            const Text("Choose Scenario:",
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
            const SizedBox(height: 10),

            _ScenarioRowTile(
              icon: Icons.toggle_on_rounded,
              title: "True / False",
              selected: _scenarioType == ScenarioType.tf,
              onTap: () => setState(() => _scenarioType = ScenarioType.tf),
              onStart: () => _startWith(ScenarioType.tf),
            ),
            const SizedBox(height: 10),

            _ScenarioRowTile(
              icon: Icons.list_alt_rounded,
              title: "Multiple Choice (MCQ)",
              selected: _scenarioType == ScenarioType.mcq,
              onTap: () => setState(() => _scenarioType = ScenarioType.mcq),
              onStart: () => _startWith(ScenarioType.mcq),
            ),
            const SizedBox(height: 10),

            _ScenarioRowTile(
              icon: Icons.auto_awesome_rounded,
              title: "Mixed (Hard) • T/F + MCQ",
              selected: _scenarioType == ScenarioType.mixed,
              onTap: (_scenarioLevel == Level.advanced)
                  ? () => setState(() => _scenarioType = ScenarioType.mixed)
                  : null,
              onStart: (_scenarioLevel == Level.advanced)
                  ? () => _startWith(ScenarioType.mixed)
                  : null,
              disabledNote: (_scenarioLevel == Level.advanced)
                  ? null
                  : "Available only in Advanced",
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioRowTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onStart;
  final String? disabledNote;

  const _ScenarioRowTile({
    super.key,
    required this.icon,
    required this.title,
    required this.selected,
    this.onTap,
    this.onStart,
    this.disabledNote,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? kPill : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? kBrand : const Color(0xFFE1E5EC), width: 1.2),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF9FBEEC),
              child: Icon(icon, color: kBrand),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: disabled ? Colors.black38 : (selected ? kBrand : Colors.black87),
                  ),
                ),
                if (disabledNote != null)
                  Text(disabledNote!, style: const TextStyle(color: Colors.black45, fontSize: 12)),
              ]),
            ),
            if (!disabled && selected)
              FilledButton(
                onPressed: onStart,
                style: FilledButton.styleFrom(
                  backgroundColor: kBrand,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Start"),
              )
            else
              const Icon(Icons.chevron_right_rounded, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}

class _NiceDialog extends StatelessWidget {
  final String title;
  final List<String> lines;
  const _NiceDialog({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(color: kBrand, fontWeight: FontWeight.w800, fontSize: 18)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map((e) => Text("• $e")).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK", style: TextStyle(color: kBrand)),
        ),
      ],
    );
  }
}

class _TopBrandBar extends StatelessWidget {
  const _TopBrandBar();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(height: 70, width: double.infinity, child: CustomPaint(painter: _HeaderShapePainter())),
      Row(children: const [
        BackButton(color: Colors.black87),
        Spacer(),
        Text("VRVITA",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: kBrand, letterSpacing: 1.2)),
        Spacer(),
        Icon(Icons.headset_mic_rounded, color: Colors.black87),
        SizedBox(width: 4),
        Icon(Icons.notifications_rounded, color: Colors.black87),
      ]),
    ]);
  }
}

class _HeaderShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final edgePaint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    final p1 = Path()..moveTo(size.width * 0.06, size.height * 0.32)..lineTo(size.width * 0.94, size.height * 0.60);
    canvas.drawPath(p1, edgePaint);

    final p2Paint = Paint()
      ..color = Colors.black38
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final p2 = Path()..moveTo(size.width * 0.22, size.height * 0.72)..lineTo(size.width * 0.98, size.height * 0.42);
    canvas.drawPath(p2, p2Paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
