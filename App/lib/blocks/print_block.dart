import 'dart:ui';

import 'package:app/core/nodes/print_node.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/blocks/positioned_block.dart';

import '../core/console_service.dart';
import '../utils/offset_extension.dart';

class PrintBlock implements PositionedBlock {
  @override
  Offset position;
  String blockName;
  PrintNode node;
  VariableRegistry registry;
  bool isEditing;
  bool wasEdited;

  double width;
  double height;

  PrintBlock({
    required this.position,
    required this.blockName,
    required this.node,
    required this.registry,
    this.isEditing = false,
    this.wasEdited = false,
    this.width = 200,
    this.height = 60,
  });

  String get nodeId => node.id;

  Map<String, dynamic> toJson() {
    return {
      'position': position.toJson(),
      'node': PrintNode.toJson_(node),
      'blockName': blockName,
      'width': width,
      'height': height,
      'isEditing': isEditing,
      'wasEdited': wasEdited,
    };
  }

  factory PrintBlock.fromJson(Map<String, dynamic> json, VariableRegistry registry, ConsoleService consoleService) {
    return PrintBlock(
      position: OffsetExtension.fromJson(json['position']),
      node: PrintNode.fromJson(json['node'], consoleService),
      registry: registry,
      blockName: json['blockName'],
      width: json['width'],
      height: json['height'],
      isEditing: json['isEditing'],
      wasEdited: json['wasEdited'],
    );
  }
}
