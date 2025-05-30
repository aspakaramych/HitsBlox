import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ConsoleService with ChangeNotifier {
  final List<String> logs = [];

  void log(String message) {
    print(message);
    logs.add(message);
    notifyListeners();
  }

  void clear() {
    logs.clear();
  }
}
