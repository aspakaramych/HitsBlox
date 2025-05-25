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
              padding: EdgeInsets.all(10),
              width: widget.block.width,
              // height: widget.block.height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: TextEditingController(
                  text: widget.block.node.rawExpression,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                onSubmitted: (text) {
                  widget.block.node.rawExpression = text;
                  widget.onEditToggle();
                },
                decoration: const InputDecoration(
                  hintText: 'your comment',
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
    );
  }
}
