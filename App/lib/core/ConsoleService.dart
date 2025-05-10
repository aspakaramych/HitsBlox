import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ConsoleService {
  final List<String> logs = [];

  void log(String message) {
    print(message);
    logs.add(message);
  }

  void clear() {
    logs.clear();
  }
}