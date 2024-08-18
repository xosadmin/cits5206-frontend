import 'package:flutter/material.dart';

class VerifyEmailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
              SizedBox(height: 40),
              Image.asset(
                'assets/images/Email_13_1.png', // 替换为你的图片路径
                width: 150,
                height: 150,
              ),
              SizedBox(height: 20),
              Text(
                'We have sent a password recover\ninstructions to your email.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 40),

              // 第二部分：按钮
              SizedBox(
                width: 327,
                height: 50, // 设置按钮高度为50
                child: ElevatedButton(
                  onPressed: () {
                    // 打开邮件应用程序的逻辑
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00008B), // 按钮背景色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // 按钮圆角
                    ),
                  ),
                  child: Text(
                    'Open email app',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 第三部分：Resend email 链接
              GestureDetector(
                onTap: () {
                  // 重发邮件逻辑
                },
                child: Text(
                  'Resend email',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF41414E), // 链接颜色
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
