import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../core/nodes/AssignNode.dart';
import '../core/widgets/DraggableLogicBlock.dart';
import '../utils/Randomizer.dart';
import '../viewmodels/AssignmentNode.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  final List<AssignmentBlock> assignmentBlocks = [];
  final blockColor = Colors.red;

  void addLogicBlock() {
    final currUserOffset = getVisibleContentRect().topLeft;
    // print(Offset(currUserOffset.dx + 50, currUserOffset.dy + 50));
    final assignNode = AssignNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 50),
    );

    setState(() {
      assignmentBlocks.add(
        AssignmentBlock(
          position: assignNode.position,
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

    _transformationController.value = Matrix4.identity()
      ..translate(-centerX, -centerY);
  }

  Size _viewportSize = new Size(1, 1);

  Rect getVisibleContentRect() {
    final Matrix4 matrix = _transformationController.value;
    final double scaleX = matrix.getColumn(0).x;
    final double scaleY = matrix.getColumn(1).y;
    final double translateX = matrix.getTranslation().x;
    final double translateY = matrix.getTranslation().y;

    // Размер viewport'а (размер экрана)
    final double viewportWidth = _viewportSize.width;
    final double viewportHeight = _viewportSize.height;

    // Координаты видимой области в системе координат контента
    final double visibleLeft = -translateX / scaleX;
    final double visibleTop = -translateY / scaleY;
    final double visibleRight = visibleLeft + viewportWidth / scaleX;
    final double visibleBottom = visibleTop + viewportHeight / scaleY;

    return Rect.fromLTRB(
      visibleLeft,
      visibleTop,
      visibleRight,
      visibleBottom,
    );
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
                    Positioned(
                      left: block.position.dx,
                      top: block.position.dy,
                      child: AssignmentBlockWidget(
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

class BackgroundPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Colors.white12;

    final heightLine = height ~/ 40;
    final widthLine = (width ~/ 30);

    for(int i = 1 ; i < height ; i++){
      if(i % heightLine == 0){
        Path linePath = Path();
        linePath.addRect(Rect.fromLTRB(0, i.toDouble(), width, (i+2).toDouble()));
        canvas.drawPath(linePath, paint);
      }
    }
    for(int i = 1 ; i < width; i++){
      if(i % widthLine == 0 || i == 1) {
        Path linePath = Path();
        linePath.addRect(Rect.fromLTRB(i.toDouble(), 0 , (i+2).toDouble(), height));
        canvas.drawPath(linePath, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}