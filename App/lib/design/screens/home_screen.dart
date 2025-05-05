import 'package:flutter/material.dart';
import 'test_screen.dart';
import 'package:app/design/widgets/widgets.dart';
import 'package:app/design/theme/colors.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  bool _isAddSectionVisible = false;

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
        TestScreen(),

        Stack(
          children: [
            Column(
              children: [
                TopBar(),
                Expanded(
                  child: Center(),
                ),

                if (_isAddSectionVisible)
                  AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: ItemsList(),
                    ),
                  ),
                BottomBar(
                  onTerminalPressed: () => _showTerminalPanel(context),
                  onAddPressed: () => _toggleAddSection(),
                ),
              ],
            ),]
        ),

      ],


    );
  }
}
