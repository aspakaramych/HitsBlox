import 'dart:ui';

import 'package:app/utils/offset_extension.dart';

import '../core/abstracts/node.dart';

class PositionedBlock {
  final Offset position;
  final String nodeId;

  PositionedBlock(this.position, this.nodeId);

  static Map<String, dynamic> toJson(PositionedBlock block) {
    return {'position': block.position.toJson(), 'nodeId': block.nodeId};
  }

  factory PositionedBlock.fromJson(Map<String, dynamic> json) {
    return PositionedBlock(
      OffsetExtension.fromJson(json['position']),
      json['nodeId'],
    );
  }
}
