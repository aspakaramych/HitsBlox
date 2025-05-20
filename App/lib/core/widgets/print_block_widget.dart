import 'package:app/blocks/print_block.dart';
import 'package:flutter/material.dart';

import '../../utils/sizes.dart';
import '../../utils/triangle_painter.dart';

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
                Positioned(
                  left: 15,
                  top: 50,
                  child: GestureDetector(
                    onTap: () => widget.onLeftArrowClick(),
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
                Positioned(
                  right: -20,
                  top: 45,
                  child: GestureDetector(
                    onTap: () => widget.onRightArrowClick(),
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
                    Expanded(child: Center()),
                    if (widget.block.isEditing)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.transparent,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                              ),
                              BoxShadow(
                                color: Theme.of(context).colorScheme.secondaryContainer,
                                spreadRadius: -2.0,
                                blurRadius: 2.0,
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
                              hintText: '{value} or text',
                              contentPadding: EdgeInsets.all(6),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                      ),
                    if (!widget.block.isEditing)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 2,
                            children: [
                              if (widget.block.node.rawExpression != '')
                                SizedBox(
                                  width: 120,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      // color: Theme.of(context).colorScheme.secondaryContainer,
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      color: Colors.transparent,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                                        ),
                                        BoxShadow(
                                          color: Theme.of(context).colorScheme.secondaryContainer,
                                          spreadRadius: -2.0,
                                          blurRadius: 2.0,
                                        ),
                                      ],
                                    ),
                                    child: Chip(
                                      label: Text(widget.block.node.rawExpression),
                                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                      labelStyle: theme.textTheme.labelLarge,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    Expanded(child: Center()),
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
