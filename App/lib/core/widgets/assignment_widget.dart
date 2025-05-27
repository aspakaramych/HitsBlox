import 'package:flutter/material.dart';

import '../../blocks/assignment_block.dart';
import '../../utils/sizes.dart';
import '../../utils/triangle_painter.dart';

class AssignmentBlockWidget extends StatefulWidget {
  final AssignmentBlock block;
  final bool mark;
  final VoidCallback onEditToggle;
  final Function() deleteNode;
  final Function(Offset) onPositionChanged;
  final Function(int) onLeftArrowClick;
  final Function() onRightArrowClick;

  const AssignmentBlockWidget({
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

  List<String> divideParams() {
    List<String> arr = widget.block.node.rawExpression.split(';');
    if (arr[arr.length - 1].isEmpty) arr.removeLast();
    return arr;
  }

  Widget buildActiveInputField() {
    return TextField(
      controller: TextEditingController(
        text: widget.block.node.rawExpression,
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onSubmitted: (text) {
        widget.block.node.rawExpression = text;
        widget.onEditToggle();
      },
      decoration: InputDecoration(
        hintText: (widget.block.blockName != 'array') ? 'a=value;' : 'type a = [size]',
        contentPadding: const EdgeInsets.all(6),
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      style: Theme.of(context).textTheme.labelLarge,
    );
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
            widget.block.wasEdited = true;
          });
        },
        onLongPress: () => widget.deleteNode(),
        child: Material(
          elevation: 15,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: widget.block.height),
            child: Container(
              width: widget.block.width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Center(
                        child: Text(
                          widget.block.blockName,
                          style: theme.textTheme.headlineSmall
                        )
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
                            padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(5),
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
                                  child: (widget.block.isEditing)
                                  ? buildActiveInputField()
                                      : (() {
                                    List<String> arr = divideParams();
                                    if (arr.isEmpty) return buildActiveInputField();
                                    return Column(
                                      children: [
                                        for (String item in arr)
                                          Text(
                                            item,
                                            style: Theme.of(context).textTheme.labelLarge,
                                            maxLines: 1,
                                          )
                                      ],
                                    );
                                  })()
                                  )
                                ),
                              )
                            )
                          )
                        ]
                      )
                    ,

                  // левая стрелка
                  Positioned(
                    left: 15,
                    top: 55,
                    child: GestureDetector(
                      onTap: () => widget.onLeftArrowClick(0),
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

                  // правая стрелка
                  Positioned(
                    right: -20,
                    top: 55,
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
              ]
              ),
              ),
            ),
          ),
        ),
      );
  }
}
