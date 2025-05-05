import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../core/nodes/AssignNode.dart';
import '../core/widgets/DraggableLogicBlock.dart';
import '../utils/Randomizer.dart';
import '../viewmodels/LogicBlock.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  final List<AssignmentBlock> assignmentBlocks = [];
  final blockColor = Colors.red;

  void addLogicBlock() {
    final assignNode = AssignNode(
      'node_${Randomizer.getRandomInt()}',
      const Offset(100, 100),
    );

    setState(() {
      assignmentBlocks.add(
        AssignmentBlock(
          position: const Offset(100, 100),
          assignNode: assignNode,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerInitialPosition();
    });
  }

  void _centerInitialPosition() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final viewportSize = renderBox.size;

    final contentWidth = viewportSize.width * 10;
    final contentHeight = viewportSize.height * 3;

    final centerX = (contentWidth - viewportSize.width) / 2;
    final centerY = (contentHeight - viewportSize.height) / 2;

    _transformationController.value = Matrix4.identity()
      ..translate(-centerX, -centerY);
  }

  final TransformationController _transformationController =
  TransformationController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // appBar: AppBar(title: const Text("Тест")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer(
            transformationController: _transformationController,
            constrained: false,
            // boundaryMargin: EdgeInsets.all(double.infinity),
            minScale: 0.5,
            maxScale: 2.0,
            child: Container(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth * 10,
                minHeight: constraints.maxHeight * 3,
              ),
              color: Colors.white10,
              child: Stack(
                clipBehavior: Clip.none,
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
                          final RenderBox renderBox = context.findRenderObject() as RenderBox;

                          final localOffset = renderBox.globalToLocal(offset);

                          final matrix = _transformationController.value;

                          final invertedMatrix = Matrix4.inverted(matrix);

                          final transformedVector = invertedMatrix.transform3(
                            vector.Vector3(localOffset.dx, localOffset.dy, 0),
                          );

                          final resOffset = Offset(
                            transformedVector.x,
                            transformedVector.y,
                          );

                          setState(() {
                            block.position = resOffset;
                          });
                        },
                        deleteNode: () {
                          setState(() {
                            assignmentBlocks.remove(block);
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addLogicBlock,
        child: const Icon(Icons.add),
      ),
    );
  }
}