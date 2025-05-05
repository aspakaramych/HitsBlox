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
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size(150, 75), child: TopBar()),
      body: Center(child: Text('Hello Gleb'),),
      bottomNavigationBar: BottomBar(onTerminalPressed: () {
        _showTerminalPanel(context);
      }),
      backgroundColor: AppColors.background,
    );
  }
}
