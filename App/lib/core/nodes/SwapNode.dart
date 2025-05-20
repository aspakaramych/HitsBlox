import 'dart:ui';

import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class SwapNode extends Node{

  SwapNode(this.id, Offset position) : super(position){

  }

  @override
  Future<void> execute(VariableRegistry registry) {
    // TODO: implement execute
    throw UnimplementedError();
  }

  @override
  final String id;

  @override
  // TODO: implement title
  String get title => throw UnimplementedError();

}