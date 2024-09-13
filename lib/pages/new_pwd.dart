import 'package:flutter/material.dart';
import 'package:audiopin_frontend/pages/sign_in.dart';

class NewPasswordPage extends StatelessWidget {
  const NewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        // Use Center to align the whole content
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 327, // Ensure all elements have the same width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create new password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF41414E),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your new password must be different from previously used passwords',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),
                _buildPasswordField(
                  label: 'Password',
                  hint: 'Must be at least 8 characters',
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  label: 'Confirm password',
                  hint: 'Both passwords must be a match',
                ),
                const SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    width: 327,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00008B),
                        textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text('Create password',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({required String label, required String hint}) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 327,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, color: Color(0xFF41414E)),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 327,
                  height: 48,
                  child: TextFormField(
                    obscureText: true,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.visibility),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFF6B7680)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hint,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7680)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
