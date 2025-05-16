import 'dart:ui';

import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/pins/Pin.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class EqualsNode extends Node{
  @override
  final String id;
  @override
  String get title => "Эквивалентность";

  EqualsNode(String this.id, Offset position) : super(position){

  }

  @override
  Future<void> execute(VariableRegistry registry) async {
    var aPin = inputs[0];
    var bPin = inputs[1];
    var resultPin = outputs[0];
    dynamic aVal, bVal;
    if (aPin != null && bPin != null && resultPin != null) {
      try{
        aVal = registry.getValue(aPin.getValue());
      }
      catch (e){
        aVal = aPin.getValue();
      }

      try{
        bVal = registry.getValue(bPin.getValue());
      }
      catch(e){
        bVal = bPin.getValue();
      }


      if (aVal == null || bVal == null) return;

      bool znac = aVal == bVal;
      resultPin.setValue(znac);
    }
  }


  @override
  final List<Pin> inputs = [];

  @override
  final List<Pin> outputs = [];

  void addInput(Pin pin) => inputs.add(pin);
  void addOutput(Pin pin) => outputs.add(pin);

}