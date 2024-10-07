import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isFilled = false;
  bool _isPasswordVisible = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                  const Text(
                    'Email Address',
                    style: TextStyle(fontSize: 16),
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
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Password',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: 327,
                    child: TextField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: '**************',
                        border: const OutlineInputBorder(),
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
              const SizedBox(height: 20),
              // Sign In 按钮
              SizedBox(
                width: 327,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
// 点击后将按钮变灰
                    });

                    // 延迟200毫秒后跳转页面
                    Future.delayed(const Duration(milliseconds: 120), () {
                      setState(() {
// 恢复为深蓝色
                      });
                      // 跳转homepage，先用forgot占位
                      Navigator.pushNamed(context, '/homepage');
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFilled
                        ? const Color(0xFF00008B) // 默认颜色
                        : const Color(0xFF6B7680), // 禁用状态
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Forgot Password 链接
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot_pwd');
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 260),
              // OR 和分割线
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OR',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Google 按钮
              SizedBox(
                width: 327, // 设置按钮的宽度为327
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle Google sign in action
                  },
                  icon: Image.asset('assets/icons/google.png', height: 24),
                  label: const Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Facebook 按钮
              SizedBox(
                width: 327, // 设置按钮的宽度为327
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle Facebook sign in action
                  },
                  icon: Image.asset('assets/icons/facebook.png', height: 24),
                  label: const Text('Sign in with Facebook'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Apple 按钮
              SizedBox(
                width: 327, // 设置按钮的宽度为327
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle Apple sign in action
                  },
                  icon: Image.asset('assets/icons/apple.png', height: 24),
                  label: const Text('Sign in with Apple'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Color(0xFF6B7680)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
