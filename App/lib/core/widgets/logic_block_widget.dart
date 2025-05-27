import 'package:app/utils/sizes.dart';
import 'package:app/blocks/logic_block.dart';
import 'package:flutter/material.dart';

import '../../utils/triangle_painter.dart';

class LogicBlockWidget extends StatefulWidget {
  final LogicBlock block;
  final bool mark;
  final Function() deleteNode;
  final Function(Offset) onPositionChanged;
  final Function(Offset, int) onLeftArrowClick;
  final Function() onRightArrowClick;

  const LogicBlockWidget({
    super.key,
    required this.block,
    required this.mark,
    required this.deleteNode,
    required this.onPositionChanged,
    required this.onLeftArrowClick,
    required this.onRightArrowClick,
  });

  @override
  _LogicBlockWidgetState createState() => _LogicBlockWidgetState();
}

class _LogicBlockWidgetState extends State<LogicBlockWidget> {
  Offset _currentOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _currentOffset = widget.block.position;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: (widget.mark) ? Colors.red : Theme.of(context).colorScheme.primaryContainer,
                          width: 2,
                        ),
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
                for(int i = 0; i < widget.block.leftArrows.length; i++)
                  Positioned(
                    left: widget.block.leftArrows[i].position.dx,
                    top: widget.block.leftArrows[i].position.dy,
                    child: GestureDetector(
                      onTap: () => widget.onLeftArrowClick(widget.block.leftArrows[i].position, i),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: CustomPaint(painter: TrianglePainter(Sizes.arrowSize, Theme.of(context).colorScheme.onPrimaryContainer)),
                        ),
                      ),
                    ),
                  ),
                /// правая стрелка
                for(int i = 0; i < widget.block.rightArrows.length; i++)
                  Positioned(
                    right: 0,
                    top: widget.block.rightArrows[i].position.dy,
                    child: GestureDetector(
                      onTap: () => widget.onRightArrowClick(),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: CustomPaint(painter: TrianglePainter(Sizes.arrowSize, Theme.of(context).colorScheme.onPrimaryContainer)),
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