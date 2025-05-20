import 'package:app/blocks/comment_block.dart';
import 'package:flutter/material.dart';

class CommentBlockWidget extends StatefulWidget {
  final CommentBlock block;
  final VoidCallback onEditToggle;
  final Function() deleteNode;
  final Function(Offset) onPositionChanged;

  const CommentBlockWidget({
    super.key,
    required this.block,
    required this.onEditToggle,
    required this.deleteNode,
    required this.onPositionChanged,
  });

  @override
  _CommentBlockWidgetState createState() => _CommentBlockWidgetState();
}

class _CommentBlockWidgetState extends State<CommentBlockWidget> {
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
              // border: Border.all(color: Colors.black, width: 3),
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
                        color: Colors.grey,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Center()),
                    if (widget.block.isEditing)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: SizedBox(
                          // width: 135,
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
                                hintText: 'your comment',
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
                    // TODO: один клик по тексту - и должна открываться клавиатура
                    if (!widget.block.isEditing)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Wrap(
                            spacing: 2,
                            runSpacing: 2,
                            children: [
                              if(widget.block.node.rawExpression != '')
                                SizedBox(
                                  width: 100,
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
                                      label: Text(widget.block.node.rawExpression,),
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
