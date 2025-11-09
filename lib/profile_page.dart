// lib/profile_page.dart
import 'package:flutter/material.dart';
import 'global.dart' as globals;

const Color kBrand = Color(0xFF5B8DBE);
const Color kLight = Color(0xFF9FBEEC);

class ProfilePage extends StatefulWidget {
  final String? userName;

  const ProfilePage({super.key, this.userName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController? _fullNameController;
  TextEditingController? _usernameController;
  TextEditingController? _phoneController;
  TextEditingController? _emailController;
  String _selectedGender = 'Gender';
  String _selectedBirth = 'Birth';

  @override
  void initState() {
    super.initState();
    final displayName = (widget.userName != null && widget.userName!.isNotEmpty)
        ? widget.userName!
        : (globals.userDisplayName.isNotEmpty
              ? globals.userDisplayName
              : 'User');

    _fullNameController = TextEditingController(text: displayName);
    _usernameController = TextEditingController(
      text: globals.registeredId.isNotEmpty ? globals.registeredId : '',
    );
    _phoneController = TextEditingController(text: globals.userPhone ?? '');
    _emailController = TextEditingController(text: globals.userEmail ?? '');
  }

  @override
  void dispose() {
    _fullNameController?.dispose();
    _usernameController?.dispose();
    _phoneController?.dispose();
    _emailController?.dispose();
    super.dispose();
  }

  void _saveProfile() {
    globals.userDisplayName = _fullNameController?.text.trim() ?? '';
    globals.userPhone = _phoneController?.text.trim() ?? '';
    globals.userEmail = _emailController?.text.trim() ?? '';

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with VRVITA and logout
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logout functionality')),
                        );
                      },
                      child: const Text(
                        'logout',
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Profile Avatar with edit button
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kBrand, width: 3),
                      color: Colors.grey[200],
                    ),
                    child: const Icon(Icons.person, size: 50, color: kBrand),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: kBrand,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Edit Profile Title
              const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 30),

              // Form Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name
                    _buildLabel('Full Name'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      _fullNameController,
                      'Enter your full name',
                    ),
                    const SizedBox(height: 20),

                    // Username
                    _buildLabel('Username'),
                    const SizedBox(height: 8),
                    _buildTextField(_usernameController, '@username'),
                    const SizedBox(height: 20),

                    // Email
                    _buildLabel('Email'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      _emailController,
                      'Taha098@kfshrc.edu.sa',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Phone Number
                    _buildLabel('Phone Number'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      _phoneController,
                      '+966 5',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    // Birth
                    _buildLabel('Birth'),
                    const SizedBox(height: 8),
                    _buildDropdown('Birth', _selectedBirth, (value) {
                      setState(() {
                        _selectedBirth = value!;
                      });
                    }),
                    const SizedBox(height: 20),

                    // Gender
                    _buildLabel('Gender'),
                    const SizedBox(height: 8),
                    _buildDropdown('Gender', _selectedGender, (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    }),
                    const SizedBox(height: 30),

                    // Change Password Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBrand,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.lock, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Floating Edit Button
      floatingActionButton: FloatingActionButton(
        onPressed: _saveProfile,
        backgroundColor: kLight,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController? controller,
    String hint, {
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          border: InputBorder.none,
          hintText: hint,
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        items: [
          DropdownMenuItem(value: hint, child: Text(hint)),
          DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
          DropdownMenuItem(value: 'Option 2', child: Text('Option 2')),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
