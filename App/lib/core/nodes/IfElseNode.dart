import 'dart:ui';

import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class IfElseNode extends Node {
  @override
  final String id;
  @override
  String get title => "Условие";

  IfElseNode(String this.id, Offset position) : super(position) {
  }

  @override
  Future<void> execute(VariableRegistry registry) {
    // TODO: implement execute
    throw UnimplementedError();
  }
}