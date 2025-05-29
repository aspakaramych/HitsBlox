import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HintsNotifier with ChangeNotifier {
  bool _areHintsEnabled;

  HintsNotifier(this._areHintsEnabled) {
    _loadHintsPreference();
  }

  bool get areHintsEnabled => _areHintsEnabled;

  void toggleHints() {
    _areHintsEnabled = !_areHintsEnabled;
    _saveHintsPreference(_areHintsEnabled);
    notifyListeners();
  }

  Future<void> _loadHintsPreference() async {
    final prefs = await SharedPreferences.getInstance();

    _areHintsEnabled = prefs.getBool('areHintsEnabled') ?? true;
    notifyListeners();
  }

  Future<void> _saveHintsPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('95a51e91-aa1c-46b4-9591-0ee3f9fb5e39', value);
  }
}