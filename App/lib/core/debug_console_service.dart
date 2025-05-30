import 'dart:ui';

import 'package:flutter/cupertino.dart';

class DebugConsoleService with ChangeNotifier {
  final List<String> logs = [];

  void log(String message) {
    logs.add(message);
    notifyListeners();
  }

  void clear() {
    logs.clear();
  }
}
