import 'dart:ui';

import 'package:app/utils/offset_extension.dart';

class Position {
  Offset position;
  bool isWired;

  Position(this.position, this.isWired);

  Map<String, dynamic> toJson() {
    return {'offset': position.toJson(), 'isWired': isWired};
  }

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      OffsetExtension.fromJson(json['offset']),
      json['isWired'] ?? false,
    );
  }
}
