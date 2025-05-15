import 'package:app/core/ConsoleService.dart';
import 'package:app/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/design/widgets/widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isAddSectionVisible = false;
  final TestScreen _testScreen = TestScreen();

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
        return Console(consoleService: _testScreen.consoleService,);
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
                TopBar(play: _testScreen.engine, nodeGraph: _testScreen.nodeGraph, registry: _testScreen.registry,),
                Expanded(child: Center()),
                if (_isAddSectionVisible) SizedBox(height: 400, child: BlocksList(blocks: _testScreen.blocks)),
                BottomBar(
                  onTerminalPressed: () => _showTerminalPanel(context),
                  onAddPressed: () => _toggleAddSection(),
                  onSavePressed: () => _showTerminalPanel(context)
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}