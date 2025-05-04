import 'dart:developer';

import 'package:flutter/material.dart';

import '../core/nodes/AssignNode.dart';
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

  final List<LogicBlock> logicBlocks = [];
  final blockColor = Colors.red;

  void addLogicBlock() {
    final assignNode = AssignNode(
      'node_${Randomizer.getRandomInt()}',
      const Offset(100, 100),
    );

    setState(() {
      logicBlocks.add(
        LogicBlock(position: const Offset(100, 100), assignNode: assignNode),
      );
    });
  }

  void _showEditDialog(BuildContext context, LogicBlock block) {
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

          for (var block in logicBlocks)
            Positioned(
              left: block.position.dx,
              top: block.position.dy,
              child: GestureDetector(
                onTap: () {
                  // _showEditDialog(context, block);
                  setState(() {
                    block.isEditing = true;
                  });
                },
                onDoubleTap: () {
                  setState(() {
                    logicBlocks.remove(block);
                  });
                },
                child: Draggable(
                  feedback: Container(
                    width: block.width,
                    height: block.height,
                    color: blockColor.withOpacity(0.7),
                  ),
                  childWhenDragging: Container(
                    width: block.width,
                    height: block.height,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white10, width: 2),
                    ),
                  ),
                  onDraggableCanceled: (velocity, offset) {
                    setState(() {
                      block.position = new Offset(offset.dx, offset.dy);
                    });
                  },
                  child: Container(
                    width: block.width,
                    height: block.height + (block.isEditing ? 100 : 0),
                    decoration: BoxDecoration(
                      color: blockColor,
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Присвоить",
                            style: theme.textTheme.labelSmall,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        if (block.isEditing)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              controller: TextEditingController(text: block.assignNode.rawExpression),
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (text) {
                                setState(() {
                                  block.isEditing = false;
                                  block.height = block.height + 60;
                                  block.assignNode.setAssignmentsFromText(text);
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'a=10; b=a+5;',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(4),
                              ),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),

                        if (!block.isEditing && block.assignNode.outputs.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 2,
                              children: block.assignNode.outputs
                                  .where((p) => !p.isInput && p.id != 'exec_out')
                                  .map((pin) {
                                print('${pin.name} ${pin.getValue()}');
                                final value = pin.getValue() ?? '?';
                                final name = pin.name;
                                return Chip(
                                  label: Text('$name: $value'),
                                  backgroundColor: Colors.black.withOpacity(0.3),
                                  labelStyle: const TextStyle(fontSize: 16, color: Colors.white),
                                );
                              }).toList(),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
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
