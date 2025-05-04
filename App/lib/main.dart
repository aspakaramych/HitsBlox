import 'package:app/design/theme/colors.dart';
import 'package:flutter/material.dart';
import 'design/widgets/widgets.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            TopBar(),
            Expanded(
              child: Center(
                child: Text("Content Area"),
              ),
            ),
            BottomBar(),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}