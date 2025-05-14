import 'package:flutter/material.dart';
import '../../utils/sizes.dart';
import '../../utils/triangle_painter.dart';
import '../../viewmodels/assignment_block.dart';

class AssignmentBlockWidget extends StatefulWidget {
  final AssignmentBlock block;
  final VoidCallback onEditToggle;
  final Function() deleteNode;
  final Function(Offset) onPositionChanged;
  final Function() onLeftArrowClick;
  final Function() onRightArrowClick;

  const AssignmentBlockWidget({
    super.key,
    required this.block,
    required this.onEditToggle,
    required this.deleteNode,
    required this.onPositionChanged,
    required this.onLeftArrowClick,
    required this.onRightArrowClick,
  });

  @override
  _AssignmentBlockWidgetState createState() => _AssignmentBlockWidgetState();
}

class _AssignmentBlockWidgetState extends State<AssignmentBlockWidget> {
  Offset _currentOffset = Offset.zero;

  String currText = '';

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
        onTap: () {
          widget.onEditToggle();
          setState(() {
            if (widget.block.wasEdited) {
              return;
            }
            widget.block.height += 30;
            widget.block.wasEdited = true;
          });
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
              /// левая стрелка
              Positioned(
                left: 15,
                top: 15,
                child: GestureDetector(
                  onTap: () => widget.onLeftArrowClick(),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CustomPaint(painter: TrianglePainter(Sizes.arrowSize)),
                    ),
                  ),
                ),
              ),

              /// правая стрелка
              Positioned(
                right: -20,
                top: 15,
                child: GestureDetector(
                  onTap: () => widget.onRightArrowClick(),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CustomPaint(painter: TrianglePainter(Sizes.arrowSize)),
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
                  if (widget.block.isEditing)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: 135,
                        child: TextField(
                          controller: TextEditingController(
                            text: widget.block.node.rawExpression,
                          ),
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (text) {
                            currText = text;
                            widget.block.node.setText(text);
                            widget.onEditToggle();
                          },
                          decoration: const InputDecoration(
                            hintText: 'a={value};',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(4),
                          ),
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ),
                  if (!widget.block.isEditing)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: [
                            if(currText != '')
                              SizedBox(
                                width: 100,
                                child: Chip(
                                  label: Text(currText),
                                  backgroundColor: Colors.black.withValues(
                                    alpha: 0.3,
                                  ),
                                  labelStyle: theme.textTheme.labelSmall,
                                ),
                              ),
                          ],
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
