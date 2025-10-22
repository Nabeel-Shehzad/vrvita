// lib/basic_mcq_quiz_page.dart
import 'package:flutter/material.dart';
import 'quiz_score_page.dart';

const kBrand = Color(0xFF2F5B89);
const kPill = Color(0xFFE8F1FF);
const kStroke = Color(0xFFE1E5EC);

class BasicMcqQuizPage extends StatefulWidget {
  final UserRole role;
  final String userName;
  final String dept;

  const BasicMcqQuizPage({
    super.key,
    this.role = UserRole.student,
    this.userName = 'You',
    this.dept = 'General',
  });

  @override
  State<BasicMcqQuizPage> createState() => _BasicMcqQuizPageState();
}

class _BasicMcqQuizPageState extends State<BasicMcqQuizPage> {
  final List<_McqQ> _questions = [
    _McqQ(
      text: 'Which organ produces bile?',
      options: const ['Stomach', 'Liver', 'Pancreas', 'Heart'],
      correct: 1,
    ),
    _McqQ(
      text: 'Gas exchange happens in the:',
      options: const ['Trachea', 'Bronchi', 'Alveoli', 'Esophagus'],
      correct: 2,
    ),
    _McqQ(
      text: 'Which organ pumps blood?',
      options: const ['Lungs', 'Heart', 'Liver', 'Kidneys'],
      correct: 1,
    ),
    _McqQ(
      text: 'Which muscle is voluntary?',
      options: const ['Skeletal', 'Cardiac', 'Smooth', 'None'],
      correct: 0,
    ),
    _McqQ(
      text: 'Which organ absorbs most nutrients?',
      options: const ['Small intestine', 'Stomach', 'Large intestine', 'Liver'],
      correct: 0,
    ),
    _McqQ(
      text: 'The main function of the skeleton is:',
      options: const ['Support', 'Pump blood', 'Produce bile', 'Store oxygen'],
      correct: 0,
    ),
    _McqQ(
      text: 'Which blood cells fight infection?',
      options: const ['Red', 'White', 'Platelets', 'None'],
      correct: 1,
    ),
    _McqQ(
      text: 'Which organ helps with balance?',
      options: const ['Cerebellum', 'Liver', 'Heart', 'Stomach'],
      correct: 0,
    ),
    _McqQ(
      text: 'Which chamber pumps blood to the lungs?',
      options: const ['Right ventricle', 'Left ventricle', 'Left atrium', 'Right atrium'],
      correct: 0,
    ),
    _McqQ(
      text: 'The optic nerve carries signals for:',
      options: const ['Vision', 'Hearing', 'Smell', 'Touch'],
      correct: 0,
    ),
  ];

  final Map<int, int> _answers = {}; // index -> chosen option
  int _current = 0;

  int get _total => _questions.length;
  bool get _isLast => _current == _total - 1;
  bool get _hasAnswer => _answers.containsKey(_current);
  double get _progress => (_current + 1) / _total;

  void _prev() {
    if (_current > 0) setState(() => _current--);
  }

  void _nextOrSubmit() {
    if (!_hasAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer')),
      );
      return;
    }
    if (_isLast) {
      _submit();
    } else {
      setState(() => _current++);
    }
  }

  void _reviewSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44, height: 5, margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7EBF3),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Row(
                  children: [
                    const Text('Review answers',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Text('Answered ${_answers.length} / $_total',
                        style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _total,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.1,
                  ),
                  itemBuilder: (_, i) {
                    final isAns = _answers.containsKey(i);
                    final isCur = i == _current;
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() => _current = i);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isCur ? kBrand : (isAns ? kPill : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isCur ? kBrand : kStroke, width: 1.2),
                        ),
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: isCur ? Colors.white : (isAns ? kBrand : Colors.black54),
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

  void _submit() {
    int correct = 0;
    for (int i = 0; i < _total; i++) {
      final q = _questions[i];
      final a = _answers[i];
      if (a != null && a == q.correct) correct++;
    }
    final percent = ((correct / _total) * 100).round();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Quiz Finished', style: TextStyle(color: kBrand, fontWeight: FontWeight.w800)),
        content: Text('Score: $correct / $_total  (${percent}%)'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizScorePage(
                    role: widget.role,
                    score: correct,
                    total: _total,
                    level: 'Basic',
                    dept: widget.dept,
                    userName: widget.userName,
                  ),
                ),
              );
            },
            child: const Text('OK', style: TextStyle(color: kBrand)),
          ),
        ],
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
              'Basic • Multiple Choice (10)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            // progress
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
                  Text('Answered ${_answers.length} / $_total',
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

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _current == 0 ? null : _prev,
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
                onPressed: _isLast ? _reviewSheet : _nextOrSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: _hasAnswer || !_isLast ? kBrand : kBrand.withOpacity(0.5),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kStroke, width: 1.2),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _qBadge(number),
          const SizedBox(height: 10),
          Text(
            question.text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: List.generate(question.options.length, (i) {
              final selected = selectedIndex == i;
              return _OptionTile(
                label: String.fromCharCode(65 + i),
                text: question.options[i],
                selected: selected,
                onTap: () => onSelect(i),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _qBadge(int no) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kPill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD6E4FB)),
      ),
      child: Text('Q$no', style: const TextStyle(color: kBrand, fontWeight: FontWeight.w900, letterSpacing: 0.2)),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile({
    super.key,
    required this.label,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const kGray = Color(0xFFE1E5EC);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? kPill : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? kBrand : kGray, width: 1.2),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF9FBEEC),
                child: Text(label, style: const TextStyle(color: kBrand, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(fontWeight: FontWeight.w700, color: selected ? kBrand : Colors.black87),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: selected
                    ? const Icon(Icons.check_rounded, color: kBrand, key: ValueKey('c'))
                    : const SizedBox(key: ValueKey('n')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _McqQ {
  final String text;
  final List<String> options;
  final int correct;
  const _McqQ({required this.text, required this.options, required this.correct});
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
