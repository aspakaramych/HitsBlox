import 'package:app/core/nodes/BoolAssignNode.dart';
import 'package:app/utils/pair.dart';
import 'package:flutter/material.dart';

import '../core/nodes/AssignNode.dart';
import '../core/nodes/IntAssignNode.dart';
import '../core/widgets/assignment_widget.dart';
import '../utils/Randomizer.dart';
import '../utils/bezier_line_painter.dart';
import '../viewmodels/assignment_block.dart';
import '../utils/background_painter.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final List<AssignmentBlock> assignmentBlocks = [];
  final blockColor = Colors.red;

  final List<Pair> wiredBlocks = [];
  var temp;

  void addIntBlock() {
    final currUserOffset = getVisibleContentRect().topLeft;
    final assignNode = IntAssignNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 50),
    );

    setState(() {
      assignmentBlocks.add(
        AssignmentBlock(
          position: assignNode.position,
          color: Colors.blueAccent,
          blockName: "int",
          assignNode: assignNode,
        ),
      );
    });
  }

  void addBoolBlock() {
    final currUserOffset = getVisibleContentRect().topLeft;
    final assignNode = BoolAssignNode(
      'node_${Randomizer.getRandomInt()}',
       Offset(currUserOffset.dx + 50, currUserOffset.dy + 50),
    );

    setState(() {
      assignmentBlocks.add(
        AssignmentBlock(
          position: assignNode.position,
          color: Colors.deepPurple,
          blockName: "bool",
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

    _transformationController.value =
        Matrix4.identity()..translate(-centerX, -centerY);
  }

  final Size _viewportSize = Size(1, 1);

  Rect getVisibleContentRect() {
    final Matrix4 matrix = _transformationController.value;
    final double scaleX = matrix.getColumn(0).x;
    final double scaleY = matrix.getColumn(1).y;
    final double translateX = matrix.getTranslation().x;
    final double translateY = matrix.getTranslation().y;

    final double viewportWidth = _viewportSize.width;
    final double viewportHeight = _viewportSize.height;

    final double visibleLeft = -translateX / scaleX;
    final double visibleTop = -translateY / scaleY;
    final double visibleRight = visibleLeft + viewportWidth / scaleX;
    final double visibleBottom = visibleTop + viewportHeight / scaleY;

    return Rect.fromLTRB(visibleLeft, visibleTop, visibleRight, visibleBottom);
  }

  final TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer(
            transformationController: _transformationController,
            constrained: false,
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
                  CustomPaint(
                    size: Size(
                      constraints.maxWidth * 10,
                      constraints.maxHeight * 3,
                    ),
                    painter: BackgroundPainter(),
                  ),

                  for (var block in assignmentBlocks)
                    AssignmentBlockWidget(
                      key: ValueKey(block.assignNode.id),
                      block: block,
                      onEditToggle: () {
                        setState(() {
                          block.isEditing = !block.isEditing;
                        });
                      },
                      deleteNode: () {
                        setState(() {
                          assignmentBlocks.remove(block);
                          for(var binding in wiredBlocks) {
                            if(binding.first.assignNode.id == block.assignNode.id ||
                                binding.second.assignNode.id == block.assignNode.id) {
                              wiredBlocks.remove(binding);
                            }
                          }
                        });
                      },
                      onPositionChanged: (newPosition) {
                        setState(() {
                          block.position = newPosition;
                        });
                      },
                      onLeftArrowClick: () {
                        setState(() {
                          if(temp != null) {
                            wiredBlocks.add(Pair(temp, block));
                            temp = null;
                          }
                        });
                      },
                      onRightArrowClick: () {
                        setState(() {
                          temp = block;
                        });
                      },
                    ),
                  for(var binding in wiredBlocks)
                    CustomPaint(
                      painter: BezierLinePainter(binding.first.position, binding.second.position),
                      size: MediaQuery.of(context).size,
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: addIntBlock,
            child: const Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: addBoolBlock,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
