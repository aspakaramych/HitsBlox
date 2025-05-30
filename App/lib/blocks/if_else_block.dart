import 'dart:ui';

import 'package:app/core/abstracts/node.dart';
import 'package:app/blocks/position.dart';
import 'package:app/blocks/positioned_block.dart';
import 'package:app/utils/offset_extension.dart';

class IfElseBlock implements PositionedBlock {
  @override
  Offset position;
  Node node;
  String blockName;
  List<Position> leftArrows;
  List<Position> rightArrows;

  double width;
  double height;

  IfElseBlock({
    required this.position,
    required this.node,
    required this.blockName,
    required this.width,
    required this.height,
    required this.leftArrows,
    required this.rightArrows,
  });

  @override
  String get nodeId => node.id;

  Map<String, dynamic> toJson() {
    return {
      'position': position.toJson(),
      'node': node.toJson(),
      'blockName': blockName,
      'width': width,
      'height': height,
      'leftArrows': leftArrows.map((l) => l.toJson()).toList(),
      'rightArrows': rightArrows.map((r) => r.toJson()).toList(),
    };
  }

  factory IfElseBlock.fromJson(Map<String, dynamic> json) {
    return IfElseBlock(
      position: OffsetExtension.fromJson(json['position']),
      node: Node.fromJson(json['node']),
      blockName: json['blockName'],
      width: json['width'],
      height: json['height'],
      leftArrows: (json['leftArrows'] as List).map((arrow) => Position.fromJson(arrow)).toList(),
      rightArrows: (json['rightArrows'] as List).map((arrow) => Position.fromJson(arrow)).toList(),
    );
  }
}