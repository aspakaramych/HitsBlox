import 'dart:ui';

import 'package:app/core/pins/Pin.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/models/BinaryOperations.dart';
import 'package:app/core/models/commands/AssignVariableCommand.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:collection/collection.dart';
import '../abstracts/Command.dart';
import '../literals/VariableLiteral.dart';

class AddNode extends Node {
  final List<Pin> inputs= [];
  final List<Pin> outputs = [];

  @override
  final String id;
  @override
  String get title => "Сложение";

  AddNode(String this.id, Offset position) : super(position) {

  }

  @override
  void addInput(Pin pin) => inputs.add(pin);
  @override
  void addOutput(Pin pin) => outputs.add(pin);

  @override
  Future<void> execute(VariableRegistry registry) async {
    var aPin = inputs[0];
    var bPin = inputs[1];
    var resultPin = outputs[0];
    int aVal, bVal;
    if (aPin != null && bPin != null && resultPin != null) {
      if (aPin.getValue() is int){
        aVal = aPin.getValue();
      } else{
        aVal = registry.getValue(aPin.getValue());
      }
      if (bPin.getValue() is int){
        bVal = bPin.getValue();
      }
      else{
        bVal = registry.getValue(bPin.getValue());
      }


      if (aVal == null || bVal == null) return;

      int sum = aVal + bVal;
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