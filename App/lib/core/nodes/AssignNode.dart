import 'package:app/core/Pins/Pin.dart';
import 'package:app/core/abstracts/Command.dart';
import 'package:app/core/abstracts/Expression.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/literals/BoolLiteral.dart';
import 'package:app/core/literals/IntLiteral.dart';
import 'package:app/core/literals/VariableLiteral.dart';
import 'package:app/core/models/BinaryOperations.dart';
import 'package:app/core/models/commands/AssignVariableCommand.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:collection/collection.dart';
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
      var trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      var match = RegExp(r'^(\w+)\s+(\w+)\s*=\s*(.+)$').firstMatch(trimmedLine);
      if (match == null) continue;

      var type = match.group(1);
      var variableName = match.group(2)!;
      var exprStr = match.group(3)!;

      Expression expression = parseExpression(exprStr);
      dynamic value;
      switch (type) {
        case 'int':
          commands.add(AssignVariableCommand<int>(variableName, expression));
          value = (expression as IntLiteral).value;
          break;
        case 'bool':
          commands.add(AssignVariableCommand<bool>(variableName, expression));
          value = (expression as BoolLiteral).value;
          break;
        default:
          commands.add(AssignVariableCommand<dynamic>(variableName, expression));
      }
      var pin = Pin(id: variableName, name: variableName, isInput: false);
      pin.setValue(value);
      addOutput(pin);
    }
  }

  Expression parseExpression(String exprStr) {
    exprStr = exprStr.trim();

    if (exprStr == 'true' || exprStr == 'false') {
      return BoolLiteral(exprStr == 'true');
    } else if (RegExp(r'^\d+$').hasMatch(exprStr)) {
      return IntLiteral(int.parse(exprStr));
    } else if (RegExp(r'^[a-zA-Z_]\w*$').hasMatch(exprStr)) {
      return VariableLiteral(exprStr);
    } else if (exprStr.contains(' ')) {
      var tokens = exprStr.split(' ');
      if (tokens.length == 3 && ['+', '-', '*', '/'].contains(tokens[1])) {
        return BinaryOperations(
          parseExpression(tokens[0]),
          parseExpression(tokens[2]),
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
