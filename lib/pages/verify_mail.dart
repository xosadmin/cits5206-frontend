import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audiopin_frontend/api_service.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  // Function to open the default email app (using a web URL for email client)
  Future<void> _openEmailApp() async {
    final Uri emailUrl = Uri.parse("https://mail.google.com/");
    if (await canLaunchUrl(emailUrl)) {
      await launchUrl(emailUrl,
          mode: LaunchMode.externalApplication); // Opens in external browser
    } else {
      throw 'Could not launch email app'; // Handle error when URL cannot be launched
    }
  }

  // Function to resend the password recovery email
  Future<void> _resendEmail(BuildContext context, String email) async {
    try {
      // Calls the changePassword function, which is being repurposed for email resend
      await ApiService.changePassword('', '');
      // Show success message in the app when email is successfully resent
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email has been resent successfully.'),
        ),
      );
    } catch (e) {
      // Show failure message if email resend fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to resend email. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String email =
        "user_email_here"; // Placeholder for user's email, should be passed dynamically

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Return to the previous screen
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
                'assets/images/Email_13_1.png',
                width: 150,
                height: 150, // Display email verification illustration
              ),
              const SizedBox(height: 20),
              const Text(
                'We have sent password recovery\ninstructions to your email.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ), // Inform the user about the sent email
              ),
              const SizedBox(height: 40),
              // Button to open the user's email app (opens Gmail in a browser in this case)
              SizedBox(
                width: 327,
                height: 50,
                child: ElevatedButton(
                  onPressed: _openEmailApp, // Trigger email app opening
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF00008B), // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    'Open email app', // Button text
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Resend email option (calls API to resend the reset email)
              GestureDetector(
                onTap: () =>
                    _resendEmail(context, email), // Trigger email resend logic
                child: const Text(
                  'Resend email', // Text for the resend option
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF41414E),
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
