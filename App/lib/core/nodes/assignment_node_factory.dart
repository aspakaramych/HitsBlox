import 'dart:ui';

import 'package:app/core/nodes/array_add_node.dart';
import 'package:app/core/nodes/array_assign_node.dart';
import 'package:app/core/nodes/bool_assign_node.dart';
import 'package:app/core/nodes/increment_node.dart';
import 'package:app/core/nodes/int_assign_node.dart';
import 'package:app/core/nodes/length_node.dart';
import 'package:app/core/nodes/string_assign_node.dart';

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
      case 'Получение длины массива':
        return LengthNode(id, position);
    }
  }
}
