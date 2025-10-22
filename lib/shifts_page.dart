import 'package:flutter/material.dart';

const kBrand = Color(0xFF2F5B89);

class ShiftsPage extends StatefulWidget {
  const ShiftsPage({super.key});

  @override
  State<ShiftsPage> createState() => _ShiftsPageState();
}

class _ShiftsPageState extends State<ShiftsPage> {
  String _filter = "Upcoming"; // Upcoming / Past / All

  final List<_Shift> _shifts = [
    _Shift("Morning Shift", "ER Department", DateTime.now().add(const Duration(hours: 2)), "Upcoming"),
    _Shift("Night Shift", "ICU Department", DateTime.now().add(const Duration(days: 1)), "Upcoming"),
    _Shift("Morning Shift", "Ward A", DateTime.now().subtract(const Duration(days: 1)), "Past"),
  ];

  List<_Shift> get _filtered {
    if (_filter == "All") return _shifts;
    return _shifts.where((s) => s.status == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Shifts", style: TextStyle(color: kBrand, fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: kBrand),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // فلتر
            Wrap(
              spacing: 8,
              children: ["Upcoming", "Past", "All"].map((f) {
                final sel = _filter == f;
                return ChoiceChip(
                  label: Text(f),
                  selected: sel,
                  selectedColor: kBrand,
                  labelStyle: TextStyle(
                    color: sel ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() => _filter = f),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            if (items.isEmpty)
              const Center(child: Text("No shifts found.", style: TextStyle(color: Colors.black54)))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) => _ShiftCard(shift: items[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Shift {
  final String title;
  final String location;
  final DateTime date;
  final String status; // Upcoming / Past

  _Shift(this.title, this.location, this.date, this.status);
}

class _ShiftCard extends StatelessWidget {
  final _Shift shift;
  const _ShiftCard({required this.shift});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x11000000)),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule_rounded, color: kBrand, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shift.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(shift.location, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 4),
                Text(
                  "${shift.date.day}/${shift.date.month}/${shift.date.year} "
                      "${shift.date.hour}:${shift.date.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: shift.status == "Upcoming" ? Colors.green.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              shift.status,
              style: TextStyle(
                color: shift.status == "Upcoming" ? Colors.green.shade800 : Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
