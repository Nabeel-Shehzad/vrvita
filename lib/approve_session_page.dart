// lib/approve_session_page.dart
import 'package:flutter/material.dart';

const kBrand = Color(0xFF2F5B89);

class ApproveSessionPage extends StatefulWidget {
  const ApproveSessionPage({super.key});

  @override
  State<ApproveSessionPage> createState() => _ApproveSessionPageState();
}

class _ApproveSessionPageState extends State<ApproveSessionPage> {
  final List<_Session> _items = [
    _Session("Basic VR Training", "Student • ER", DateTime.now().subtract(const Duration(days: 1))),
    _Session("Intermediate TF Quiz", "Nurse • ICU", DateTime.now().subtract(const Duration(days: 2))),
    _Session("MCQ Practice", "Student • Pediatrics", DateTime.now().subtract(const Duration(hours: 10))),
  ];

  void _approve(int i) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Approved: ${_items[i].title}")));
    setState(() => _items.removeAt(i));
  }

  void _reject(int i) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Rejected: ${_items[i].title}")));
    setState(() => _items.removeAt(i));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approve Sessions", style: TextStyle(color: kBrand, fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final s = _items[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.white,
              elevation: 3,
              shadowColor: Colors.black12,
              borderRadius: BorderRadius.circular(14),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFF9FBEEC), child: Icon(Icons.vrpano, color: kBrand)),
                title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.w800, color: kBrand)),
                subtitle: Text("${s.meta}\n${s.when}"),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: () => _reject(i),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                      child: const Text("Reject"),
                    ),
                    FilledButton(
                      onPressed: () => _approve(i),
                      style: FilledButton.styleFrom(backgroundColor: kBrand),
                      child: const Text("Approve"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Session {
  final String title;
  final String meta;
  final String when;
  _Session(this.title, this.meta, DateTime time)
      : when = "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} "
      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
}
