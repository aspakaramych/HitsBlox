import 'dart:ui';

import 'package:app/core/pins/Pin.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/models/BinaryOperations.dart';
import 'package:app/core/models/commands/AssignVariableCommand.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:collection/collection.dart';
import '../abstracts/Command.dart';
import '../literals/VariableLiteral.dart';

class SubNode extends Node{
  final List<Command> commands = [];
  final List<Pin> _inputs = [];
  final List<Pin> _outputs = [];

  final String leftVarName;
  final String rightVarName;
  final String resultVarName;

  @override
  List<Pin> get inputs => _inputs;

  @override
  List<Pin> get outputs => _outputs;

  @override
  final String id;

  @override
  String get title => "Вычитание";

  SubNode(String this.id, Offset position)
      : leftVarName = 'a',
        rightVarName = 'b',
        resultVarName = 'result',
        super(position) {
    addInput(Pin(id: 'exec_in', name: 'Exec In', isInput: true));
    addOutput(Pin(id: 'exec_out', name: 'Exec Out', isInput: false));

    addInput(Pin<int>(id: leftVarName, name: 'A', isInput: true));
    addInput(Pin<int>(id: rightVarName, name: 'B', isInput: true));
    addOutput(Pin<int>(id: resultVarName, name: 'Result', isInput: false));
  }

  void addInput(Pin pin) => _inputs.add(pin);
  void addOutput(Pin pin) => _outputs.add(pin);

  @override
  Future<void> execute(VariableRegistry registry) async {
    var aPin = _inputs.firstWhereOrNull((p) => p.id == leftVarName);
    var bPin = _inputs.firstWhereOrNull((p) => p.id == rightVarName);
    var resultPin = _outputs.firstWhereOrNull((p) => p.id == resultVarName);

    if (aPin != null && bPin != null && resultPin != null) {
      var expression = BinaryOperations(
        VariableLiteral(leftVarName),
        VariableLiteral(rightVarName),
        '-',
      );

      var cmd = AssignVariableCommand<int>(resultVarName, expression);
      await cmd.execute(registry);

      resultPin.setValue(registry.getValue(resultVarName));
    }
  }
}