import 'package:flutter/material.dart';

import '../../utils/triangle_painter.dart';
import '../../viewmodels/start_block.dart';

class StartBlockWidget extends StatefulWidget {
  final StartBlock block;
  final Function() deleteNode;
  final Function(Offset) onPositionChanged;
  final Function() onLeftArrowClick;
  final Function() onRightArrowClick;

  const StartBlockWidget({
    super.key,
    required this.block,
    required this.deleteNode,
    required this.onPositionChanged,
    required this.onLeftArrowClick,
    required this.onRightArrowClick,
  });

  @override
  _StartBlockWidgetState createState() => _StartBlockWidgetState();
}

class _StartBlockWidgetState extends State<StartBlockWidget> {
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
