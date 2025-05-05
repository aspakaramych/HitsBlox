import 'dart:ui';

import 'package:app/core/abstracts/Node.dart';

import '../core/models/block_types.dart';
import '../core/nodes/AssignNode.dart';

class MovableBlock {
  Offset position;
  Node node;
  bool isEditing;
  BockType type;
  Color color;

  double width;
  double height;

  MovableBlock({required this.position, required this.node, this.isEditing = false, required this.type, required this.color, this.height = 100, this.width = 100});
}