import 'package:flutter/material.dart';

class DebugNotifier with ChangeNotifier {
  bool _debugMode = false;

  bool getDebugMode() {
    return _debugMode;
  }

  Future<void> setDebugMode(bool num) async {
    _debugMode = num;
    notifyListeners();
  }
}
