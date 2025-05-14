import 'dart:ui';

import 'package:app/blocks/positioned_block.dart';
import 'package:app/core/nodes/AssignNode.dart';

class AssignmentBlock implements PositionedBlock{
  @override
  Offset position;
  Color color;
  String blockName;
  AssignNode node;
  @override
  String nodeId;
  bool isEditing;
  bool wasEdited;

  double width;
  double height;

  AssignmentBlock({
    required this.position,
    required this.color,
    required this.blockName,
    required this.node,
    required this.nodeId,
    this.isEditing = false,
    this.wasEdited = false,
    this.width = 200,
    this.height = 80,
  });
}
