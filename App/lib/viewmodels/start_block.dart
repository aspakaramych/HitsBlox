import 'dart:ui';

import 'package:app/viewmodels/positioned_block.dart';

import '../core/nodes/StartNode.dart';

class StartBlock implements PositionedBlock {
  @override
  Offset position;
  StartNode node;
  Color color;
  String blockName;

  double width;
  double height;

  StartBlock({
    required this.position,
    required this.node,
    required this.color,
    required this.blockName,
    this.width = 200,
    this.height = 60,
  });

  @override
  String get nodeId => node.id;
}
