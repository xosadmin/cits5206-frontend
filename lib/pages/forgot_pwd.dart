import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

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
              // 第一部分：图片和提示文字
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

              // 第二部分：Email和输入框
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email Address',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(
                    width: 327, // 设置宽度为327像素
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'mena@gmail.com',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 第三部分：Send按钮
              SizedBox(
                width: 327,
                height: 50, // 设置按钮高度为50
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/verify_mail'); // Handle send action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00008B), // 按钮背景色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // 按钮圆角
                    ),
                  ),
                  child: const Text(
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
