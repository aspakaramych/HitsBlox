import 'package:app/screens/storage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/main.dart';

import 'package:app/design/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../utils/hints_notifier.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  late bool isDarkMode;

  SettingsScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late var hintsNotifier = Provider.of<HintsNotifier>(context);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 40),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Настройки",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SwitchListTile(
                    title: const Text('Тема приложения'),
                    subtitle: Text(widget.isDarkMode ? 'Темная' : 'Светлая'),
                    secondary: Icon(
                      widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    ),
                    value: widget.isDarkMode,
                    onChanged: (bool value) {
                      widget.toggleTheme();
                      widget.isDarkMode = !widget.isDarkMode;
                    },
                  ),

                  SwitchListTile(
                    title: const Text('Режим подсказок'),
                    subtitle: Text(
                      hintsNotifier.areHintsEnabled ? 'Включены' : 'Выключены',
                    ),
                    secondary: const Icon(Icons.lightbulb_outline),
                    value: hintsNotifier.areHintsEnabled,
                    onChanged: (bool value) {
                      hintsNotifier.toggleHints();
                    },
                  ),
                  AboutSection(),
                ],
              ),
            ),
            HorizontalBottomBar(
              onTerminalPressed: null,
              onAddPressed: () {
                Navigator.pushNamed(context, "/edit");
              },
              onSavePressed: null,
              iconButton: 'lib/design/assets/icons/left.svg',
              activeButton: "settings",
            ),
          ],
        ),
      ),
    );
  }
}
