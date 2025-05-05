import 'package:flutter/material.dart';
import '../../viewmodels/AssignmentNode.dart';

class AssignmentBlockWidget extends StatelessWidget {
  final AssignmentBlock block;
  final VoidCallback onEditToggle;
  final Function(Offset) onDragEnd;
  final Function() deleteNode;

  const AssignmentBlockWidget({
    super.key,
    required this.block,
    required this.onEditToggle,
    required this.onDragEnd,
    required this.deleteNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var totalHeight = block.height + 60;

    return Draggable(
      feedback: Container(
        width: block.width,
        height: block.height,
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      childWhenDragging: Container(
        width: block.width,
        height: block.height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onDraggableCanceled: (_, offset) => onDragEnd(offset),
      child: GestureDetector(
        onTap: () => {
          onEditToggle(),
          block.height += (block.wasEdited) ? 0 : 60,
          block.wasEdited = true
        },
        onDoubleTap: () => deleteNode(),
        child: Container(
          width: block.width,
          height: block.height,
          decoration: BoxDecoration(
            color: Colors.red,
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
                    block.assignNode.title,
                    style: theme.textTheme.labelSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (block.isEditing)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: TextEditingController(
                      text: block.assignNode.rawExpression,
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (text) {
                      block.assignNode.setAssignmentsFromText(text);
                      onEditToggle();
                    },
                    decoration: const InputDecoration(
                      hintText: 'a=10; b=a+5;',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(4),
                    ),
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              if (!block.isEditing && block.assignNode.outputs.isNotEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      children:
                      block.assignNode.outputs
                          .where((p) => !p.isInput && p.id != 'exec_out')
                          .map((pin) {
                        final value = pin.getValue() ?? '?';
                        final name = pin.name;
                        return Chip(
                          label: Text('$name: $value'),
                          backgroundColor: Colors.black.withValues(alpha: 0.3),
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