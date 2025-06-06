import 'dart:ui';

import 'package:app/core/pins/pin.dart';
import 'package:app/core/abstracts/node.dart';
import 'package:app/core/models/commands/assign_variable_command.dart';
import 'package:app/core/models/commands/concat_command.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:collection/collection.dart';
import '../abstracts/command.dart';
import '../literals/variable_literal.dart';
import '../pins/empty_pin.dart';

class ConcatNode extends Node {
  @override
  final String id;

  @override
  String get title => "Конкатенация";

  ConcatNode(String this.id, Offset position) : super(position) {
    inputs.add(EmptyPin());
    inputs.add(EmptyPin());
  }

  @override
  Future<void> execute(VariableRegistry registry) async {
    clearOutputs();
    var aPin = inputs[0];
    var bPin = inputs[1];
    var resultPin = outputs[0];
    String aVal, bVal;

    if (aPin != null && bPin != null && resultPin != null) {
      if (registry.getValue(aPin.getValue()) != null) {
        aVal = registry.getValue(aPin.getValue());
      } else {
        aVal = aPin.getValue();
      }

      if (registry.getValue(bPin.getValue()) != null) {
        bVal = registry.getValue(bPin.getValue());
      } else {
        bVal = bPin.getValue();
      }

      String sum = aVal + bVal;
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

  void clearOutputs() {
    for (var p in outputs) {
      p.setValue(null);
    }
    ;
  }
}
