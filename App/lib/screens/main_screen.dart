import 'dart:convert';

import 'package:app/core/ConsoleService.dart';
import 'package:app/main.dart';
import 'package:app/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/design/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  final savedState;
  String screenName;

  MainScreen(this.savedState, {super.key, required this.screenName});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isAddSectionVisible = false;
  final TestScreen _testScreen = testScreen;

  @override
  void initState() {
    super.initState();
    if (widget.savedState != null) {
      _testScreen.loadFromJson(widget.savedState);
    } else {
      _testScreen.clear();
    }
  }

  void _toggleAddSection() {
    setState(() {
      _isAddSectionVisible = !_isAddSectionVisible;
    });
  }

  void _showTerminalPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Console(consoleService: _testScreen.consoleService);
      },
    );
  }

  Future<void> _saveScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_testScreen.saveScreenState());
    if (widget.screenName.isEmpty) {
      var saveName = await showSaveDialog(context);
      if (saveName == null || saveName.trim().isEmpty) return;
      widget.screenName = saveName;
    }

    prefs.setString(widget.screenName, jsonString);

    // _testScreen.loadFromJson(_testScreen.saveScreenState());
  }

  Future<String?> showSaveDialog(BuildContext context) async {
    String? saveName;

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Сохранить проект'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Введите название сохранения',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              saveName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                if (saveName?.trim().isNotEmpty == true) {
                  Navigator.of(context).pop(saveName);
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _testScreen,
        Stack(
          children: [
            Column(
              children: [
                TopBar(
                  play: _testScreen.engine,
                  nodeGraph: _testScreen.nodeGraph,
                  registry: _testScreen.registry,
                ),
                Expanded(child: Center()),
                if (_isAddSectionVisible)
                  SizedBox(
                    height: 400,
                    child: BlocksList(blocks: _testScreen.blocks),
                  ),
                BottomBar(
                  onTerminalPressed: () => _showTerminalPanel(context),
                  onAddPressed: () => _toggleAddSection(),
                  onSavePressed: () => _saveScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
