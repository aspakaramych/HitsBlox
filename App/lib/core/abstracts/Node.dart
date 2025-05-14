
import 'dart:ui';

import 'package:app/core/pins/Pin.dart';
import 'package:app/core/registry/VariableRegistry.dart';

abstract class Node {
  String get id;
  List<Pin> inputs = [];
  List<Pin> outputs = [];

  Offset position;

  String get title;

  Node(this.position);

  Future<void> execute(VariableRegistry registry);
  bool areAllInputsReady() {
    return inputs.every((pin) =>
    !pin.isInput || pin.isExecutionPin || !pin.isRequired || pin.getValue() != null);
  }
  void addInput(Pin pin) => inputs.add(pin);
  void addOutput(Pin pin) => outputs.add(pin);
}