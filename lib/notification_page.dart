// lib/notification_page.dart
import 'package:flutter/material.dart';
import 'vr_upcoming_appointments_page.dart'; // ✅ للانتقال لصفحة المواعيد

const kBrand = Color(0xFF2F5B89);
const kPanel = Color(0xFFEFF4FA);

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<_Notif> _items = [
    _Notif("Upcoming VR appointment available", "15 Min", isNew: true),
    _Notif("Reminder: select your time slot", "15 Min", isNew: true),
    _Notif("New dates released for this week", "15 Min", isNew: true),
    _Notif("Your last session summary is ready", "15 Min"),
    _Notif("Policy update for ICU scenarios", "15 Min"),
    _Notif("Training tip: PLUS/DELTA debrief", "15 Min"),
  ];

  void _openAppointments() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VrUpcomingAppointmentsPage()),
    );
    // بعد الرجوع من صفحة المواعيد نقدر نحدّث الحالة لو نبي
    setState(() {
      for (final n in _items) n.isNew = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0, backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text("Notification", style: TextStyle(color: kBrand, fontWeight: FontWeight.w800)),
        actions: [
          TextButton.icon(
            onPressed: _openAppointments,
            icon: const Icon(Icons.calendar_month_rounded, color: kBrand),
            label: const Text("VR Appointments", style: TextStyle(color: kBrand, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Row(
              children: [
                const Text("New", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800, fontSize: 16)),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() { for (final n in _items) n.isNew = false; }),
                  child: const Text("Mark All", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // القائمة
            ..._items.map((n) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _NotifCard(
                title: n.title,
                timeText: n.timeText,
                isNew: n.isNew,
                onTap: () async {
                  setState(() => n.isNew = false);
                  // ✅ أي تنبيه يفتح صفحة المواعيد
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VrUpcomingAppointmentsPage()),
                  );
                },
              ),
            )),
            const SizedBox(height: 8),

            Center(
              child: TextButton(
                onPressed: _openAppointments,
                child: const Text("See All Appointments",
                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final String title;
  final String timeText;
  final bool isNew;
  final VoidCallback? onTap;

  const _NotifCard({required this.title, required this.timeText, required this.isNew, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kPanel, borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 6))],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded, color: kBrand, size: 24),
                if (isNew)
                  Positioned(
                    right: -2, top: -2,
                    child: Container(
                      width: 9, height: 9,
                      decoration: BoxDecoration(
                        color: Colors.redAccent, shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w800)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x22000000)),
              ),
              child: Text(timeText, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87)),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}

class _Notif {
  final String title;
  final String timeText;
  bool isNew;
  _Notif(this.title, this.timeText, {this.isNew = false});
}
