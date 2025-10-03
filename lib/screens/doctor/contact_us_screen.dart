import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'VRVITA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A6FA5),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact us',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'We are excited to hear from you! Whether you have questions, suggestions, or need support, our team is here to assist you.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Message Input
                    const Text(
                      'Your massages',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type your message here...',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Submit Button
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_messageController.text.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Message sent successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              _messageController.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7BA5D8),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // General Inquiries Section
                    const Text(
                      'General Inquiries',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildInfoText('Saudi Arabia - Madinah'),
                    _buildInfoText(
                      'King Faisal Specialist Hospital & Research Centre',
                    ),
                    _buildInfoText('Madinah, Saudi Arabia'),
                    _buildInfoText('Email: info@VRVITA.com'),
                    _buildInfoText('Phone: +966 14 820 0000'),

                    const SizedBox(height: 30),

                    // Social Media Section
                    const Text(
                      'Social Media',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Stay connected with us for the latest updates and news:',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 16),

                    _buildSocialLink('Facebook: @VRVITA'),
                    _buildSocialLink('Twitter: @VRVITA'),
                    _buildSocialLink('LinkedIn: VRVITA'),
                    _buildSocialLink('Instagram: @VRVITA'),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
      ),
    );
  }

  Widget _buildSocialLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.black87),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
