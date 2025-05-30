import 'dart:ui';

import 'package:app/core/abstracts/my_true.dart';
import 'package:app/core/abstracts/node.dart';
import 'package:app/core/pins/pin.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class IfElseNode extends Node {
  @override
  final String id;

  @override
  String get title => "Условие";

  IfElseNode(String this.id, Offset position) : super(position) {}

  @override
  Future<void> execute(VariableRegistry registry) async {
    clearOutputs();
    var flag = false;
    for (int i = 0; i < inputs.length; i++) {
      var pin = inputs[i];
      if (pin.getValue() is String) {
        var znac = registry.getValue(pin.getValue());
        if (znac == true && znac is bool) {
          if (!flag) {
            outputs[i].setValue(MyTrue());
            flag = true;
            continue;
          }
        }
        continue;
      }
      if (pin.getValue() == true && pin.getValue() is bool) {
        if (!flag) {
          flag = true;
          outputs[i].setValue(MyTrue());
        }
      } else if (pin.getValue() == false && pin.getValue() is bool) {
        continue;
      } else {
        throw Exception("Вы ввели не bool ");
      }
    }
    if (!flag) {
      this.outputs[outputs.length - 1].setValue(MyTrue());
    }
  }

  void clearOutputs() {
    for (var p in outputs) {
      p.setValue(null);
    }
    ;
  }
}
