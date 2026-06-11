import 'package:flutter/foundation.dart';

class ThemeService extends ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _isDarkTheme = isDark;
    notifyListeners();
  }

  String getTheme() {
    return _isDarkTheme ? 'dark' : 'light';
  }
}
