import 'dart:ui';

import 'package:app/core/nodes/add_node.dart';
import 'package:app/core/nodes/concat_node.dart';
import 'package:app/core/nodes/divide_node.dart';
import 'package:app/core/nodes/equals_node.dart';
import 'package:app/core/nodes/greater_or_equal_node.dart';
import 'package:app/core/nodes/if_else_node.dart';
import 'package:app/core/nodes/less_node.dart';
import 'package:app/core/nodes/less_or_equal_node.dart';
import 'package:app/core/nodes/mod_node.dart';
import 'package:app/core/nodes/more_node.dart';
import 'package:app/core/nodes/multiply_node.dart';
import 'package:app/core/nodes/print_node.dart';
import 'package:app/core/nodes/start_node.dart';
import 'package:app/core/nodes/sub_node.dart';

import 'bool_assign_node.dart';
import 'int_assign_node.dart';
import 'string_assign_node.dart';

class NodeFactory {
  static createNode(Offset position, String id, String type) {
    switch(type) {
      case 'Присвоить (int)':
        return IntAssignNode(id, position);
      case 'Присвоить (bool)':
        return BoolAssignNode(id, position);
      case 'Присвоить (string)':
        return StringAssignNode(id, position);
      case 'Сложение':
        return AddNode(id, position);
      case 'Конкатенация':
        return ConcatNode(id, position);
      case 'Деление':
        return DivideNode(id, position);
      case 'Эквивалентность':
        return EqualsNode(id, position);
      case 'Условие':
        return IfElseNode(id, position);
      case 'Меньше':
        return LessNode(id, position);
      case 'Больше':
        return MoreNode(id, position);
      case 'Умножение':
        return MultiplyNode(id, position);
      case 'Старт':
        return StartNode(id, position);
      case 'Вычитание':
        return SubNode(id, position);
      case 'Остаток от деления':
        return ModNode(id, position);
      case '>=':
        return GreaterOrEqualNode(id, position);
      case '<=':
        return LessOrEqualNode(id, position);
    }
  }
}