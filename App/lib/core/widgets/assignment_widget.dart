import 'package:flutter/material.dart';
import '../../viewmodels/assignment_block.dart';

class AssignmentBlockWidget extends StatefulWidget {
  final AssignmentBlock block;
  final VoidCallback onEditToggle;
  final Function() deleteNode;
  final Function(Offset) onPositionChanged;

  const AssignmentBlockWidget({
    super.key,
    required this.block,
    required this.onEditToggle,
    required this.deleteNode,
    required this.onPositionChanged,
  });

  @override
  _AssignmentBlockWidgetState createState() => _AssignmentBlockWidgetState();
}

class _AssignmentBlockWidgetState extends State<AssignmentBlockWidget> {
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
        onTap: () {
          widget.onEditToggle();
          setState(() {
            if(widget.block.wasEdited) {
              return;
            }
            widget.block.height += 60;
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
          child: Column(
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: TextEditingController(
                      text: widget.block.assignNode.rawExpression,
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (text) {
                      widget.block.assignNode.setAssignmentsFromText(text);
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
              if (!widget.block.isEditing && widget.block.assignNode.outputs.isNotEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      children:
                          widget.block.assignNode.outputs
                              .where((p) => !p.isInput && p.id != 'exec_out')
                              .map((pin) {
                                return Chip(
                                  label: Text(
                                    '${pin.name}: ${pin.getValue() ?? '?'}',
                                  ),
                                  backgroundColor: Colors.black.withValues(
                                    alpha: 0.3,
                                  ),
                                  labelStyle: theme.textTheme.labelSmall,
                                );
                              }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
