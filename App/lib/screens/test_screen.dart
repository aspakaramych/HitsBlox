import 'dart:developer';

import 'package:flutter/material.dart';

import '../core/nodes/AssignNode.dart';
import '../core/widgets/AssignmentNodeWidget.dart';
import '../utils/Randomizer.dart';
import '../viewmodels/LogicBlock.dart';
import '../viewmodels/MovableBlock.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final List<MovableBlock> squares = [];

  void addRandomSquare() {
    final randomColor =
        Colors.primaries[DateTime.now().second % Colors.primaries.length];
    final newSquare = MovableBlock(
      position: const Offset(100, 100),
      color: randomColor,
    );

    setState(() {
      squares.add(newSquare);
    });
  }

  final List<AssignmentBlock> assignmentBlocks = [];
  final blockColor = Colors.red;

  void addLogicBlock() {
    final assignNode = AssignNode(
      'node_${Randomizer.getRandomInt()}',
      const Offset(100, 100),
    );

    setState(() {
      assignmentBlocks.add(
        AssignmentBlock(position: const Offset(100, 100), assignNode: assignNode),
      );
    });
  }

  void _showEditDialog(BuildContext context, AssignmentBlock block) {
    final controller = TextEditingController(
      text: block.assignNode.rawExpression,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Введите выражение"),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "Например: a=10; b=a+5;",
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("Отмена"),
            ),
            TextButton(
              onPressed: () {
                final text = controller.text;
                block.assignNode.setAssignmentsFromText(text);
                print(block.assignNode.commands);
                Navigator.of(context).pop();
              },
              child: const Text("Сохранить"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // appBar: AppBar(title: const Text("Тест")),
      body: Stack(
        children: [
          const Center(child: Text("тест квадрата")),

          for (var block in assignmentBlocks)
            Positioned(
              left: block.position.dx,
              top: block.position.dy,
              child: AssignmentNodeWidget(
                block: block,
                onEditToggle: () {
                  setState(() {
                    block.isEditing = !block.isEditing;
                  });
                },
                onDragEnd: (offset) {
                  setState(() {
                    block.position = offset;
                  });
                },
                deleteNode: () {
                  setState(() {
                    assignmentBlocks.remove(block);
                  });
                }
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addLogicBlock,
        child: const Icon(Icons.add),
      ),
    );
  }
}
