import 'dart:ui';

import 'package:app/core/abstracts/Node.dart';
import 'package:app/blocks/position.dart';
import 'package:app/blocks/positioned_block.dart';

class IfElseBlock implements PositionedBlock {
  @override
  Offset position;
  Node node;
  Color color;
  String blockName;
  List<Position> leftArrows;
  List<Position> rightArrows;

  double width;
  double height;

  IfElseBlock({
    required this.position,
    required this.node,
    required this.color,
    required this.blockName,
    required this.width,
    required this.height,
    required this.leftArrows,
    required this.rightArrows,
  });

  @override
  String get nodeId => node.id;

  //TODO: реализовать сериализацию
  Map<String, dynamic> toJson() {
    return {
      // 'position': position.toJson(),
      // 'node': node.toJson(),
      // 'blockName': blockName,
      // 'width': width,
      // 'height': height,
      // 'isEditing': isEditing,
      // 'wasEdited': wasEdited,
    };
  }

  // factory AssignmentBlock.fromJson(Map<String, dynamic> json) {
  //   return AssignmentBlock(
  //     position: OffsetExtension.fromJson(json['position']),
  //     node: AssignNode.fromJson(json['node']),
  //     blockName: json['blockName'],
  //     width: json['width'],
  //     height: json['height'],
  //     isEditing: json['isEditing'],
  //     wasEdited: json['wasEdited'],
  //   );
  // }
}