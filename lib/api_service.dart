import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "https://cits5206.7m7.moe";

  // Sign in function
  static Future<void> loginUser(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body:
          'username=${Uri.encodeComponent(username)}&password=${Uri.encodeComponent(password)}',
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['Status'] == true) {
        // 处理成功登录，例如存储 token
        print("登录成功，Token: ${data['Token']}");
      } else {
        // 处理登录失败
        print("登录失败");
      }
    } else {
      print("服务器错误: ${response.statusCode}");
    }
  }

  // Sign up function
  static Future<bool> registerUser(String username, String password) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body:
            'username=${Uri.encodeComponent(username)}&password=${Uri.encodeComponent(password)}',
      );

      // 打印状态码
      print('Status Code: ${response.statusCode}');
      // 打印相应内容
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          // 处理成功注册，存储 userID
          print("Registration successful, user ID: ${data['userID']}");
          return true; // 注册成功，返回 true
        } else {
          print("Registration failed");
          return false; // 注册失败，返回 false
        }
      } else {
        print("服务器错误: ${response.statusCode}");
        return false; // 服务器错误时返回 false
      }
    } catch (e) {
      print("请求失败: $e");
      return false; // 异常时返回 false
    }
  }

  // 更改密码功能
  static Future<void> changePassword(String token, String newPassword) async {
    final url = Uri.parse('$baseUrl/changepass');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 使用token进行授权
      },
      body: jsonEncode({'password': newPassword}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['Status'] == true) {
        // 处理成功更改密码
        print("密码修改成功");
      } else {
        print("密码修改失败");
      }
    } else {
      print("服务器错误: ${response.statusCode}");
    }
  }
}
