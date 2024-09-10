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
        // Process sign in successful and save token
        print("Sign in successful，Token: ${data['Token']}");
      } else {
        // Process sign in failed
        print("Sign in failed");
      }
    } else {
      print("Server error: ${response.statusCode}");
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

      // print status code
      print('Status Code: ${response.statusCode}');
      // print response body
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          // process registration successful and save userID
          print("Registration successful, user ID: ${data['userID']}");
          return true;
        } else {
          print("Registration failed");
          return false;
        }
      } else {
        print("Server error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Request failed: $e");
      return false;
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
