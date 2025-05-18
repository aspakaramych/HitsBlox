import 'package:app/blocks/if_else_block.dart';
import 'package:app/blocks/position.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

import '../../utils/triangle_painter.dart';

class IfElseBlockWidget extends StatefulWidget {
  final IfElseBlock block;
  final Function() deleteNode;
  final Function(Offset) onPositionChanged;
  final Function(Offset) onLeftArrowClick;
  final Function(Offset) onRightArrowClick;

  const IfElseBlockWidget({
    super.key,
    required this.block,
    required this.deleteNode,
    required this.onPositionChanged,
    required this.onLeftArrowClick,
    required this.onRightArrowClick,
  });

  @override
  _IfElseBlockWidgetState createState() => _IfElseBlockWidgetState();
}

class _IfElseBlockWidgetState extends State<IfElseBlockWidget> {
  Offset _currentOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _currentOffset = widget.block.position;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void expandBlock() {
      setState(() {
        widget.block.height += 30;
        widget.block.leftArrows.add(
          Position(Offset(15, widget.block.height - 65), false),
        );
        widget.block.rightArrows.add(
          Position(Offset(15, widget.block.height - 35), false),
        );
      });
    }

    return Positioned(
      left: _currentOffset.dx,
      top: _currentOffset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _currentOffset += details.delta;
            widget.block.position = _currentOffset;
          });
          widget.onPositionChanged(_currentOffset);
        },
        onDoubleTap: () => widget.deleteNode(),
        child: Container(
          width: widget.block.width,
          height: widget.block.height,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              /// левая стрелка
              for (int i = 0; i < widget.block.leftArrows.length; i++)
                Positioned(
                  left: widget.block.leftArrows[i].position.dx,
                  top: widget.block.leftArrows[i].position.dy,
                  child: GestureDetector(
                    onTap:
                        () => widget.onLeftArrowClick(
                          widget.block.leftArrows[i].position,
                        ),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CustomPaint(
                          painter: TrianglePainter(Sizes.arrowSize, Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                      ),
                    ),
                  ),
                ),

              /// правая стрелка
              for (int i = 0; i < widget.block.rightArrows.length; i++)
                Positioned(
                  right: 0,
                  top: widget.block.rightArrows[i].position.dy,
                  child: GestureDetector(
                    onTap: () => widget.onRightArrowClick(widget.block.rightArrows[i].position),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CustomPaint(
                          painter: TrianglePainter(Sizes.arrowSize, Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                      ),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.block.blockName,
                        style: theme.textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: FloatingActionButton(
                        onPressed: () => expandBlock(),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
