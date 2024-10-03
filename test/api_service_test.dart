import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:audiopin_frontend/api_service.dart';
import 'dart:convert';

void main() {
  // Initialise hive storage
  setUp(() async {
    await setUpTestHive();
    await Hive.openBox('userBox');
    await Hive.openBox('authBox');
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  group('UserService tests', () {
    test('Save and get userID', () async {
      await UserService.saveUserID('12345');
      String? userID = await UserService.getUserID();
      expect(userID, equals('12345'));
    });

    test('Save and get token', () async {
      await UserService.saveToken('abc123');
      String? token = await UserService.getToken();
      expect(token, equals('abc123'));
    });

    test('Clear token', () async {
      await UserService.saveToken('abc123');
      await UserService.clearToken();
      String? token = await UserService.getToken();
      expect(token, isNull);
    });
  });

  group('ApiService tests', () {
    test('Test loginUser success', () async {
      // Create a simulated HTTP client to simulate response of login successfully
      final client = MockClient((request) async {
        return http.Response(
            jsonEncode({'Status': true, 'token': 'fake_token'}), 200);
      });

      // Use mock client to replace real HTTP client
      ApiService.client = client;

      // Call loginUser and validate result
      await ApiService.loginUser('testuser', 'password');
      String? token = await UserService.getToken();
      expect(token, equals('fake_token'));
    });

    test('Test registerUser success', () async {
      // Create a simulated HTTP client, simulate response of registering successfully
      final client = MockClient((request) async {
        return http.Response(
            jsonEncode({'Status': true, 'userID': 'user123'}), 200);
      });

      ApiService.client = client;

      bool result = await ApiService.registerUser('testuser', 'password');
      expect(result, isTrue);

      String? userID = await UserService.getUserID();
      expect(userID, equals('user123'));
    });

    test('Test setUserInfo success', () async {
      final client = MockClient((request) async {
        return http.Response(jsonEncode({'Status': true}), 200);
      });

      ApiService.client = client;

      await ApiService.setUserInfo('user123', 'John', 'Doe', '1990-01-01');
      expect(true, isTrue);
    });

    test('Test setUserInterests success', () async {
      final client = MockClient((request) async {
        return http.Response(jsonEncode({'Status': true}), 200);
      });

      ApiService.client = client;

      await ApiService.setUserInterests('user123', ['1', '2']);
      expect(true, isTrue);
    });

    test('Test uploadAndParseOPML success', () async {
      final client = MockClient((request) async {
        return http.Response(
            jsonEncode({
              'Status': true,
              'podcasts': [
                {'title': 'Podcast 1', 'xmlurl': 'http://example.com/1.xml'},
                {'title': 'Podcast 2', 'xmlurl': 'http://example.com/2.xml'},
              ]
            }),
            200);
      });

      ApiService.client = client;

      List<Map<String, String>> podcasts =
          await ApiService.uploadAndParseOPML('<opml>content</opml>');
      expect(podcasts.length, equals(2));
      expect(podcasts[0]['title'], equals('Podcast 1'));
      expect(podcasts[1]['title'], equals('Podcast 2'));
    });
  });
}
