
import 'package:app/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/main_screen.dart';
import 'package:app/design/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final textTheme = TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HITsBlocks',
      theme: MaterialTheme(textTheme).light(),
      home: MainScreen()
    );
  }

}