import 'dart:ui';

import 'package:app/utils/offset_extension.dart';

class PositionedBlock {
  final Offset position;
  final String nodeId;


  PositionedBlock(this.position, this.nodeId);

  Map<String, dynamic> toJson() {
    return {
      'position': position.toJson(),
      'nodeId': nodeId
    };
  }

  factory PositionedBlock.fromJson(Map<String, dynamic> json) {
    return PositionedBlock(
        OffsetExtension.fromJson(json['position']),
        json['nodeId']
    );
  }
}