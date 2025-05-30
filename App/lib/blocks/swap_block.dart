import 'dart:ui';

import 'package:app/blocks/positioned_block.dart';
import 'package:app/core/nodes/assign_node.dart';

import '../core/nodes/swap_node.dart';
import '../utils/offset_extension.dart';

class SwapBlock implements PositionedBlock {
  @override
  Offset position;
  String blockName;
  SwapNode node;
  bool isEditing;
  bool wasEdited;

  double width;
  double height;

  SwapBlock({
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
      'node': SwapNode.toJson_(node),
      'blockName': blockName,
      'width': width,
      'height': height,
      'isEditing': isEditing,
      'wasEdited': wasEdited,
    };
  }

  factory SwapBlock.fromJson(Map<String, dynamic> json) {
    return SwapBlock(
      position: OffsetExtension.fromJson(json['position']),
      node: SwapNode.fromJson(json['node']),
      blockName: json['blockName'],
      width: json['width'],
      height: json['height'],
      isEditing: json['isEditing'],
      wasEdited: json['wasEdited'],
    );
  }
}
