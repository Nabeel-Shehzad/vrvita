// lib/intermediate_mcq_quiz_page.dart
import 'package:flutter/material.dart';
import 'quiz_score_page.dart';

const kBrand  = Color(0xFF2F5B89);
const kPill   = Color(0xFFE8F1FF);
const kStroke = Color(0xFFE1E5EC);

class IntermediateMcqQuizPage extends StatefulWidget {
  const IntermediateMcqQuizPage({super.key});

  @override
  State<IntermediateMcqQuizPage> createState() => _IntermediateMcqQuizPageState();
}

class _IntermediateMcqQuizPageState extends State<IntermediateMcqQuizPage> {
  // -------- Questions (Intermediate – MCQ) --------
  final List<_McqQ> _questions = const [
    _McqQ(
      'What keeps the trachea open?',
      ['Smooth muscle','Bone','Cartilage rings','Air'],
      2,
    ),
    _McqQ(
      'Which of the following is NOT part of the digestive system?',
      ['Liver','Stomach','Esophagus','Larynx'],
      3,
    ),
    _McqQ(
      'Which is part of the respiratory system?',
      ['Alveoli','Pancreas','Esophagus','Liver'],
      0,
    ),
    _McqQ(
      'Which chamber pumps oxygenated blood to the body?',
      ['Left ventricle','Right ventricle','Right atrium','Left atrium'],
      0,
    ),
    _McqQ(
      'Which muscle type is involuntary?',
      ['Skeletal','Cardiac','Biceps','Arm'],
      1,
    ),
    _McqQ(
      'What happens when the diaphragm contracts?',
      ['Inhalation','Exhalation','Heartbeat slows','Stomach digests faster'],
      0,
    ),
    _McqQ(
      'Which of these is a function of the circulatory system?',
      ['Transport oxygen','Absorb nutrients','Store bile','Produce urine'],
      0,
    ),
    _McqQ(
      'If the optic nerve is damaged, the result is:',
      ['Blindness','Deafness','Poor digestion','Weak heartbeat'],
      0,
    ),
    _McqQ(
      'Which blood cells are responsible for clotting?',
      ['Platelets','Red','White','None'],
      0,
    ),
    _McqQ(
      'Which system prepares the body for “fight or flight”?',
      ['Sympathetic nervous system','Parasympathetic nervous system','Digestive system','Respiratory system'],
      0,
    ),
  ];

  // answers map: index -> selected option index
  final Map<int, int> _answers = {};
  int _current = 0;

  int get _total => _questions.length;
  int get _answeredCount => _answers.length;
  bool get _isLast => _current == _total - 1;
  bool get _hasAnswerForCurrent => _answers.containsKey(_current);
  double get _progress => _total == 0 ? 0 : (_current + 1) / _total;

  void _goPrev() {
    if (_current > 0) setState(() => _current--);
  }

  void _goNext() {
    if (!_hasAnswerForCurrent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer before continuing')),
      );
      return;
    }
    if (!_isLast) setState(() => _current++);
  }

  // ---------- Review bottom sheet ----------
  void _openReviewSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7EBF3),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const Text('Review answers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)),
                const SizedBox(height: 6),
                Text('Answered $_answeredCount / $_total',
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _legendDot(color: kPill, border: kBrand, text: 'Answered'),
                    const SizedBox(width: 14),
                    _legendDot(color: Colors.white, border: kStroke, text: 'Unanswered'),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        final idx = List<int>.generate(_total, (i) => i)
                            .firstWhere((i) => !_answers.containsKey(i), orElse: () => -1);
                        if (idx >= 0) {
                          Navigator.pop(context);
                          setState(() => _current = idx);
                        }
                      },
                      icon: const Icon(Icons.flag_outlined, color: kBrand),
                      label: const Text('First Unanswered', style: TextStyle(color: kBrand)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _total,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, i) {
                    final isAnswered = _answers.containsKey(i);
                    final isCurrent = i == _current;
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() => _current = i);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isCurrent ? kBrand : (isAnswered ? kPill : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isCurrent ? kBrand : kStroke, width: 1.2),
                        ),
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: isCurrent ? Colors.white : (isAnswered ? kBrand : Colors.black54),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _submit();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: kBrand,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Submit quiz'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _legendDot({required Color color, required Color border, required String text}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ---------- Submit ----------
  void _submit() {
    int correct = 0;
    for (int i = 0; i < _questions.length; i++) {
      final a = _answers[i];
      if (a != null && a == _questions[i].correct) correct++;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScorePage(
          role: UserRole.student, // مرّر الدور الحقيقي لو متاح
          score: correct,
          total: _questions.length,
          level: 'Intermediate',
          dept: 'General',
          userName: 'You',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_current];
    final current = _answers[_current];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, toolbarHeight: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: [
            const _TopBrandBar(),
            const SizedBox(height: 10),
            const Text(
              'Intermediate Quiz — Multiple Choice',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87, height: 1.2),
            ),
            const SizedBox(height: 10),

            // Progress box
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kStroke),
              ),
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Answered $_answeredCount / $_total',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black54)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 10,
                      backgroundColor: const Color(0xFFEFF3FA),
                      color: kBrand,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _PagerDots(
              current: _current,
              total: _total,
              answered: _answers,
              onTap: (i) => setState(() => _current = i),
            ),
            const SizedBox(height: 12),

            _QuestionCard(
              number: _current + 1,
              question: q,
              selectedIndex: current,
              onSelect: (i) => setState(() => _answers[_current] = i),
            ),
          ],
        ),
      ),

      // Bottom bar
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _current == 0 ? null : _goPrev,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kBrand),
                  foregroundColor: kBrand,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Previous'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: _isLast ? _openReviewSheet : _goNext,
                style: FilledButton.styleFrom(
                  backgroundColor: _hasAnswerForCurrent || !_isLast ? kBrand : kBrand.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(_isLast ? 'Submit' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- UI pieces ----------
class _PagerDots extends StatelessWidget {
  final int current;
  final int total;
  final Map<int, int> answered;
  final ValueChanged<int> onTap;

  const _PagerDots({
    super.key,
    required this.current,
    required this.total,
    required this.answered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: List.generate(total, (i) {
        final isCurrent = i == current;
        final isAnswered = answered.containsKey(i);
        return InkWell(
          onTap: () => onTap(i),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isCurrent ? kBrand : (isAnswered ? kPill : Colors.white),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: isCurrent ? kBrand : kStroke, width: 1.2),
            ),
            child: Text(
              '${i + 1}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: isCurrent ? Colors.white : (isAnswered ? kBrand : Colors.black54),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final int number;
  final _McqQ question;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  const _QuestionCard({
    super.key,
    required this.number,
    required this.question,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: kPill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFD6E4FB)),
            ),
            child: Text('Q$number',
                style: const TextStyle(color: kBrand, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 8),
          Text(
            question.text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Column(
            children: List.generate(question.options.length, (i) {
              final sel = selectedIndex == i;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => onSelect(i),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: sel ? kPill : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: sel ? kBrand : kStroke, width: 1.2),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xFF9FBEEC),
                          child: Text(String.fromCharCode(65 + i),
                              style: const TextStyle(color: kBrand, fontWeight: FontWeight.w900)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            question.options[i],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: sel ? kBrand : Colors.black87,
                            ),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          child: sel
                              ? const Icon(Icons.check_rounded, color: kBrand, key: ValueKey('c'))
                              : const SizedBox(key: ValueKey('n')),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ]),
      ),
    );
  }
}

class _McqQ {
  final String text;
  final List<String> options;
  final int correct;
  const _McqQ(this.text, this.options, this.correct);
}

// ---- Brand header (same style used across app) ----
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
    final edgePaint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    final p1 = Path()
      ..moveTo(size.width * 0.06, size.height * 0.32)
      ..lineTo(size.width * 0.94, size.height * 0.60);
    canvas.drawPath(p1, edgePaint);

    final p2Paint = Paint()
      ..color = Colors.black38
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final p2 = Path()
      ..moveTo(size.width * 0.22, size.height * 0.72)
      ..lineTo(size.width * 0.98, size.height * 0.42);
    canvas.drawPath(p2, p2Paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
