import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app/screens/main_screen.dart';
import 'package:app/design/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageSaves extends StatefulWidget {

  const StorageSaves({super.key});

  @override
  State<StorageSaves> createState() => _StorageSavesState();
}

class _StorageSavesState extends State<StorageSaves> {
  int itemCount = 0;
  List<String> keys = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSharedPreferences();
    });
  }

  Future<void> loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      keys = prefs.getKeys().toList();
      itemCount = keys.length;
    });
  }

  Future<void> _deleteSave(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);

    setState(() {
      keys.remove(key);
      itemCount = keys.length;
    });
  }

  Future<Map<String, dynamic>?> _loadScreen(String screenName) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(screenName);

    final savedState = jsonDecode(jsonString!) as Map<String, dynamic>;
    return savedState;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final String key = keys[index];
          return Stack(
            children: [
              GestureDetector(
                onTap: () async {
                  var savedState = null;
                  if(key != "Новое сохранение") {
                    savedState = await _loadScreen(key);
                  }
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => key != "Новое сохранение"
                          ? MainScreen(savedState, screenName: key)
                          : MainScreen(null, screenName: ''),
                    ),
                  );
                },
                child: Card(
                  color: Theme.of(context).colorScheme.primaryFixed,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      '$key',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                      ),
                    ),
                  ),
                ),
              ),
              if (key != "Новое сохранение")
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _deleteSave(key),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Theme.of(context).colorScheme.secondary,
      child: StorageSaves()
    );
  }
}