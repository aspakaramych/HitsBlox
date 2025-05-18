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
    mainScreen = MainScreen(null, screenName: '',);
    settingsScreen = SettingsScreen();
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => homeScreen);
      case '/edit':
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => mainScreen);
      case '/settings':
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => settingsScreen);
      default:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => homeScreen);
    }
  }
}