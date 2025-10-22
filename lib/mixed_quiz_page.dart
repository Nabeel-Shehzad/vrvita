// lib/mixed_quiz_page.dart
import 'package:flutter/material.dart';
import 'quiz_score_page.dart'; // فيه UserRole + صفحة السكور

const kBrand = Color(0xFF2F5B89);
const kPill = Color(0xFFE8F1FF);
const kStroke = Color(0xFFE1E5EC);

class MixedQuizPage extends StatefulWidget {
  /// مرّر الدور وبيانات المستخدم عند فتح صفحة الكويز
  final UserRole role;
  final String? userName;
  final String? dept;   // القسم (اختياري)
  final String? level;  // المستوى الظاهر في السكور (اختياري)

  const MixedQuizPage({
    super.key,
    this.role = UserRole.student,
    this.userName,
    this.dept,
    this.level,
  });

  @override
  State<MixedQuizPage> createState() => _MixedQuizPageState();
}

class _MixedQuizPageState extends State<MixedQuizPage> {
  // 20 mixed questions (MCQ + True/False)
  final List<_MixedQuestion> _questions = [
    _MixedQuestion.mcq(
      text:
      'A 60-year-old woman presents with chest pain radiating to her left arm. ECG shows ST elevation. Which part of the circulatory system is blocked?',
      options: const ['Pulmonary vein', 'Coronary artery', 'Aorta', 'Superior vena cava'],
      correctIndex: 1,
    ),
    _MixedQuestion.tf(
      text: 'The cerebellum controls voluntary movement and balance.',
      correct: true,
    ),
    _MixedQuestion.tf(
      text: 'The axial skeleton includes the skull, vertebral column, and rib cage.',
      correct: true,
    ),
    _MixedQuestion.mcq(
      text:
      'A 12-year-old boy falls on his outstretched hand and sustains a fracture in his forearm. Which part of the skeletal system is injured?',
      options: const ['Radius and ulna', 'Femur', 'Humerus', 'Clavicle'],
      correctIndex: 0,
    ),
    _MixedQuestion.tf(
      text: 'Gas exchange between oxygen and carbon dioxide takes place in the alveoli.',
      correct: true,
    ),
    _MixedQuestion.mcq(
      text:
      'A patient complains of sudden loss of vision in the right eye. The doctor suspects damage to the optic nerve. Which cranial nerve is affected?',
      options: const ['Cranial nerve II', 'Cranial nerve III', 'Cranial nerve IV', 'Cranial nerve VI'],
      correctIndex: 0,
    ),
    _MixedQuestion.tf(
      text: 'The dermis contains sweat glands, sebaceous glands, and sensory receptors.',
      correct: true,
    ),
    _MixedQuestion.mcq(
      text:
      'A patient presents with tremors, rigidity, and difficulty initiating movements. Which part of the brain is primarily affected?',
      options: const ['Cerebellum', 'Basal ganglia', 'Hippocampus', 'Medulla'],
      correctIndex: 1,
    ),
    _MixedQuestion.tf(
      text: 'Melanin in the skin is produced by fibroblasts.',
      correct: false,
    ),
    _MixedQuestion.mcq(
      text:
      'A 45-year-old man presents with epigastric pain that worsens after meals. Endoscopy shows a gastric ulcer. Which organ of the digestive system is directly involved?',
      options: const ['Stomach', 'Liver', 'Esophagus', 'Pancreas'],
      correctIndex: 0,
    ),
    _MixedQuestion.tf(
      text: 'Cardiac muscle is involuntary and striated.',
      correct: true,
    ),
    _MixedQuestion.mcq(
      text:
      'A football player tears his quadriceps muscle during a game. Which type of muscle tissue is primarily affected?',
      options: const ['Smooth muscle', 'Skeletal muscle', 'Cardiac muscle', 'Involuntary muscle'],
      correctIndex: 1,
    ),
    _MixedQuestion.mcq(
      text:
      'A 65-year-old man suddenly develops left-sided paralysis and slurred speech. CT scan shows a stroke in the right middle cerebral artery. Which part of the nervous system is damaged?',
      options: const ['Cerebellum', 'Brainstem', 'Cerebral cortex', 'Spinal cord'],
      correctIndex: 2,
    ),
    _MixedQuestion.tf(
      text: 'Arteries always carry oxygenated blood, while veins always carry deoxygenated blood.',
      correct: false,
    ),
    _MixedQuestion.tf(
      text: 'The small intestine is the main site for nutrient absorption.',
      correct: true,
    ),
    _MixedQuestion.mcq(
      text:
      'A child falls and scrapes his knee, damaging only the epidermis and part of the dermis. What type of skin injury is this?',
      options: const ['First-degree burn', 'Partial-thickness injury', 'Full-thickness burn', 'Frostbite'],
      correctIndex: 1,
    ),
    _MixedQuestion.tf(
      text: 'The optic nerve carries motor signals that control eye movement.',
      correct: false,
    ),
    _MixedQuestion.mcq(
      text:
      'A 10-year-old child presents with shortness of breath and wheezing after playing outside. Which part of the respiratory system is most likely constricted?',
      options: const ['Trachea', 'Alveoli', 'Bronchioles', 'Nasal cavity'],
      correctIndex: 2,
    ),
    _MixedQuestion.mcq(
      text:
      'A patient presents with extensive burns involving all layers of the skin. What degree of burn is this?',
      options: const ['First degree', 'Second degree', 'Third degree', 'Superficial'],
      correctIndex: 2,
    ),
    _MixedQuestion.tf(
      text:
      'The cerebrum is responsible for higher cognitive functions such as thinking, memory, and decision-making.',
      correct: true,
    ),
  ];

  // Answers: TF -> bool, MCQ -> int (index)
  final Map<int, dynamic> _answers = {};
  int _current = 0;

  int get _total => _questions.length;
  int get _answeredCount => _answers.length;
  double get _progress => _total == 0 ? 0 : (_current + 1) / _total;
  bool get _isLast => _current == _total - 1;
  bool get _hasAnswerForCurrent => _answers.containsKey(_current);

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
                const Text(
                  'Review answers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Text(
                  'Answered $_answeredCount / $_total',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
                ),
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
          decoration:
          BoxDecoration(color: color, border: Border.all(color: border), borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _submit() {
    int correct = 0;
    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final a = _answers[i];
      if (q.isTF) {
        if (a is bool && a == q.correctTF) correct++;
      } else {
        if (a is int && a == q.correctIndex) correct++;
      }
    }
    final total = _questions.length;

    // انتقال إلى صفحة السكور وتمرير كل البيانات
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScorePage(
          role: widget.role,                 // الدور الحالي (student/nurse/doctor/supervisor)
          score: correct,                    // عدد الإجابات الصحيحة
          total: total,                      // عدد الأسئلة
          level: widget.level ?? 'Mixed',    // الاسم الظاهر للمستوى
          dept: widget.dept ?? 'General',    // القسم إن وجد
          userName: widget.userName ?? 'You',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_current];
    final currentValue = _answers[_current];

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
              'Mixed Quiz (T/F + MCQ)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87, height: 1.2),
            ),
            const SizedBox(height: 10),

            // Progress
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
              value: currentValue,
              onChanged: (val) => setState(() => _answers[_current] = val),
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

class _PagerDots extends StatelessWidget {
  final int current;
  final int total;
  final Map<int, dynamic> answered;
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
  final _MixedQuestion question;
  final dynamic value; // bool or int
  final ValueChanged<dynamic> onChanged;

  const _QuestionCard({
    super.key,
    required this.number,
    required this.question,
    required this.value,
    required this.onChanged,
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
          if (question.isTF) _tfRow() else _mcqList(),
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
      child: Text('Q$no',
          style: const TextStyle(color: kBrand, fontWeight: FontWeight.w900, letterSpacing: 0.2)),
    );
  }

  Widget _tfRow() {
    final bool? current = value is bool ? value as bool : null;
    return Row(
      children: [
        Expanded(child: _segChip(label: 'True', selected: current == true, onTap: () => onChanged(true))),
        const SizedBox(width: 10),
        Expanded(child: _segChip(label: 'False', selected: current == false, onTap: () => onChanged(false))),
      ],
    );
  }

  Widget _segChip({required String label, required bool selected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? kPill : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? kBrand : kStroke, width: 1.2),
        ),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w800, color: selected ? kBrand : Colors.black87),
        ),
      ),
    );
  }

  Widget _mcqList() {
    final int? current = value is int ? value as int : null;
    return Column(
      children: List.generate(question.options!.length, (i) {
        final selected = current == i;
        return _OptionTile(
          label: String.fromCharCode(65 + i),
          text: question.options![i],
          selected: selected,
          onTap: () => onChanged(i),
        );
      }),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label; // A / B / C...
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
            border: Border.all(color: selected ? kBrand : kStroke, width: 1.2),
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

class _MixedQuestion {
  final String text;
  final bool isTF;
  final bool? correctTF;       // for TF
  final List<String>? options; // for MCQ
  final int? correctIndex;     // for MCQ

  _MixedQuestion.tf({
    required this.text,
    required bool correct,
  })  : isTF = true,
        correctTF = correct,
        options = null,
        correctIndex = null;

  _MixedQuestion.mcq({
    required this.text,
    required this.options,
    required this.correctIndex,
  })  : isTF = false,
        correctTF = null;
}

class _TopBrandBar extends StatelessWidget {
  const _TopBrandBar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        // أزلت أي رسم إضافي حتى ما يطلع شكل جانبي مزعج
        SizedBox(height: 70, width: double.infinity),
        Row(
          children: [
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
