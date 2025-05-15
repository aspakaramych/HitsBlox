import 'dart:ui';

import 'package:app/core/nodes/AddNode.dart';
import 'package:app/core/nodes/ConcatNode.dart';
import 'package:app/core/nodes/DivideNode.dart';
import 'package:app/core/nodes/EqualsNode.dart';
import 'package:app/core/nodes/IfElseNode.dart';
import 'package:app/core/nodes/LessNode.dart';
import 'package:app/core/nodes/MoreNode.dart';
import 'package:app/core/nodes/MultiplyNode.dart';
import 'package:app/core/nodes/PrintNode.dart';
import 'package:app/core/nodes/StartNode.dart';
import 'package:app/core/nodes/SubNode.dart';

import 'BoolAssignNode.dart';
import 'IntAssignNode.dart';
import 'StringAssignNode.dart';

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
    }
  }
}