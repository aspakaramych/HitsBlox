import 'dart:ui';

import 'package:app/core/nodes/AssignNode.dart';

class AssignmentBlock {
  Offset position;
  AssignNode assignNode;
  bool isEditing;

  double width;
  double height;

  AssignmentBlock({required this.position, required this.assignNode, this.isEditing = false, this.width = 200, this.height = 60});
}