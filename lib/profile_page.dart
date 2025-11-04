// lib/profile_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'global.dart' as globals;

const Color kBrand = Color(0xFF2F5B89);
const Color kLight = Color(0xFF9FBEEC);

class ProfilePage extends StatefulWidget {
  final String userName;

  const ProfilePage({super.key, required this.userName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final displayName = widget.userName.isNotEmpty
        ? widget.userName
        : globals.userDisplayName;
    _nameController = TextEditingController(text: displayName);
    _phoneController = TextEditingController(text: globals.userPhone ?? '');
    _emailController = TextEditingController(text: globals.userEmail ?? '');
    _bioController = TextEditingController(text: globals.userBio ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // Save to globals
    globals.userDisplayName = _nameController.text.trim();
    globals.userPhone = _phoneController.text.trim();
    globals.userEmail = _emailController.text.trim();
    globals.userBio = _bioController.text.trim();

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _cancelEdit() {
    // Reset controllers to original values
    final displayName = widget.userName.isNotEmpty
        ? widget.userName
        : globals.userDisplayName;
    _nameController.text = displayName;
    _phoneController.text = globals.userPhone ?? '';
    _emailController.text = globals.userEmail ?? '';
    _bioController.text = globals.userBio ?? '';

    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.userName.isNotEmpty
        ? widget.userName
        : globals.userDisplayName;
    final userRole = globals.TypeUser.isNotEmpty ? globals.TypeUser : 'User';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kBrand,
        foregroundColor: Colors.white,
        title: Text(_isEditing ? 'Edit Profile' : 'Profile'),
        elevation: 0,
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _cancelEdit,
              tooltip: 'Cancel',
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'Edit',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with gradient
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kBrand, kLight],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  // Profile Picture
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.white,
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: kBrand,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // User Name
                  Text(
                    displayName,
                    style: GoogleFonts.quintessential(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // User Role
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      userRole.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Profile Info Cards
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kBrand,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (!_isEditing) ...[
                    _InfoCard(
                      icon: Icons.badge_outlined,
                      title: 'User ID',
                      value: globals.registeredId.isNotEmpty
                          ? globals.registeredId
                          : 'Not set',
                    ),
                    _InfoCard(
                      icon: Icons.person_outline,
                      title: 'Full Name',
                      value: displayName,
                    ),
                    _InfoCard(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: globals.userEmail ?? 'Not set',
                    ),
                    _InfoCard(
                      icon: Icons.phone_outlined,
                      title: 'Phone',
                      value: globals.userPhone ?? 'Not set',
                    ),
                    _InfoCard(
                      icon: Icons.work_outline,
                      title: 'Role',
                      value: userRole,
                    ),
                    _InfoCard(
                      icon: Icons.info_outline,
                      title: 'Bio',
                      value: globals.userBio ?? 'Not set',
                    ),
                    _InfoCard(
                      icon: Icons.fingerprint,
                      title: 'Biometric Login',
                      value: globals.biometricEnabled ? 'Enabled' : 'Disabled',
                      trailing: Switch(
                        value: globals.biometricEnabled,
                        activeColor: kBrand,
                        onChanged: (value) {
                          setState(() {
                            globals.biometricEnabled = value;
                          });
                        },
                      ),
                    ),
                  ] else ...[
                    // Editable fields
                    _EditableField(
                      icon: Icons.person_outline,
                      label: 'Full Name',
                      controller: _nameController,
                      hint: 'Enter your full name',
                    ),
                    _EditableField(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      controller: _emailController,
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _EditableField(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      controller: _phoneController,
                      hint: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                    ),
                    _EditableField(
                      icon: Icons.info_outline,
                      label: 'Bio',
                      controller: _bioController,
                      hint: 'Tell us about yourself',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8),
                    // Read-only fields
                    _InfoCard(
                      icon: Icons.badge_outlined,
                      title: 'User ID (Read Only)',
                      value: globals.registeredId.isNotEmpty
                          ? globals.registeredId
                          : 'Not set',
                    ),
                    _InfoCard(
                      icon: Icons.work_outline,
                      title: 'Role (Read Only)',
                      value: userRole,
                    ),
                  ],

                  const SizedBox(height: 30),

                  // Action Buttons
                  if (_isEditing) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _saveProfile,
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBrand,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: _cancelEdit,
                        icon: const Icon(Icons.cancel),
                        label: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          side: BorderSide(color: Colors.grey[400]!, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Change password
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Change Password feature coming soon!',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.lock_outline),
                        label: const Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kBrand,
                          side: const BorderSide(color: kBrand, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Widget? trailing;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: kBrand, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _EditableField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;

  const _EditableField({
    required this.icon,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: kBrand, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kBrand,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kBrand, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
