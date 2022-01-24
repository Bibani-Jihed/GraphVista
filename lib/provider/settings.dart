import 'package:flutter/material.dart';

/// Class that contains all your app settings
/// Consists only of Theme setting as of now
class Settings extends ChangeNotifier {
  bool isDarkMode = false;
  Settings();

  void setDarkMode(bool val) {
    isDarkMode = val;
    notifyListeners();
  }
}
