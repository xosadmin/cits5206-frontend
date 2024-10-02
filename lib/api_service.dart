import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:xml/xml.dart' as xml;

class UserService {
  // store userID to hive
  static Future<void> saveUserID(String userID) async {
    var box = await Hive.openBox('userBox');
    await box.put('userID', userID);
    print('Stored userID: $userID');
  }

  // get userID from hive
  static Future<String?> getUserID() async {
    var box = await Hive.openBox('userBox');
    String? userID = box.get('userID');
    print('Retrieved userID: $userID');
    return userID;
  }

  // store Token to hive
  static Future<void> saveToken(String token) async {
    var box = await Hive.openBox('authBox');
    await box.put('token', token);
    print('Stored token: $token');
  }

  // get Token from hive
  static Future<String?> getToken() async {
    var box = await Hive.openBox('authBox');
    String? token = box.get('token');
    print('Retrieved token: $token');
    return token;
  }

  // clear token when user logs out
  static Future<void> clearToken() async {
    var box = await Hive.openBox('authBox');
    await box.delete('token');
    print('Token cleared');
  }
}

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
        // get token from backend API requests
        String token = data['token'];
        print("Login successful, token: $token");
        // store token to hive
        await UserService.saveToken(token);
        // Sign in successful, save token
        print("Sign in successful, Token: $token");
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
          // get userID from backend API requests
          String userID = data['userID'];
          print("Registration successful, user ID: ${data['userID']}");
          // store userID to hive
          await UserService.saveUserID(userID);
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
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
      body: 'password=${Uri.encodeComponent(newPassword)}',
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
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body:
          'userID=${Uri.encodeComponent(userID)}&firstname=${Uri.encodeComponent(firstname)}&lastname=${Uri.encodeComponent(lastname)}&dob=${Uri.encodeComponent(dob)}',
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
      String userID, List<String> interests) async {
    final url = Uri.parse('$baseUrl/setuserinterest');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body:
          'userID=${Uri.encodeComponent(userID)}&interests=${Uri.encodeComponent(interests.join(","))}',
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

  // upload and parse OPML file
  static Future<List<Map<String, String>>> uploadAndParseOPML(
      String opmlContent) async {
    final url = Uri.parse('$baseUrl/uploadopml');
    String? userID = await UserService.getUserID();
    String? token = await UserService.getToken();

    if (userID == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body:
            'userID=${Uri.encodeComponent(userID)}&opmlContent=${Uri.encodeComponent(opmlContent)}',
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['Status'] == true) {
          List<Map<String, String>> podcasts = (data['podcasts'] as List)
              .map((podcast) => {
                    'title': podcast['title'] as String,
                    'xmlUrl': podcast['xmlurl'] as String,
                  })
              .toList();
          return podcasts;
        } else {
          throw Exception(data['Message'] ?? 'Failed to upload and parse OPML');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print("OPML upload and parse failed: $e");
      rethrow;
    }
  }
}
