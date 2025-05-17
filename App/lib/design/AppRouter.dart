import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/main_screen.dart';
import '../screens/settings_screen.dart';

class AppRouter {
  late final Widget homeScreen;
  late final Widget mainScreen;
  late final Widget settingsScreen;

  AppRouter() {
    homeScreen = HomeScreen();
    mainScreen = MainScreen(screenName: '',);
    settingsScreen = SettingsScreen();
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => homeScreen);
      case '/edit':
        return MaterialPageRoute(builder: (_) => mainScreen);
      case '/settings':
        return MaterialPageRoute(builder: (_) => settingsScreen);
      default:
        return MaterialPageRoute(builder: (_) => homeScreen);
    }
  }
}