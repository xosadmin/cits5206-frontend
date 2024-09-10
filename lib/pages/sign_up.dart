import 'package:flutter/material.dart';
import 'package:audiopin_frontend/pages/sign_in.dart';
import 'package:audiopin_frontend/pages/signup_setting.dart';
import 'package:audiopin_frontend/api_service.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isFilled = false;
  bool _isPasswordVisible = false; //通过此变量控制密码可见性

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkIfFilled);
    passwordController.addListener(_checkIfFilled);
  }

  void _checkIfFilled() {
    setState(() {
      _isFilled =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  // register function related
  Future<void> _registerUser() async {
    String email = emailController.text;
    String password = passwordController.text;

    //调用API服务进行注册
    bool success = await ApiService.registerUser(email, password);

    if (success) {
      //注册成功后跳转到设置页
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignUpSetting()));
    } else {
      //处理注册失败的情况
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration failed. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                      controller: emailController,
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
                      controller: passwordController,
                      obscureText: !_isPasswordVisible, //控制密码可见性
                      decoration: InputDecoration(
                        hintText: '**************',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible =
                                  !_isPasswordVisible; // 切换可见性状态
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Sign up button
              SizedBox(
                width: 327,
                child: ElevatedButton(
                  onPressed: _isFilled
                      ? () async {
                          await _registerUser(); //调用注册方法
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFilled
                        ? Color(0xFF00008B) // 默认颜色
                        : Color(0xFF6B7680), // 禁用状态
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Create a free account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Forgot Password 链接
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? '),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: Color(0xFF00008B),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
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
                    side: BorderSide(color: Color(0XFF6B7680)),
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
