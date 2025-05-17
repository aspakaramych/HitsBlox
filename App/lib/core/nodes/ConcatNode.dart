import 'dart:ui';

import 'package:app/core/pins/Pin.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/models/commands/AssignVariableCommand.dart';
import 'package:app/core/models/commands/ConcatCommand.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:collection/collection.dart';
import '../abstracts/Command.dart';
import '../literals/VariableLiteral.dart';

class ConcatNode extends Node {
  @override
  final String id;

  @override
  String get title => "Конкатенация";

  ConcatNode(String this.id, Offset position) : super(position) {}

  void addInput(Pin pin) => inputs.add(pin);

  void addOutput(Pin pin) => outputs.add(pin);

  @override
  Future<void> execute(VariableRegistry registry) async {
    var aPin = inputs[0];
    var bPin = inputs[1];
    var resultPin = outputs[0];
    String aVal, bVal;

    if (aPin != null && bPin != null && resultPin != null) {
      if (registry.getValue(aPin.getValue()) != null){
        aVal = registry.getValue(aPin.getValue());
      }
      else{
        aVal = aPin.getValue();
      }

      if (registry.getValue(bPin.getValue()) != null){
        bVal = registry.getValue(bPin.getValue());
      }
      else{
        bVal = bPin.getValue();
      }

      String sum = aVal + bVal;
      resultPin.setValue(sum);
    }
  }
  bool areAllInputsReady() {
    for (var p in inputs){
      if (p != null && !p.hasValue()) {
        return false;
      }
    }
    return true;
  }
}
