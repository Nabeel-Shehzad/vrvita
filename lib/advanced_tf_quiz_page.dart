// lib/advanced_tf_quiz_page.dart
import 'package:flutter/material.dart';
import 'quiz_score_page.dart'; // يستخدم UserRole + صفحة السكور

const kBrand = Color(0xFF2F5B89);
const kPill = Color(0xFFE8F1FF);
const kStroke = Color(0xFFE1E5EC);

class AdvancedTfQuizPage extends StatefulWidget {
  final UserRole role;      // student / nurse / doctor / supervisor
  final String? userName;   // Optional
  final String? dept;       // Optional
  final String? level;      // افتراضي: Advanced

  const AdvancedTfQuizPage({
    super.key,
    this.role = UserRole.student,
    this.userName,
    this.dept,
    this.level = 'Advanced',
  });

  @override
  State<AdvancedTfQuizPage> createState() => _AdvancedTfQuizPageState();
}

class _AdvancedTfQuizPageState extends State<AdvancedTfQuizPage> {
  // 10 True/False (Advanced) — جميعها True كما زوّدتني
  final List<_TfQuestion> _questions = const [
    _TfQuestion(
      'A 55-year-old male with chronic alcohol use presents with severe epigastric pain radiating to the back. Labs show elevated amylase and lipase.\n'
          'Q: The primary pathology here lies in the digestive system’s exocrine pancreas function.',
      true,
    ),
    _TfQuestion(
      'A 30-year-old woman develops sudden dyspnea and chest pain after a long flight. CT pulmonary angiography confirms pulmonary embolism.\n'
          'Q: This condition primarily disrupts the respiratory system’s ability to maintain adequate gas exchange.',
      true,
    ),
    _TfQuestion(
      'A 45-year-old diabetic patient presents with sudden vision loss in one eye. Fundoscopy shows cotton-wool spots and microaneurysms.\n'
          'Q: The vision loss is due to damage in the neural component of the eye rather than its optical structures.',
      true,
    ),
    _TfQuestion(
      'A 68-year-old hypertensive patient suddenly develops right-sided weakness and slurred speech. MRI shows an infarct in the left middle cerebral artery territory.\n'
          'Q: This stroke represents a primary disorder of the nervous system brain.',
      true,
    ),
    _TfQuestion(
      'A 25-year-old man presents with generalized tonic-clonic seizures. EEG shows abnormal widespread cortical discharges.\n'
          'Q: Epilepsy is a disorder of the nervous system involving abnormal electrical activity in the brain.',
      true,
    ),
    _TfQuestion(
      'A 62-year-old male presents with chest pain on exertion. Angiography reveals 90% occlusion of the left anterior descending artery.\n'
          'Q: This condition compromises the circulatory system’s ability to supply oxygenated blood to the myocardium.',
      true,
    ),
    _TfQuestion(
      'A 32-year-old woman complains of progressive muscle weakness that worsens with activity and improves with rest. Anti-acetylcholine receptor antibodies are positive.\n'
          'Q: This is a primary muscular system disorder due to impaired neuromuscular transmission.',
      true,
    ),
    _TfQuestion(
      'A 70-year-old postmenopausal woman presents with vertebral fractures after minimal trauma. DEXA scan shows reduced bone mineral density.\n'
          'Q: Osteoporosis is a skeletal system disorder characterized by decreased bone mass and fragility.',
      true,
    ),
    _TfQuestion(
      'A 40-year-old farmer develops painful blisters and widespread skin necrosis after exposure to toxic chemicals.\n'
          'Q: The skin, as the largest organ of the body, acts as the first line of defense against environmental insults.',
      true,
    ),
    _TfQuestion(
      'A 25-year-old patient sustains 45% partial-thickness burns involving only the anterior half of the body.\n'
          'Q: Severe burns limited to half the skin surface can still cause life-threatening fluid and electrolyte imbalance.',
      true,
    ),
  ];

  final Map<int, bool> _answers = {}; // index -> true/false
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
            left: 16, right: 16, top: 12,
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
                    width: 44, height: 5, margin: const EdgeInsets.only(bottom: 10),
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
          width: 16, height: 16,
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

  void _submit() {
    int correct = 0;
    for (int i = 0; i < _questions.length; i++) {
      final a = _answers[i];
      if (a != null && a == _questions[i].answer) correct++;
    }
    final total = _questions.length;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScorePage(
          role: widget.role,
          score: correct,
          total: total,
          level: widget.level ?? 'Advanced',
          dept: widget.dept ?? 'General',
          userName: widget.userName ?? 'You',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_current];
    final bool? currentValue = _answers[_current];

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
              'Advanced Quiz — True / False',
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
              answered: _answers.map((k, v) => MapEntry(k, v as Object)),
              onTap: (i) => setState(() => _current = i),
            ),
            const SizedBox(height: 12),

            _QuestionCard(
              number: _current + 1,
              text: q.text,
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
  final Map<int, Object> answered; // presence only
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
  final String text;
  final bool? value; // true / false / null
  final ValueChanged<bool> onChanged;

  const _QuestionCard({
    super.key,
    required this.number,
    required this.text,
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
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _segChip(label: 'True',  selected: value == true,  onTap: () => onChanged(true))),
              const SizedBox(width: 10),
              Expanded(child: _segChip(label: 'False', selected: value == false, onTap: () => onChanged(false))),
            ],
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
      child: Text('Q$no',
          style: const TextStyle(color: kBrand, fontWeight: FontWeight.w900, letterSpacing: 0.2)),
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
}

class _TfQuestion {
  final String text;
  final bool answer;
  const _TfQuestion(this.text, this.answer);
}

class _TopBrandBar extends StatelessWidget {
  const _TopBrandBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        SizedBox(height: 70),
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
    );
  }
}
