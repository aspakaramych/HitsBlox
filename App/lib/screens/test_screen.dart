import 'package:flutter/material.dart';

import '../core/nodes/AssignNode.dart';
import '../core/widgets/assignment_widget.dart';
import '../utils/Randomizer.dart';
import '../viewmodels/assignment_block.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final List<AssignmentBlock> assignmentBlocks = [];
  final blockColor = Colors.red;

  void addIntBlock() {
    final currUserOffset = getVisibleContentRect().topLeft;
    final assignNode = AssignNode(
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
    final assignNode = AssignNode(
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

    final contentWidth = viewportSize.width * 5;
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
                minWidth: constraints.maxWidth * 5,
                minHeight: constraints.maxHeight * 3,
              ),
              color: Colors.white10,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(
                      constraints.maxWidth * 5,
                      constraints.maxHeight * 3,
                    ),
                    painter: BackgroundPaint(),
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
                        });
                      },
                      onPositionChanged: (newPosition) {
                        setState(() {
                          block.position = newPosition;
                        });
                      },
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

class BackgroundPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Colors.white12;

    final heightLine = height ~/ 40; // вот такое целочисленное деление (~delenye) :D
    final widthLine = width ~/ 30;

    for (int i = 1; i < height; i++) {
      if (i % heightLine == 0) {
        Path linePath = Path();
        linePath.addRect(
          Rect.fromLTRB(0, i.toDouble(), width, (i + 2).toDouble()),
        );
        canvas.drawPath(linePath, paint);
      }
    }
    for (int i = 1; i < width; i++) {
      if (i % widthLine == 0 || i == 1) {
        Path linePath = Path();
        linePath.addRect(
          Rect.fromLTRB(i.toDouble(), 0, (i + 2).toDouble(), height),
        );
        canvas.drawPath(linePath, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
