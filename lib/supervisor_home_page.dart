import 'package:flutter/material.dart';
import 'login_page.dart';
import 'tutorial_page.dart';
import 'faqs_page.dart';
import 'quiz_score_page.dart' show QuizScorePage, UserRole;
import 'team_report_page.dart';
import 'approve_session_page.dart';
import 'contact_us_page.dart';
import 'vr_upcoming_appointments_page.dart';
import 'profile_page.dart'; // ✅ Profile
import 'settings_page.dart'; // ✅ Settings
import 'account_page.dart'; // ✅ Account

const kBrand = Color(0xFF2F5B89);

class SupervisorHomePage extends StatefulWidget {
  final String? userName;
  final String? organization;
  final String? department;
  final ImageProvider? avatarImage;

  const SupervisorHomePage({
    super.key,
    this.userName,
    this.organization,
    this.department,
    this.avatarImage,
  });

  @override
  State<SupervisorHomePage> createState() => _SupervisorHomePageState();
}

class _SupervisorHomePageState extends State<SupervisorHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => SupervisorHomePage(
              userName: widget.userName,
              organization: widget.organization,
              department: widget.department,
              avatarImage: widget.avatarImage,
            ),
          ),
          (r) => false,
        );
        break;
      case 1:
        // ✅ أيقونة "Appointments" تفتح صفحة المواعيد
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VrUpcomingAppointmentsPage()),
        );
        break;
      case 2:
        _open(context, "Profile", userName: widget.userName);
        break;
      case 3:
        _open(context, "Settings", userName: widget.userName);
        break;
    }
  }

  static void _open(BuildContext context, String title, {String? userName}) {
    switch (title) {
      case "Quiz Scores (Team)":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const QuizScorePage(role: UserRole.supervisor),
          ),
        );
        return;
      case "Team Reports":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TeamReportPage()),
        );
        return;
      case "Approve Sessions":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ApproveSessionPage()),
        );
        return;
      case "Contact Us":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ContactUsPage(role: UserRole.supervisor),
          ),
        );
        return;
      case "Appointments":
      case "Upcoming Appointments":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VrUpcomingAppointmentsPage()),
        );
        return;
      case "Profile": // ✅ Profile page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfilePage(userName: userName ?? ''),
          ),
        );
        return;
      case "Settings": // ✅ Settings page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        );
        return;
      case "Account": // ✅ Account page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AccountPage()),
        );
        return;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => _PlaceholderPage(title: title)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.userName ?? "Supervisor";
    final org = widget.organization ?? "Organization";
    final dept = widget.department ?? "Management";

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          "VRVITA",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: kBrand,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const _MainDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          children: [
            const SizedBox(height: 8),
            const Text(
              "Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            _ProfileCapsule(
              name: name,
              org: org,
              dept: dept,
              avatar:
                  widget.avatarImage ??
                  const AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(height: 26),
            const Text(
              "Services",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),

            _ServiceChipImage(
              label: "Quiz Scores (Team)",
              image: "assets/images/score.jpg",
              onTap: () => _open(context, "Quiz Scores (Team)"),
            ),
            _ServiceChipImage(
              label: "Team Reports",
              image: "assets/images/appointments.jpg",
              onTap: () => _open(context, "Team Reports"),
            ),
            _ServiceChipImage(
              label: "Approve Sessions",
              image: "assets/images/Tutorials.jpg",
              onTap: () => _open(context, "Approve Sessions"),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _ProfileCapsule extends StatelessWidget {
  final String name;
  final String org;
  final String dept;
  final ImageProvider avatar;

  const _ProfileCapsule({
    super.key,
    required this.name,
    required this.org,
    required this.dept,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1FF),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundImage: avatar),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "($org)",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Department: $dept",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
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

  const _ServiceChipImage({
    super.key,
    required this.label,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 92,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
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
                      Colors.black.withOpacity(0.25),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.55),
                    width: 1,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
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
    ListTile item(
      IconData icon,
      String title,
      String pageTitle, {
      VoidCallback? onTap,
    }) => ListTile(
      leading: Icon(icon, color: kBrand),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, color: kBrand),
      ),
      onTap:
          onTap ??
          () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => _PlaceholderPage(title: pageTitle),
              ),
            );
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
                child: Icon(Icons.person, color: kBrand),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.home_rounded, color: kBrand),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SupervisorHomePage(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
            const Divider(),
            item(Icons.account_circle_rounded, "Account", "Account"),
            item(
              Icons.menu_book_rounded,
              "Tutorials",
              "Tutorials",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TutorialPage()),
                );
              },
            ),
            item(
              Icons.help_outline_rounded,
              "FAQs",
              "FAQs",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FaqsPage()),
                );
              },
            ),

            // ✅ Contact Us الحقيقي بدور Supervisor
            item(
              Icons.support_agent_rounded,
              "Contact Us",
              "Contact Us",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ContactUsPage(role: UserRole.supervisor),
                  ),
                );
              },
            ),

            item(Icons.settings_rounded, "Settings", "Settings"),
            const Divider(),

            // إضافات المشرف
            item(
              Icons.leaderboard_rounded,
              "Quiz Scores (Team)",
              "Quiz Scores (Team)",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const QuizScorePage(role: UserRole.supervisor),
                  ),
                );
              },
            ),
            item(
              Icons.assessment_rounded,
              "Team Reports",
              "Team Reports",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TeamReportPage()),
                );
              },
            ),
            item(
              Icons.verified_rounded,
              "Approve Sessions",
              "Approve Sessions",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ApproveSessionPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: kBrand),
              title: const Text(
                "Logout",
                style: TextStyle(fontWeight: FontWeight.w600, color: kBrand),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
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
        title: Text(title),
      ),
      body: Center(
        child: Text(title, style: const TextStyle(fontSize: 22, color: kBrand)),
      ),
    );
  }
}
