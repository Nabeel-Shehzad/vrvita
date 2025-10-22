// lib/student_home_page.dart
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'tutorial_page.dart';
import 'faqs_page.dart';
import 'quiz_page.dart';
import 'quiz_score_page.dart' show QuizScorePage, UserRole;
import 'contact_us_page.dart';
import 'vr_upcoming_appointments_page.dart';
import 'training_library_page.dart';      // ✅ مكتبة التدريب
import 'notification_page.dart';         // ✅ صفحة الإشعارات

const kBrand = Color(0xFF2F5B89);

class StudentHomePage extends StatefulWidget {
  final String? userName;
  final String? organization;
  final String? specialization;
  final ImageProvider? avatarImage;

  const StudentHomePage({
    super.key,
    this.userName,
    this.organization,
    this.specialization,
    this.avatarImage,
  });

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  int _notifCount = 3;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => StudentHomePage(
              userName: widget.userName,
              organization: widget.organization,
              specialization: widget.specialization,
              avatarImage: widget.avatarImage,
            ),
          ),
              (r) => false,
        );
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const VrUpcomingAppointmentsPage()));
        break;
      case 2:
        _navigateTo(context, "Profile");
        break;
      case 3:
        _navigateTo(context, "Settings");
        break;
    }
  }

  static void _navigateTo(BuildContext context, String title) {
    switch (title) {
      case "Tutorials":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TutorialPage()));
        break;
      case "FAQs":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FaqsPage()));
        break;
      case "Quiz":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizPage()));
        break;
      case "Quiz Score":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const QuizScorePage(role: UserRole.student)));
        break;
      case "Contact Us":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const ContactUsPage(role: UserRole.student)));
        break;
      case "Training Library & Resources":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const TrainingLibraryPage(role: UserRole.student)));
        break;
      case "Upcoming Appointments":
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const VrUpcomingAppointmentsPage()));
        break;
      case "Notifications":
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const NotificationPage()));
        break;
      default:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => _PlaceholderPage(title: title)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar:
      AppBar(backgroundColor: Colors.white, elevation: 0, toolbarHeight: 0),
      drawer: const _MainDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          children: [
            _TopBrandBar(
              onMenu: () => _scaffoldKey.currentState?.openDrawer(),
              notifCount: _notifCount,
              onBell: () => _navigateTo(context, "Notifications"),
              onHeadset: () => _navigateTo(context, "Contact Us"),
            ),
            const SizedBox(height: 8),
            const Text("Overview",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            _ProfileCapsule(
              name: widget.userName ?? "",
              org: widget.organization ?? "",
              spec: widget.specialization ?? "",
              avatar: widget.avatarImage ??
                  const AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(height: 26),
            const Text("Services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),

            _ServiceChipImage(
              label: "Quiz",
              image: "assets/images/quiz.jpg",
              onTap: () => _navigateTo(context, "Quiz"),
            ),
            _ServiceChipImage(
              label: "Tutorials",
              image: "assets/images/Tutorials.jpg",
              onTap: () => _navigateTo(context, "Tutorials"),
            ),
            _ServiceChipImage(
              label: "Upcoming Appointments",
              image: "assets/images/appointments.jpg",
              onTap: () => _navigateTo(context, "Upcoming Appointments"),
            ),
            _ServiceChipImage(
              label: "My Quiz Score",
              image: "assets/images/score.jpg",
              onTap: () => _navigateTo(context, "Quiz Score"),
            ),
            _ServiceChipImage(
              label: "Training Library & Resources",
              image: "assets/images/appointments.jpg",
              onTap: () => _navigateTo(context, "Training Library & Resources"),
            ),
            _ServiceChipImage(
              label: "Contact Us",
              image: "assets/images/appointments.jpg",
              onTap: () => _navigateTo(context, "Contact Us"),
            ),

            const SizedBox(height: 86),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: kBrand,
        unselectedItemColor: Colors.black45,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}

// ======== Widgets ========

class _TopBrandBar extends StatelessWidget {
  final VoidCallback onMenu;
  final int notifCount;
  final VoidCallback onBell;
  final VoidCallback onHeadset;
  const _TopBrandBar(
      {required this.onMenu,
        required this.notifCount,
        required this.onBell,
        required this.onHeadset});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            height: 70,
            width: double.infinity,
            child: CustomPaint(painter: _HeaderShapePainter())),
        Row(
          children: [
            IconButton(
                icon: const Icon(Icons.menu, size: 28, color: Colors.black87),
                onPressed: onMenu),
            const Spacer(),
            const Text(
              "VRVITA",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: kBrand,
                  letterSpacing: 1.2),
            ),
            const Spacer(),
            IconButton(
                icon: const Icon(Icons.headset_mic_rounded, color: Colors.black87),
                onPressed: onHeadset),
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_rounded,
                      color: Colors.black87),
                  onPressed: onBell,
                ),
                if (notifCount > 0)
                  Positioned(
                    right: 10,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      constraints:
                      const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Center(
                        child: Text(
                          "$notifCount",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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

class _ProfileCapsule extends StatelessWidget {
  final String name;
  final String org;
  final String spec;
  final ImageProvider avatar;

  const _ProfileCapsule(
      {super.key,
        required this.name,
        required this.org,
        required this.spec,
        required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
      decoration: BoxDecoration(
          color: const Color(0xFFE8F1FF),
          borderRadius: BorderRadius.circular(28)),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundImage: avatar),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                Text("($org)",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                Text("Specialization: $spec",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceChipImage extends StatelessWidget {
  final String label;
  final String image;
  final VoidCallback onTap;

  const _ServiceChipImage(
      {required this.label, required this.image, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 92,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 3))
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(image,
                  fit: BoxFit.cover, width: double.infinity, height: double.infinity),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.10),
                      Colors.black.withOpacity(0.25)
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border:
                  Border.all(color: Colors.black.withOpacity(0.55), width: 1),
                ),
              ),
            ),
            Center(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainDrawer extends StatelessWidget {
  const _MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    ListTile item(IconData icon, String title) => ListTile(
      leading: Icon(icon, color: kBrand),
      title: Text(title,
          style:
          const TextStyle(fontWeight: FontWeight.w600, color: kBrand)),
      onTap: () {
        Navigator.pop(context);
        _StudentHomePageState._navigateTo(context, title);
      },
    );

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            ListTile(
              leading: const CircleAvatar(
                  backgroundColor: Color(0xFF9FBEEC),
                  child: Icon(Icons.person, color: kBrand)),
              trailing: IconButton(
                icon: const Icon(Icons.home_rounded, color: kBrand),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const StudentHomePage()),
                        (route) => false,
                  );
                },
              ),
            ),
            const Divider(),
            item(Icons.account_circle_rounded, "Account"),
            item(Icons.local_library_rounded, "Training Library & Resources"),
            item(Icons.menu_book_rounded, "Tutorials"),
            item(Icons.help_outline_rounded, "FAQs"),
            item(Icons.quiz_rounded, "Quiz"),
            item(Icons.leaderboard_rounded, "Quiz Score"),
            item(Icons.support_agent_rounded, "Contact Us"),
            item(Icons.notifications_active_rounded, "Notifications"),
            item(Icons.settings_rounded, "Settings"),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: kBrand),
              title: const Text("Logout",
                  style: TextStyle(fontWeight: FontWeight.w600, color: kBrand)),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kBrand,
          foregroundColor: Colors.white,
          title: Text(title)),
      body: Center(
          child: Text(title,
              style: const TextStyle(fontSize: 22, color: kBrand))),
    );
  }
}
