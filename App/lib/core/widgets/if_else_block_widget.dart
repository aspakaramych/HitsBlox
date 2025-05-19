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
        widget.block.height += 40;
        widget.block.leftArrows.add(
          Position(Offset(widget.block.leftArrows[widget.block.leftArrows.length - 1].position.dx, widget.block.leftArrows[widget.block.leftArrows.length - 1].position.dy + 40), false),
        );
        widget.block.rightArrows.add(
          Position(Offset(widget.block.rightArrows[widget.block.rightArrows.length - 1].position.dx, widget.block.rightArrows[widget.block.leftArrows.length - 1].position.dy + 40), false),
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
        onLongPress: () => widget.deleteNode(),
        child: Material(
          elevation: 15,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Container(
            width: widget.block.width,
            height: widget.block.height,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: widget.block.width,
                    height: widget.block.height - 30,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        // border: Border.all(color: Colors.black, width: 3),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 5,
                            offset: Offset(0, -5),)
                        ]
                    ),
                  ),
                ),
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
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: FloatingActionButton(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: CircleBorder(),
                      onPressed: () => expandBlock(),
                      child: const Icon(Icons.add),
                    ),
                  )
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
                      child: Text(
                        widget.block.blockName,
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child:
                      Center(
                        child: Text(
                          "if",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    for (int i = 0; i < widget.block.leftArrows.length - 1; i++)
                      SizedBox(
                        height: 40,
                        child:
                          Center(
                            child: Text(
                              "else if",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                      ),
                    SizedBox(
                      height: 40,
                      child:
                      Center(
                        child: Text(
                          "else",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
