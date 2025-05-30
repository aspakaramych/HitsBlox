import 'dart:ui';

import '../abstracts/node.dart';
import '../pins/EmptyPin.dart';
import '../registry/VariableRegistry.dart';

class GreaterOrEqualNode extends Node{
  @override
  final String id;
  @override
  String get title => ">=";

  GreaterOrEqualNode(String this.id, Offset position) : super(position){
    inputs.add(EmptyPin());
    inputs.add(EmptyPin());
  }

  @override
  Future<void> execute(VariableRegistry registry) async {
    clearOutputs();
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
      if (aVal is int && bVal is int){
        bool znac = aVal >= bVal;
        resultPin.setValue(znac);
        return;
      }
    }
  }
}