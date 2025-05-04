import 'package:app/core/Pins/Pin.dart';
import 'package:app/core/abstracts/Command.dart';
import 'package:app/core/abstracts/Expression.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/literals/IntLiteral.dart';
import 'package:app/core/literals/VariableLiteral.dart';
import 'package:app/core/models/BinaryOperations.dart';
import 'package:app/core/models/commands/AssignVariableCommand.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:flutter/material.dart';

class AssignNode extends Node {
  final List<Command> commands = [];

  final List<Pin> _inputs = [];
  final List<Pin> _outputs = [];

  String rawExpression = '';
  final TextEditingController controller = TextEditingController();

  @override
  List<Pin> get inputs => _inputs;

  @override
  List<Pin> get outputs => _outputs;

  @override
  final String id;

  @override
  String get title => "Присвоить";

  AssignNode(String this.id, Offset position) : super(position) {
    addInput(Pin(id: 'exec_in', name: 'Exec In', isInput: true));
    addOutput(Pin(id: 'exec_out', name: 'Exec Out', isInput: false));
  }

  void setAssignmentsFromText(String text) {
    rawExpression = text;
    commands.clear();
    outputs.removeWhere((p) => p.id != 'exec_out');

    var lines = text.split(';');
    for (var line in lines) {
      if (line.trim().isEmpty) continue;

      var match = RegExp(r'(\w+)\s*=\s*(.+)').firstMatch(line);
      if (match == null) continue;

      var variableName = match.group(1)!;
      var exprStr = match.group(2)!;

      Expression expression = parseExpression(exprStr);
      commands.add(AssignVariableCommand<int>(variableName, expression));
      var pin = new Pin(id: variableName, name: variableName, isInput: false);
      pin.setValue((expression as IntLiteral).value); //TODO: Влад, я сделал страшную вещь
      addOutput(pin);
    }
  }

  Expression parseExpression(String exprStr) {
    var tokens = exprStr.split(' ');
    if (tokens.length == 1 && tokens[0].contains(RegExp(r'^\d+$'))) {
      return IntLiteral(int.parse(tokens[0]));
    } else if (tokens.length == 3 && tokens[1] == '+' || tokens[1] == '-') {
      var left = tokens[0];
      var right = tokens[2];

      return BinaryOperations(
        VariableLiteral(left),
        IntLiteral(int.parse(right)),
        tokens[1],
      );
    }

    throw Exception("Неизвестное выражение: $exprStr");
  }

  void addInput(Pin pin) => _inputs.add(pin);

  void addOutput(Pin pin) => _outputs.add(pin);

  @override
  Future<void> execute(VariableRegistry registry) async {
    for (var cmd in commands) {
      await cmd.execute(registry);
    }

    for (var pin in _outputs.where((p) => !p.isInput)) {
      pin.setValue(registry.getValue(pin.id));
    }
  }
}
