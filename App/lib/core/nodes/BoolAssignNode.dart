import 'package:app/core/nodes/AssignNode.dart';
import 'package:flutter/cupertino.dart';

import '../Pins/Pin.dart';
import '../abstracts/Command.dart';
import '../abstracts/Expression.dart';
import '../abstracts/Node.dart';
import '../literals/BoolLiteral.dart';
import '../literals/IntLiteral.dart';
import '../literals/VariableLiteral.dart';
import '../models/BinaryOperations.dart';
import '../models/commands/AssignVariableCommand.dart';
import '../registry/VariableRegistry.dart';

class BoolAssignNode extends Node implements AssignNode{
  final List<Command> commands = [];

  final List<Pin> _inputs = [];
  final List<Pin> _outputs = [];

  @override
  String rawExpression = '';
  final TextEditingController controller = TextEditingController();

  @override
  List<Pin> get inputs => _inputs;

  @override
  List<Pin> get outputs => _outputs;

  @override
  final String id;

  @override
  String get title => "Присвоить (bool)";

  BoolAssignNode(String this.id, Offset position) : super(position) {
    addInput(Pin(id: 'exec_in', name: 'Exec In', isInput: true));
    addOutput(Pin(id: 'exec_out', name: 'Exec Out', isInput: false));
  }

  @override
  void setAssignmentsFromText(String text) {
    rawExpression = text;
    commands.clear();
    outputs.removeWhere((p) => p.id != 'exec_out');

    var lines = text.split(';');
    for (var line in lines) {
      var trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      var match = RegExp(r'^(\w+)\s*=\s*(.+)$').firstMatch(trimmedLine);
      if (match == null) continue;

      var variableName = match.group(1)!;
      var exprStr = match.group(2)!;

      Expression expression = parseExpression(exprStr);

      commands.add(AssignVariableCommand<bool>(variableName, expression));
      bool value = false;
      if (expression is BoolLiteral) {
        value = expression.value;
      }

      var pin = Pin<bool>(id: variableName, name: variableName, isInput: false);
      pin.setValue(value);
      addOutput(pin);
    }
  }

  Expression parseExpression(String exprStr) {
    exprStr = exprStr.trim();

    if (exprStr == 'true' || exprStr == 'false') {
      return BoolLiteral(exprStr == 'true');
    } else if (exprStr.contains(' ')) {
      var tokens = exprStr.split(' ');
      if (tokens.length == 3 && ['==', '!=', '>', '<'].contains(tokens[1])) {
        var left = tokens[0];
        var right = tokens[2];

        return BinaryOperations(
          RegExp(r'^\d+$').hasMatch(left)
              ? IntLiteral(int.parse(left))
              : VariableLiteral(left),
          RegExp(r'^\d+$').hasMatch(right)
              ? IntLiteral(int.parse(right))
              : VariableLiteral(right),
          tokens[1],
        );
      }
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