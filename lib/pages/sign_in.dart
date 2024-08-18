import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email Address',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: 327,
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
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: 327,
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '**************',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.visibility),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Sign In 按钮
              SizedBox(
                width: 327,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isClicked = true; // 点击后将按钮变灰
                    });

                    // 延迟200毫秒后跳转页面
                    Future.delayed(Duration(milliseconds: 120), () {
                      setState(() {
                        _isClicked = false; // 恢复为深蓝色
                      });
                      // 跳转homepage，先用forgot占位
                      Navigator.pushNamed(context, '/forgot_pwd');
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isClicked
                        ? Color(0xFF6B7680) // 变为灰色
                        : Color(0xFF00008B), // 默认颜色
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Forgot Password 链接
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot_pwd');
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 260),
              // OR 和分割线
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OR',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ],
              ),
              SizedBox(height: 15),
              // Google 按钮
              SizedBox(
                width: 327, // 设置按钮的宽度为327
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle Google sign in action
                  },
                  icon: Image.asset('assets/icons/google.png', height: 24),
                  label: Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Facebook 按钮
              SizedBox(
                width: 327, // 设置按钮的宽度为327
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle Facebook sign in action
                  },
                  icon: Image.asset('assets/icons/facebook.png', height: 24),
                  label: Text('Sign in with Facebook'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Apple 按钮
              SizedBox(
                width: 327, // 设置按钮的宽度为327
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle Apple sign in action
                  },
                  icon: Image.asset('assets/icons/apple.png', height: 24),
                  label: Text('Sign in with Apple'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
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
