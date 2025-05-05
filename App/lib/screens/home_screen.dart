import 'package:flutter/material.dart';
import 'TestScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const String from = "home";
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/test-page');
            },
            child: const Icon(Icons.navigate_next),
          ),
        ],
      ),

    );
  }
}
