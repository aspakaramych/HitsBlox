import 'package:app/blocks/print_block.dart';
import 'package:flutter/material.dart';
import '../../utils/sizes.dart';
import '../../utils/triangle_painter.dart';
import '../../blocks/assignment_block.dart';

class PrintBlockWidget extends StatefulWidget {
  final PrintBlock block;
  final VoidCallback onEditToggle;
  final Function() deleteNode;
  final Function(Offset) onPositionChanged;
  final Function() onLeftArrowClick;
  final Function() onRightArrowClick;

  const PrintBlockWidget({
    super.key,
    required this.block,
    required this.onEditToggle,
    required this.deleteNode,
    required this.onPositionChanged,
    required this.onLeftArrowClick,
    required this.onRightArrowClick,
  });

  @override
  _PrintBlockWidgetState createState() => _PrintBlockWidgetState();
}

class _PrintBlockWidgetState extends State<PrintBlockWidget> {
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
            color: Colors.grey,
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
                    width: 30,
                    height: 30,
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
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: SizedBox(
                        width: 100,
                        child: TextField(
                          controller: TextEditingController(
                            text: widget.block.node.rawExpression,
                          ),
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (text) {
                            widget.block.node.rawExpression = text;
                            widget.onEditToggle();
                          },
                          decoration: const InputDecoration(
                            hintText: '{value} or text',
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
                            if (widget.block.node.rawExpression != '')
                              SizedBox(
                                width: 120,
                                child: Chip(
                                  label: Text(widget.block.node.rawExpression),
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
