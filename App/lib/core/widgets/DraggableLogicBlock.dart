import 'package:flutter/material.dart';
import '../../viewmodels/LogicBlock.dart';

class AssignmentNodeWidget extends StatelessWidget {
  final AssignmentBlock block;
  final VoidCallback onEditToggle;
  final Function(Offset) onDragEnd;
  final Function() deleteNode;

  const AssignmentNodeWidget({
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
        height: totalHeight,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      childWhenDragging: Container(
        width: block.width,
        height: totalHeight,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white10, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onDraggableCanceled: (_, offset) => onDragEnd(offset),
      child: GestureDetector(
        onTap: () => onEditToggle(),
        onDoubleTap: () => deleteNode(),
        child: Container(
          width: block.width,
          height: totalHeight,
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Присвоить",
                  style: theme.textTheme.labelSmall,
                  textAlign: TextAlign.center,
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
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              if (!block.isEditing && block.assignNode.outputs.isNotEmpty)
                Padding(
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
                                backgroundColor: Colors.black.withOpacity(0.3),
                                labelStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              );
                            })
                            .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
