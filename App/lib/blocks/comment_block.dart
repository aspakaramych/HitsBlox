import 'dart:ui';

import 'package:app/blocks/positioned_block.dart';
import 'package:app/core/nodes/assign_node.dart';

import '../utils/offset_extension.dart';

class CommentBlock implements PositionedBlock {
  @override
  Offset position;
  String blockName;
  AssignNode node;
  bool isEditing;
  bool wasEdited;

  double width;
  double height;

  CommentBlock({
    required this.position,
    required this.blockName,
    required this.node,
    this.isEditing = false,
    this.wasEdited = false,
    this.width = 200,
    this.height = 100,
  });

  @override
  String get nodeId => node.id;

  Map<String, dynamic> toJson() {
    return {
      'position': position.toJson(),
      'node': AssignNode.toJson_(node),
      'blockName': blockName,
      'width': width,
      'height': height,
      'isEditing': isEditing,
      'wasEdited': wasEdited,
    };
  }

  factory CommentBlock.fromJson(Map<String, dynamic> json) {
    return CommentBlock(
      position: OffsetExtension.fromJson(json['position']),
      node: AssignNode.fromJson(json['node']),
      blockName: json['blockName'],
      width: json['width'],
      height: json['height'],
      isEditing: json['isEditing'],
      wasEdited: json['wasEdited'],
    );
  }
}
