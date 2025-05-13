import 'package:app/viewmodels/logic_block.dart';
import 'package:flutter/material.dart';

import '../../utils/triangle_painter.dart';

class LogicBlockWidget extends StatefulWidget {
  final LogicBlock block;
  final Function() deleteNode;
  final Function(Offset) onPositionChanged;
  final Function() onLeftArrowClick;
  final Function() onRightArrowClick;
  final Function(Offset) onInputValueClick;
  final Function(Offset) onOutputValueClick;

  const LogicBlockWidget({
    super.key,
    required this.block,
    required this.deleteNode,
    required this.onPositionChanged,
    required this.onLeftArrowClick,
    required this.onRightArrowClick,
    required this.onInputValueClick,
    required this.onOutputValueClick,
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
        onDoubleTap: () => widget.deleteNode(),
        child: Container(
          width: widget.block.width,
          height: widget.block.height,
          decoration: BoxDecoration(
            color: widget.block.color,
            border: Border.all(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 15,
                top: 15,
                child: GestureDetector(
                  onTap: () => widget.onLeftArrowClick(),
                  child: SizedBox(
                    width: 15,
                    height: 15,
                    child: CustomPaint(painter: TrianglePainter()),
                  ),
                ),
              ),

              /// правая стрелка
              Positioned(
                right: 15,
                top: 15,
                child: GestureDetector(
                  onTap: () => widget.onRightArrowClick(),
                  child: SizedBox(
                    width: 15,
                    height: 15,
                    child: CustomPaint(painter: TrianglePainter()),
                  ),
                ),
              ),
              /// левые кружки
              for(int i = 0; i < widget.block.inputValues.length; i++)
                Positioned(
                  left: widget.block.inputValues[i].position.dx,
                  top: widget.block.inputValues[i].position.dy,
                  child: GestureDetector(
                    onTap: () => widget.onInputValueClick(widget.block.inputValues[i].position - Offset(0, 3)),
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              /// правые кружки
              for(int i = 0; i < widget.block.outputValues.length; i++)
                Positioned(
                  right: widget.block.outputValues[i].position.dx,
                  top: widget.block.outputValues[i].position.dy,
                  child: GestureDetector(
                    onTap: () => widget.onOutputValueClick(widget.block.outputValues[i].position - Offset(0, 3)),
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
