import 'dart:ui';

import 'package:app/core/nodes/PrintNode.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/viewmodels/positioned_block.dart';

class PrintBlock implements PositionedBlock{
  @override
  Offset position;
  Color color;
  String blockName;
  PrintNode node;
  @override
  String nodeId;
  VariableRegistry registry;
  bool isEditing;
  bool wasEdited;

  double width;
  double height;

  PrintBlock({
    required this.position,
    required this.color,
    required this.blockName,
    required this.node,
    required this.nodeId,
    required this.registry,
    this.isEditing = false,
    this.wasEdited = false,
    this.width = 200,
    this.height = 60,
  });
}
