import 'dart:ui';

import 'package:app/core/pins/EmptyPin.dart';
import 'package:app/core/pins/Pin.dart';
import 'package:app/core/abstracts/node.dart';
import 'package:app/core/models/binary_operations.dart';
import 'package:app/core/models/commands/assign_variable_command.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:collection/collection.dart';
import '../abstracts/command.dart';
import '../literals/variable_literal.dart';

class AddNode extends Node {
  @override
  final String id;
  @override
  String get title => "Сложение";

  AddNode(String this.id, Offset position) : super(position) {
    inputs.add(EmptyPin());
    inputs.add(EmptyPin());
  }


  @override
  Future<void> execute(VariableRegistry registry) async {
    clearOutputs();
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
  void clearOutputs(){
    for (var p in outputs){
      p.setValue(null);
    }
  }
}