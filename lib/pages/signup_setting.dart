import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audiopin_frontend/pages/import.dart';
import 'package:audiopin_frontend/api_service.dart'; // Import your API service
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignUpSetting extends StatefulWidget {
  const SignUpSetting({super.key});

  @override
  _SignUpSettingState createState() => _SignUpSettingState();
}

class _SignUpSettingState extends State<SignUpSetting> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  bool _isFilled = false;

  // Assume these are fetched from storage or passed in
  String userID = "your_userID_here";

  final dateFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_checkIfFilled);
    lastNameController.addListener(_checkIfFilled);
    dobController.addListener(_checkIfFilled);
  }

  void _checkIfFilled() {
    setState(() {
      _isFilled = firstNameController.text.isNotEmpty &&
          lastNameController.text.isNotEmpty &&
          dobController.text.isNotEmpty;
    });
  }

  // Update user information using API
  Future<void> _updateUserInfo() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String dob = dobController.text;

    await ApiService.setUserInfo(userID, firstName, lastName, dob);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildTextField(
                    label: 'First Name',
                    hintText: 'Enter first name',
                    controller: firstNameController,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Last Name',
                    hintText: 'Enter last name',
                    controller: lastNameController,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Date of birth',
                    hintText: 'DD/MM/YYYY',
                    controller: dobController,
                    TextInputFormatters: [dateFormatter],
                  ),
                ],
              ),
            ),
            const Spacer(),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  const Text(
                    'By continuing you agree to Audiopin\'s',
                    style: TextStyle(fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      const url = 'https://placeholder.com';
                      print('Navigating to $url');
                    },
                    child: const Text(
                      'Terms & Privacy policy',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF00008B),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 327,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isFilled
                          ? () async {
                              await _updateUserInfo();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ImportPage()),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFilled
                            ? const Color(0xFF00008B)
                            : const Color(0xFF6B7680),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    List<TextInputFormatter>? TextInputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 327,
          height: 48,
          child: TextField(
            controller: controller,
            inputFormatters: TextInputFormatters,
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    super.dispose();
  }
}
