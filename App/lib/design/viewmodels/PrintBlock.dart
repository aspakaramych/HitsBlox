import 'dart:ui';

import 'package:app/core/nodes/PrintNode.dart';

class PrintBlock{
  Offset position;
  PrintNode printNode;
  bool isEditing;

  double width;
  double height;

  PrintBlock({required this.position, required this.printNode, this.isEditing = false, this.width = 200, this.height = 60});
}