// lib/profile_detail_page.dart
import 'package:flutter/material.dart';
import 'global.dart' as globals;

const Color kBrand = Color(0xFF5B8DBE);
const Color kLight = Color(0xFF9FBEEC);

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({super.key});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRole = globals.TypeUser.isNotEmpty ? globals.TypeUser : 'User';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'VRVITA',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kBrand,
                      letterSpacing: 2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Logout functionality
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Logout')));
                    },
                    child: const Text(
                      'logout',
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            // Profile Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Specialization',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kBrand,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getSpecialization(userRole),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Type:', userRole),
                        const SizedBox(height: 8),
                        _buildInfoRow('Since:', '2015'),
                        const SizedBox(height: 8),
                        _buildInfoRow('Experience:', '10 Years'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: kBrand,
                  borderRadius: BorderRadius.circular(30),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'ABOUT'),
                  Tab(text: 'WORK'),
                  Tab(text: 'ACTIVITY'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAboutTab(userRole),
                  _buildWorkTab(),
                  _buildActivityTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Edit profile
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Edit Profile')));
        },
        backgroundColor: Colors.grey[400],
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  String _getSpecialization(String role) {
    switch (role.toLowerCase()) {
      case 'doctor':
        return 'Neurosurgeon';
      case 'nurse':
        return 'Critical Care Nurse';
      case 'supervisor':
        return 'Healthcare Supervisor';
      case 'student':
        return 'Medical Student';
      default:
        return 'Healthcare Professional';
    }
  }

  Widget _buildAboutTab(String role) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BIO Section
          const Text(
            'BIO',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getBioText(role),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ON THE WEB Section
          const Text(
            'ON THE WEB',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSocialIcon(Icons.link, Colors.blue[400]!),
                _buildSocialIcon(Icons.chat, Colors.green[600]!),
                _buildSocialIcon(Icons.facebook, Colors.blue[700]!),
                _buildSocialIcon(Icons.camera_alt, Colors.pink[400]!),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // PHONE Section
          const Text(
            'PHONE',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  globals.userPhone ?? '5',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWorkTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '10',
                  'Projects\ndone',
                  Colors.blue[100]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '92%',
                  'Success\nrate',
                  Colors.blue[100]!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard('5', 'Teams', Colors.blue[100]!)),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '3',
                  'Client\nreports',
                  Colors.blue[100]!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    return Center(
      child: Text(
        'Activity information will be displayed here',
        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  String _getBioText(String role) {
    switch (role.toLowerCase()) {
      case 'doctor':
        return 'Dr. ${globals.userDisplayName} Specialized in Critical Intelligence, Robotics, And Computer Vision With Applications In Healthcare And Medical Training. He Has Collaborated With King Faisal Specialist Hospital On AI-Based Cancer Detection And VR-Based Surgical Training. His Research Also Includes Patient AI Autonomous Robotic Inspection And Assistive Navigation Systems, Contributing To Advancements In Medical Technology And Patient Care.';
      case 'nurse':
        return 'Nurse ${globals.userDisplayName} is a dedicated Critical Care Nurse with extensive experience in patient care and emergency response. Specialized in VR-based medical training and patient monitoring systems. Works closely with medical teams to ensure the highest standards of healthcare delivery.';
      case 'supervisor':
        return 'Supervisor ${globals.userDisplayName} oversees healthcare operations and training programs. Expert in implementing advanced medical technologies and VR training systems. Committed to improving patient outcomes through innovative healthcare solutions and team development.';
      case 'student':
        return 'Medical Student ${globals.userDisplayName} is training in advanced healthcare technologies and VR-based medical simulations. Focused on learning cutting-edge medical procedures and patient care techniques. Participating in research projects related to AI and robotics in healthcare.';
      default:
        return 'Healthcare professional with expertise in medical technology and patient care.';
    }
  }
}
