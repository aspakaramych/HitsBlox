import 'package:app/screens/storage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/main.dart';

import 'package:app/design/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  SettingsScreen({super.key, required this.toggleTheme});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>{

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
            Material(
              elevation: 5,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  )
                ),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: RichText(
                    text: TextSpan(
                      text: "Настройки",
                      style: Theme.of(context).textTheme.displaySmall
                    ),
                  ),
                )
              ),
            ),
            Expanded(
              child:
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  FloatingActionButton(onPressed: widget.toggleTheme)
                ],
              ),
            ),
            HorizontalBottomBar(
              onTerminalPressed: () {},
              onAddPressed: () {Navigator.pushNamed(context, "/edit");},
              onSavePressed: () {},
              iconButton: 'lib/design/assets/icons/left.svg',
            )
          ],
        ),
      ),
    );
  }
}