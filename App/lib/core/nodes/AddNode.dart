import 'dart:ui';

import 'package:app/core/Pins/Pin.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/models/BinaryOperations.dart';
import 'package:app/core/models/commands/AssignVariableCommand.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:collection/collection.dart';
import '../abstracts/Command.dart';
import '../literals/VariableLiteral.dart';

class AddNode extends Node {

  final List<Pin> _inputs = [];
  final List<Pin> _outputs = [];

  @override
  List<Pin> get inputs => _inputs;
  @override
  List<Pin> get outputs => _outputs;

  @override
  final String id;
  @override
  String get title => "Сложение";

  AddNode(String this.id, Offset position) : super(position) {

  }

  @override
  void addInput(Pin pin) => _inputs.add(pin);
  @override
  void addOutput(Pin pin) => _outputs.add(pin);

  @override
  Future<void> execute(VariableRegistry registry) async {
    var aPin = _inputs[0];
    var bPin = _inputs[1];
    var resultPin = _outputs[0];
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