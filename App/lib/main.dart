import 'dart:convert';

import 'package:app/design/theme/app_theme.dart';
import 'package:app/screens/test_screen.dart';
import 'package:app/utils/hints_notifier.dart';
import 'package:app/utils/presets.dart';
import 'package:app/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'design/app_router.dart';

TestScreen testScreen = TestScreen();

void hideStatusBar() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

void showStatusBar() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _saveScreen(
      "Print sample", jsonEncode(SamplesForLoading.getPrintSample()));
  await _saveScreen("Bubble sort sample",
      jsonEncode(SamplesForLoading.getBubbleSortSample()));
  await _saveScreen(
      "If else sample", jsonEncode(SamplesForLoading.getIfElseSample()));
  await _saveScreen("Binary search sample",
      jsonEncode(SamplesForLoading.getBinarySearchSample()));
  final prefs = await SharedPreferences.getInstance();
  final initialIsDarkMode = prefs.getBool(
      '9d6b82da-eaec-4634-8bdb-743f029cb961') ?? true;

  runApp(ChangeNotifierProvider(
    create: (context) => HintsNotifier(false),
    child: MyApp(initialIsDarkMode: initialIsDarkMode,)));
}

class MyApp extends StatefulWidget {
  final bool initialIsDarkMode;

  MyApp({super.key, required this.initialIsDarkMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode = widget.initialIsDarkMode;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
      _saveThemePreference(isDarkMode);
    });
  }

  Future<void> _saveThemePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('9d6b82da-eaec-4634-8bdb-743f029cb961', value);
  }

  late var router = AppRouter(() {toggleTheme();}, isDarkMode);

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Inter Tight", "Inter");
    MaterialTheme theme = MaterialTheme(textTheme);
    hideStatusBar();

    return MaterialApp(
      title: 'HITsBlocks',
      theme: (isDarkMode) ? theme.dark() : theme.light(),
      onGenerateRoute: router.onGenerateRoute,
      initialRoute: '/',
    );
  }
}

Future<void> _saveScreen(String name, String jsonString) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(name, jsonString);
}

