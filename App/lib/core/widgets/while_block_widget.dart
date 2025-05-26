import 'package:app/blocks/while_block.dart';
import 'package:flutter/material.dart';

import '../../utils/sizes.dart';
import '../../utils/triangle_painter.dart';

class WhileBlockWidget extends StatefulWidget {
  final WhileBlock block;
  final bool mark;
  final VoidCallback onEditToggle;
  final Function() deleteNode;
  final Function(Offset) onPositionChanged;
  final Function() onLeftArrowClick;
  final Function(Offset) onRightArrowClick;

  const WhileBlockWidget({
    super.key,
    required this.block,
    required this.mark,
    required this.onEditToggle,
    required this.deleteNode,
    required this.onPositionChanged,
    required this.onLeftArrowClick,
    required this.onRightArrowClick,
  });

  @override
  _WhileBlockWidgetState createState() => _WhileBlockWidgetState();
}

class _WhileBlockWidgetState extends State<WhileBlockWidget> {
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
            // widget.block.height += 30;
            widget.block.wasEdited = true;
          });
        },
        onLongPress: () => widget.deleteNode(),
        child: Material(
          elevation: 15,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Container(
            width: widget.block.width,
            // height: widget.block.height,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              // border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Center(
                      child: RichText(
                          text: TextSpan(
                              text: widget.block.blockName,
                              style: theme.textTheme.headlineSmall
                          )
                      ),
                    ),
                      ConstrainedBox(
                        constraints: BoxConstraints(minHeight: widget.block.height - 30),
                        child: Container(
                          width: widget.block.width,
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
                                  offset: Offset(0, -5),
                                )
                              ]
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: Colors.transparent,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                                    ),
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.secondaryContainer,
                                      spreadRadius: -4.0,
                                      blurRadius: 4.0,
                                    ),
                                  ],
                                ),
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
                                    hintText: 'a={value};',
                                    //border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.all(6),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  style: theme.textTheme.labelLarge,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                /// левая стрелка
                Positioned(
                  left: 15,
                  top: 45,
                  child: GestureDetector(
                    onTap: () => widget.onLeftArrowClick(),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CustomPaint(painter: TrianglePainter(Sizes.arrowSize, Theme.of(context).colorScheme.onPrimaryContainer)),
                      ),
                    ),
                  ),
                ),

                /// правая стрелка
                Positioned(
                  right: -20,
                  top: 45,
                  child: GestureDetector(
                    onTap: () => widget.onRightArrowClick(Offset(0, 45)),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CustomPaint(painter: TrianglePainter(Sizes.arrowSize, Theme.of(context).colorScheme.onPrimaryContainer)),
                      ),
                    ),
                  ),
                ),

                /// правая стрелка
                Positioned(
                  right: -20,
                  top: 85,
                  child: GestureDetector(
                    onTap: () => widget.onRightArrowClick(Offset(0, 85)),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CustomPaint(painter: TrianglePainter(Sizes.arrowSize, Theme.of(context).colorScheme.onPrimaryContainer)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
