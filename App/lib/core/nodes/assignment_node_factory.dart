import 'dart:ui';

import 'package:app/core/nodes/ArrayAddNode.dart';
import 'package:app/core/nodes/ArrayAsignNode.dart';
import 'package:app/core/nodes/BoolAssignNode.dart';
import 'package:app/core/nodes/IncrementNode.dart';
import 'package:app/core/nodes/IntAssignNode.dart';
import 'package:app/core/nodes/StringAssignNode.dart';

class AssignmentNodeFactory {
  static createNode(Offset position, String id, String type) {
    switch (type) {
      case 'Присвоить (int)':
        return IntAssignNode(id, position);
      case 'Присвоить (bool)':
        return BoolAssignNode(id, position);
      case 'Присвоить (string)':
        return StringAssignNode(id, position);
      case 'Присвоить (array)':
        return ArrayAsignNode(id, position);
      case 'Добавить (array)':
        return ArrayAddNode(id, position);
      case 'Инкремент':
        return IncrementNode(id, position);
    }
  }
}
