import 'package:flutter/material.dart';
import 'package:audiopin_frontend/api_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool _isClicked = false;

  // Function to send reset password request via API
  Future<void> _sendResetEmail() async {
    String email = emailController.text;
    if (email.isNotEmpty) {
      setState(() {
        _isClicked = true;
      });

      try {
        await ApiService.changePassword("your_token_here", email);
        Navigator.pushNamed(context, '/verify_mail');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send reset email. Please try again.'),
          ),
        );
      } finally {
        setState(() {
          _isClicked = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset(
                'assets/images/Email_3_1.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter your registered email below to receive\npassword reset instructions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email Address',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(
                    width: 327,
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'mena@gmail.com',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 327,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isClicked ? null : _sendResetEmail, // 调用API发送邮件
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00008B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: _isClicked
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Send',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
