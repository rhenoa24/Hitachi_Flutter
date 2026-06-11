import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/login_response.dart';

class AuthService extends ChangeNotifier {
  // Mobile/production: --dart-define=API_BASE_URL=https://indexcodex.com
  // Flutter Web dev:   --dart-define=API_BASE_URL=http://localhost:8080
  static const _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://indexcodex.com',
  );

  LoginResponse? _currentSession;

  LoginResponse? get session => _currentSession;
  bool get isAuthenticated => _currentSession != null;

  Future<LoginResponse?> login(String userName, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/login'),
        headers: {'CLIENT_ID': 'rgbexam', 'Content-Type': 'application/json'},
        body: jsonEncode({'userName': userName, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentSession = LoginResponse.fromJson(data);
        notifyListeners();
        return _currentSession;
      } else {
        if (kDebugMode) {
          print('Login failed: ${response.statusCode} - ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      return null;
    }
  }

  void logout() {
    _currentSession = null;
    notifyListeners();
  }

  LoginResponse? getSession() {
    return _currentSession;
  }
}
