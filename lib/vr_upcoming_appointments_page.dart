// lib/vr_upcoming_appointments_page.dart  (محدّث للتقويم بدون Overflow)
import 'package:flutter/material.dart';

const kBrand = Color(0xFF2F5B89);
const kPanel = Color(0xFFEFF4FA);

class VrUpcomingAppointmentsPage extends StatefulWidget {
  const VrUpcomingAppointmentsPage({super.key});

  @override
  State<VrUpcomingAppointmentsPage> createState() => _VrUpcomingAppointmentsPageState();
}

class _VrUpcomingAppointmentsPageState extends State<VrUpcomingAppointmentsPage> {
  DateTime _visibleMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDay;

  final List<String> _timeSlots = ["10:00 AM","11:00 AM","12:00 PM","01:00 PM","02:00 PM","03:00 PM"];
  String? _selectedSlot;

  static const _monthNames = [
    "January","February","March","April","May","June","July","August","September","October","November","December"
  ];

  @override
  Widget build(BuildContext context) {
    final days = _buildMonthDays(_visibleMonth);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0, backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text("VR Upcoming Appointments", style: TextStyle(color: kBrand, fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 4),
            const Text("Select Date And Time", textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),

            // Calendar Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 24, offset: Offset(0, 12))],
              ),
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      _arrowBtn(Icons.chevron_left, () {
                        setState(() {
                          _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
                        });
                      }),
                      Expanded(
                        child: Center(
                          child: Text(
                            "${_monthNames[_visibleMonth.month - 1]} ${_visibleMonth.year}",
                            style: const TextStyle(fontWeight: FontWeight.w800, color: kBrand, fontSize: 16),
                          ),
                        ),
                      ),
                      _arrowBtn(Icons.chevron_right, () {
                        setState(() {
                          _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
                        });
                      }),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: const [
                      _WeekLabel("SUN"), _WeekLabel("MON"), _WeekLabel("TUE"),
                      _WeekLabel("WED"), _WeekLabel("THU"), _WeekLabel("FRI"), _WeekLabel("SAT"),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // FIX: childAspectRatio يمنع أي Overflow
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: days.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7, mainAxisSpacing: 6, crossAxisSpacing: 6, childAspectRatio: 1.15,
                    ),
                    itemBuilder: (context, i) {
                      final d = days[i];
                      final inMonth = d.month == _visibleMonth.month;
                      final selected = _selectedDay != null && _isSameDate(_selectedDay!, d);
                      final today = _isSameDate(d, DateTime.now());

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: inMonth ? () => setState(() => _selectedDay = d) : null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: selected ? kBrand : (today && inMonth ? kPanel : Colors.white),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: selected ? kBrand : const Color(0x11000000)),
                            ),
                            child: Center(
                              child: Text(
                                "${d.day}",
                                style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700,
                                  color: selected ? Colors.white : (inMonth ? Colors.black87 : Colors.black26),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),
            const Text("Available Time Slot", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),

            Wrap(
              spacing: 12, runSpacing: 12,
              children: _timeSlots.map((slot) {
                final selected = _selectedSlot == slot;
                return ChoiceChip(
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(slot, style: TextStyle(fontWeight: FontWeight.w600, color: selected ? Colors.white : Colors.black87)),
                  ),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedSlot = slot),
                  selectedColor: kBrand,
                  backgroundColor: Colors.white,
                  shape: StadiumBorder(side: BorderSide(color: selected ? kBrand : const Color(0x22000000))),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBrand, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: (_selectedDay != null && _selectedSlot != null)
                    ? () {
                  final d = _selectedDay!;
                  final date = "${_monthNames[d.month - 1]} ${d.day}, ${d.year}";
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Appointment set on $date at $_selectedSlot")),
                  );
                }
                    : null,
                child: const Text("Set Appointment", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  List<DateTime> _buildMonthDays(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final start = first.subtract(Duration(days: first.weekday % 7));
    return List.generate(42, (i) => DateTime(start.year, start.month, start.day + i));
  }

  static bool _isSameDate(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _arrowBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: kPanel, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: kBrand),
      ),
    );
  }
}

class _WeekLabel extends StatelessWidget {
  final String text;
  const _WeekLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text, textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w700),
      ),
    );
  }
}
