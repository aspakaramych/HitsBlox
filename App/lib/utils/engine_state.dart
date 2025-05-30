import 'package:flutter/material.dart';

class EngineState with ChangeNotifier{
  bool _areRunning = false;

  bool getAreRunning(){
    return _areRunning;
  }

  Future<void> setRunning(bool num) async {
    _areRunning = num;
    notifyListeners();
  }
}