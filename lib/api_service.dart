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
        // Sign in successful, save token
        print("Sign in successful, Token: ${data['Token']}");
        // You need to store the token for future use
      } else {
        print("Sign in failed");
      }
    } else {
      print("Server error: ${response.statusCode}");
    }
  }

  // Registration function
  static Future<bool> registerUser(String username, String password) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body:
            'username=${Uri.encodeComponent(username)}&password=${Uri.encodeComponent(password)}',
      );

      // Print status code
      print('Status Code: ${response.statusCode}');
      // Print response body
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          // Registration successful, save userID
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

  // Change password function
  static Future<void> changePassword(String token, String newPassword) async {
    final url = Uri.parse('$baseUrl/changepass');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'password': newPassword}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['Status'] == true) {
        print("Password change successful");
      } else {
        print("Password change failed");
      }
    } else {
      print("Server error: ${response.statusCode}");
    }
  }

  // Update user information function
  static Future<void> setUserInfo(
      String userID, String firstname, String lastname, String dob) async {
    final url = Uri.parse('$baseUrl/setuserinfo');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userID': userID,
        'firstname': firstname,
        'lastname': lastname,
        'dob': dob,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['Status'] == true) {
        print("User information updated successfully");
      } else {
        print("Failed to update user information");
      }
    } else {
      print("Server error: ${response.statusCode}");
    }
  }

  // Update user interests function
  static Future<void> setUserInterests(
      String token, String userID, List<String> interests) async {
    final url = Uri.parse('$baseUrl/setuserinterest');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'userID': userID,
        'interests':
            interests.join(','), // Convert list to a comma-separated string
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['Status'] == true) {
        print("User interests updated successfully");
      } else {
        print("Failed to update user interests");
      }
    } else {
      print("Server error: ${response.statusCode}");
    }
  }
}
