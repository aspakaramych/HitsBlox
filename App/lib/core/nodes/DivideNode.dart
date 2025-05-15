import 'dart:ui';

import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/pins/Pin.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class DivideNode extends Node {
  @override
  final List<Pin> inputs = [];

  @override
  final List<Pin> outputs = [];

  @override
  final String id;

  @override
  String get title => "Деление";

  DivideNode(String this.id, Offset position) : super(position) {}

  void addInput(Pin pin) => inputs.add(pin);

  void addOutput(Pin pin) => outputs.add(pin);

  @override
  Future<void> execute(VariableRegistry registry) async {
    var aPin = inputs[0];
    var bPin = inputs[1];
    var resultPin = outputs[0];
    int aVal, bVal;
    if (aPin != null && bPin != null && resultPin != null) {
      if (aPin.getValue() is int) {
        aVal = aPin.getValue();
      } else {
        aVal = registry.getValue(aPin.getValue());
      }
      if (bPin.getValue() is int) {
        bVal = bPin.getValue();
      } else {
        bVal = registry.getValue(bPin.getValue());
      }

      if (aVal == null || bVal == null) return;
      if (bVal == 0) {
        throw Exception("NullDivideError");
      }

      int sum = aVal ~/ bVal;
      resultPin.setValue(sum);
    }
  }

  bool areAllInputsReady() {
    for (var p in inputs) {
      if (p != null && !p.hasValue()) {
        return false;
      }
    }
    return true;
  }
}
