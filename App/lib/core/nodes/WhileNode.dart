import 'dart:ui';

import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class WhileNode extends Node{
  @override
  String id;

  WhileNode(String this.id, Offset position) : super(position){
  }

  @override
  Future<void> execute(VariableRegistry registry) {
    // TODO: implement execute
    throw UnimplementedError();
  }

  @override
  // TODO: implement title
  String get title => throw UnimplementedError();
  
}