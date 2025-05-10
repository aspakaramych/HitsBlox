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
  final GlobalKey<TestScreenState> _testScreenKey = GlobalKey();

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
        return Console();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TestScreen(key: _testScreenKey,),
        Stack(
          children: [
            Column(
              children: [
                TopBar(),
                Expanded(child: Center()),
                if (_isAddSectionVisible) BlocksList(blocks: _testScreenKey.currentState?.blocks ?? []),
                BottomBar(
                  onTerminalPressed: () => _showTerminalPanel(context),
                  onAddPressed: () => _toggleAddSection(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}