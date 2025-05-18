import 'package:app/screens/home_screen.dart';
import 'package:app/screens/settings_screen.dart';
import 'package:app/screens/test_screen.dart';
import 'package:app/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/main_screen.dart';
import 'package:app/design/theme/app_theme.dart';

import 'design/AppRouter.dart';

TestScreen testScreen = TestScreen();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final router = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Inter Tight", "Inter");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'HITsBlocks',
      theme: theme.lightMediumContrast(),
      onGenerateRoute: router.onGenerateRoute,
      initialRoute: '/',
    );
  }

}