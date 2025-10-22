// lib/quiz_score_page.dart
import 'package:flutter/material.dart';

const kBrand = Color(0xFF2F5B89);
const kPill = Color(0xFFE8F1FF);

// موحّد مع صفحة الميكسد
enum UserRole { student, nurse, doctor, supervisor }

class QuizScorePage extends StatefulWidget {
  /// بيانات قادمة من صفحة الاختبار
  final UserRole? role;
  final int? score;     // صحيح
  final int? total;     // عدد الأسئلة
  final String? level;  // المستوى الذي حل فيه
  final String? dept;   // القسم
  final String? userName;

  const QuizScorePage({
    super.key,
    this.role,
    this.score,
    this.total,
    this.level,
    this.dept,
    this.userName,
  });

  @override
  State<QuizScorePage> createState() => _QuizScorePageState();
}

class _QuizScorePageState extends State<QuizScorePage> with SingleTickerProviderStateMixin {
  late final TabController _tab;
  String _levelFilter = 'All';
  String _deptFilter = 'All';

  final _levels = const ['All', 'Basic', 'Intermediate', 'Advanced'];
  final _depts = const ['All', 'ER', 'Surgery', 'ICU', 'Pediatrics'];

  UserRole get _role => widget.role ?? UserRole.student;
  bool get _isSupervisor => _role == UserRole.supervisor;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _isSupervisor ? 2 : 1, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = (widget.score != null && widget.total != null && widget.total! > 0)
        ? ((widget.score! / widget.total!) * 100).round()
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, toolbarHeight: 0),
      body: SafeArea(
        child: Column(
          children: [
            const _TopBrandBar(),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _isSupervisor ? "Quiz Scores" : "Your Quiz Score",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // فلتر يظهر فقط للسوبرفايزر
            if (_isSupervisor)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _FiltersRow(
                  level: _levelFilter,
                  dept: _deptFilter,
                  levels: _levels,
                  depts: _depts,
                  onLevel: (v) => setState(() => _levelFilter = v),
                  onDept: (v) => setState(() => _deptFilter = v),
                ),
              ),

            if (_isSupervisor) const SizedBox(height: 8),

            if (_isSupervisor)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE1E5EC)),
                ),
                child: TabBar(
                  controller: _tab,
                  indicator: BoxDecoration(color: kPill, borderRadius: BorderRadius.circular(12)),
                  labelColor: kBrand,
                  unselectedLabelColor: Colors.black54,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(icon: Icon(Icons.groups_rounded), text: 'Team'),
                    Tab(icon: Icon(Icons.person_rounded), text: 'Individual'),
                  ],
                ),
              ),

            if (_isSupervisor) const SizedBox(height: 10),

            Expanded(
              child: _isSupervisor
                  ? TabBarView(
                controller: _tab,
                children: [
                  // TEAM (عينات – اربطها لاحقًا بباك-إندك)
                  ListView(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 16),
                    children: const [
                      _TeamScoreCard(teamName: "Team A (ER)", avg: 86, attempts: 42, best: 98, trendUp: true),
                      _TeamScoreCard(teamName: "Team B (Surgery)", avg: 78, attempts: 37, best: 94, trendUp: false),
                      _TeamScoreCard(teamName: "Team C (ICU)", avg: 82, attempts: 25, best: 96, trendUp: true),
                    ],
                  ),

                  // INDIVIDUAL (يعرض نتيجتك إن توفرت)
                  _IndividualListView(
                    entries: [
                      if (widget.score != null && widget.total != null)
                        _PersonEntry(
                          name: widget.userName ?? "User",
                          dept: widget.dept ?? "General",
                          level: widget.level ?? "Mixed",
                          score: (((widget.score! / widget.total!) * 100).round()),
                          attempts: 1,
                        ),
                      // أمثلة إضافية – يمكن حذفها أو استبدالها
                      const _PersonEntry(
                          name: "Member 1", dept: "ER", level: "Advanced", score: 91, attempts: 3),
                      const _PersonEntry(
                          name: "Member 2", dept: "Surgery", level: "Intermediate", score: 84, attempts: 2),
                    ],
                  ),
                ],
              )
                  : _IndividualListView(
                entries: [
                  _PersonEntry(
                    name: widget.userName ?? "You",
                    dept: widget.dept ?? "General",
                    level: widget.level ?? "Mixed",
                    score: percent ?? 0,
                    attempts: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IndividualListView extends StatelessWidget {
  final List<_PersonEntry> entries;
  const _IndividualListView({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 16),
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final e = entries[i];
        return _PersonScoreCard(
          name: e.name,
          dept: e.dept,
          level: e.level,
          score: e.score,
          attempts: e.attempts,
        );
      },
    );
  }
}

class _PersonEntry {
  final String name, dept, level;
  final int score, attempts;
  const _PersonEntry({
    required this.name,
    required this.dept,
    required this.level,
    required this.score,
    required this.attempts,
  });
}

class _FiltersRow extends StatelessWidget {
  final String level, dept;
  final List<String> levels, depts;
  final ValueChanged<String> onLevel, onDept;

  const _FiltersRow({
    super.key,
    required this.level,
    required this.dept,
    required this.levels,
    required this.depts,
    required this.onLevel,
    required this.onDept,
  });

  @override
  Widget build(BuildContext context) {
    Widget drop({
      required String label,
      required String value,
      required List<String> items,
      required ValueChanged<String> onChanged,
      IconData icon = Icons.tune_rounded,
    }) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE1E5EC)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => v == null ? null : onChanged(v),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black87),
              hint: Row(
                children: [
                  Icon(icon, color: Colors.black45, size: 18),
                  const SizedBox(width: 6),
                  Text(label, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        drop(label: 'Level', value: level, items: levels, onChanged: onLevel, icon: Icons.layers_rounded),
        const SizedBox(width: 10),
        drop(label: 'Department', value: dept, items: depts, onChanged: onDept, icon: Icons.apartment_rounded),
      ],
    );
  }
}

class _TeamScoreCard extends StatelessWidget {
  final String teamName;
  final int avg;
  final int attempts;
  final int best;
  final bool trendUp;

  const _TeamScoreCard({
    super.key,
    required this.teamName,
    required this.avg,
    required this.attempts,
    required this.best,
    required this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF9FBEEC),
            child: Icon(trendUp ? Icons.trending_up_rounded : Icons.trending_down_rounded, color: kBrand),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(teamName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: kBrand)),
              const SizedBox(height: 4),
              Text("Attempts: $attempts  •  Best: $best",
                  style: const TextStyle(color: Colors.black54, fontSize: 12)),
            ]),
          ),
          _ScoreBadge(score: avg),
        ],
      ),
    );
  }
}

class _PersonScoreCard extends StatelessWidget {
  final String name;
  final String dept;
  final String level;
  final int score;
  final int attempts;

  const _PersonScoreCard({
    super.key,
    required this.name,
    required this.dept,
    required this.level,
    required this.score,
    required this.attempts,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Row(
        children: [
          const CircleAvatar(radius: 24, backgroundImage: AssetImage('assets/images/profile.jpg')),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: kBrand)),
              const SizedBox(height: 4),
              Text("$dept • $level • Attempts: $attempts",
                  style: const TextStyle(color: Colors.black54, fontSize: 12)),
            ]),
          ),
          _ScoreBadge(score: score),
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final int score;
  const _ScoreBadge({super.key, required this.score});

  Color _colorFor(int s) {
    if (s >= 90) return const Color(0xFF2ECC71);
    if (s >= 75) return const Color(0xFFF1C40F);
    return const Color(0xFFE74C3C);
  }

  @override
  Widget build(BuildContext context) {
    final c = _colorFor(score);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.withOpacity(0.6)),
      ),
      child: Text("$score",
          style: TextStyle(color: c, fontWeight: FontWeight.w900, letterSpacing: 0.4, fontSize: 16)),
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.black12,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          child: Padding(padding: const EdgeInsets.all(12), child: child),
        ),
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
