import 'package:app/screens/storage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app/design/widgets/widgets.dart';
import 'package:app/design/theme/colors.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>{

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          Container(
            color: AppColors.primary,
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: RichText(
                text: TextSpan(
                  text: "Настройки",
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 30,
                    fontFamily: "Roboto",
                  )
                ),
              ),
            )
          ),
          Expanded(
            child:
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
                Text("Настройка"),
                Divider(),
              ],
            ),
          ),
          BottomBar(onTerminalPressed: () {}, onAddPressed: () {})
        ],
      ),
    );
  }
}