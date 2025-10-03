import 'package:flutter/material.dart';
import '../doctor/edit_profile_screen.dart';
import '../doctor/doctor_profile_tabs_screen.dart';
import '../doctor/appointments_screen.dart';
import '../doctor/contact_us_screen.dart';
import '../doctor/settings_screen.dart' as doctor_settings;

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DoctorProfileScreen(),
    const SearchScreen(),
    const AddScreen(),
    const NotificationsScreen(),
    const doctor_settings.SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4A6FA5),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Doctor Profile Screen
class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with curved background
              Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7BA5D8), Color(0xFF4A6FA5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement logout
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text(
                        'logout',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 70,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        const Text(
                          'VRVITA',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DoctorProfileWithTabsScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://via.placeholder.com/100',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Profile Info
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DoctorProfileWithTabsScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sup.Taha Houda',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7BA5D8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Account Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ListTile(
                leading: const Icon(
                  Icons.account_box_outlined,
                  color: Color(0xFF4A6FA5),
                ),
                title: const Text(
                  'View Profile',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DoctorProfileWithTabsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person_outline,
                  color: Color(0xFF4A6FA5),
                ),
                title: const Text(
                  'Edit profile',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF4A6FA5),
                ),
                title: const Text(
                  'Appointments',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppointmentsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF4A6FA5),
                ),
                title: const Text(
                  'Notifications',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                trailing: Switch(value: true, onChanged: (val) {}),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF4A6FA5),
                ),
                title: const Text(
                  'Privacy',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {},
              ),

              const Divider(height: 40, thickness: 1),

              ListTile(
                leading: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF4A6FA5),
                ),
                title: const Text(
                  'Location',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFF4A6FA5),
                ),
                title: const Text(
                  'Settings',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const doctor_settings.SettingsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.help_outline,
                  color: Color(0xFF4A6FA5),
                ),
                title: const Text(
                  'Help',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactUsScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder Screens
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Search Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Add Screen', style: TextStyle(fontSize: 24))),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Notifications Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
