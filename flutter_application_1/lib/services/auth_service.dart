import 'package:flutter/foundation.dart';
import '../models/login_response.dart';

class AuthService extends ChangeNotifier {
  LoginResponse? _currentSession;

  LoginResponse? get session => _currentSession;
  bool get isAuthenticated => _currentSession != null;

  Future<LoginResponse?> login(String userName) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _currentSession = LoginResponse(
        userId: 'user_123',
        userName: userName,
        loginStatus: 'success',
        profilePicture: 'https://via.placeholder.com/200',
      );

      notifyListeners();
      return _currentSession;
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      return null;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      return otp == '123456'; // Mock validation
    } catch (e) {
      if (kDebugMode) {
        print('OTP verification error: $e');
      }
      return false;
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
