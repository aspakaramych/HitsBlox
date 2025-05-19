import 'dart:ui';

import 'package:app/core/pins/Pin.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class StartNode extends Node {


  @override
  final String id;
  @override
  String get title => "Старт";

  StartNode(String this.id, Offset position) : super(position) {

  }


  @override
  bool areAllInputsReady() => true;

  @override
  Future<void> execute(VariableRegistry registry) async {

  }
}