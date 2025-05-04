
import 'dart:ui';

import 'package:app/core/Pins/Pin.dart';
import 'package:app/core/registry/VariableRegistry.dart';

abstract class Node {
  String get id;
  List<Pin> get inputs;
  List<Pin> get outputs;

  Offset position;

  String get title;

  Node(this.position);

  Future<void> execute(VariableRegistry registry);
}