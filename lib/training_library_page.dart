// lib/training_library_page.dart
import 'package:flutter/material.dart';
import 'quiz_score_page.dart' show UserRole; // نستخدم enum UserRole الموجود عندك

const kBrand = Color(0xFF2F5B89);
const kPanel  = Color(0xFFEFF4FA);

class TrainingLibraryPage extends StatelessWidget {
  final UserRole role; // Doctor / Nurse / Student
  const TrainingLibraryPage({super.key, required this.role});

  // موارد بسيطة لكل دور
  static const List<_ResourceView> _seed = [
    _ResourceView(
      title: "Hand Hygiene (Basics)",
      type: "Checklist",
      meta: "5m • training",
      roles: {UserRole.nurse, UserRole.student, UserRole.doctor}, // للجميع
    ),
    _ResourceView(
      title: "Airway: BVM Intro",
      type: "Scenario",
      meta: "12m • ER",
      roles: {UserRole.nurse, UserRole.doctor},
    ),
    _ResourceView(
      title: "Ventilator Quick Start",
      type: "Video",
      meta: "7m • ICU",
      roles: {UserRole.doctor},
    ),
    _ResourceView(
      title: "Debrief Template (PLUS/DELTA)",
      type: "PDF",
      meta: "template",
      roles: {UserRole.nurse, UserRole.doctor, UserRole.student},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // فلترة حسب الدور
    final data = _seed.where((e) => e.roles.contains(role)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0, backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          "Training • ${_roleLabel(role)}",
          style: const TextStyle(color: kBrand, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: data.length + 2, // Search + عنوان + الموارد
          itemBuilder: (context, i) {
            if (i == 0) {
              return TextField(
                readOnly: true, // UI فقط
                decoration: InputDecoration(
                  hintText: "Search…",
                  prefixIcon: const Icon(Icons.search),
                  filled: true, fillColor: kPanel,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              );
            }
            if (i == 1) {
              return const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 8),
                child: Text(
                  "Quick Training Resources",
                  style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
                ),
              );
            }
            final item = data[i - 2];
            return _ResourceCard(view: item);
          },
        ),
      ),
    );
  }

  String _roleLabel(UserRole r) {
    switch (r) {
      case UserRole.doctor: return "Doctor";
      case UserRole.nurse: return "Nurse";
      case UserRole.student: return "Student";
      default: return "Role";
    }
  }
}

class _ResourceView {
  final String title;
  final String type; // Video / PDF / Checklist / Scenario
  final String meta; // "5m • training" أو "ICU"
  final Set<UserRole> roles;
  const _ResourceView({
    required this.title,
    required this.type,
    required this.meta,
    required this.roles,
  });
}

class _ResourceCard extends StatelessWidget {
  final _ResourceView view;
  const _ResourceCard({required this.view});

  IconData get _icon {
    switch (view.type) {
      case "Video": return Icons.play_circle_outline;
      case "PDF": return Icons.picture_as_pdf_outlined;
      case "Checklist": return Icons.checklist_outlined;
      case "Scenario": return Icons.assignment_outlined;
      default: return Icons.insert_drive_file_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kPanel,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_icon, color: kBrand, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  view.title,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6, runSpacing: 4,
                  children: [
                    _chip(view.type),
                    _chip(view.meta),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, color: Colors.black38, size: 18),
        ],
      ),
    );
  }

  Widget _chip(String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0x16000000)),
    ),
    child: Text(
      t,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    ),
  );
}
