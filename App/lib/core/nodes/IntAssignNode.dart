import 'package:app/core/Pins/Pin.dart';
import 'package:app/core/abstracts/Command.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:flutter/material.dart';

import '../abstracts/Expression.dart';
import '../literals/IntLiteral.dart';
import '../literals/VariableLiteral.dart';
import '../models/BinaryOperations.dart';
import '../models/commands/AssignVariableCommand.dart';

class IntAssignNode extends Node {
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

  IntAssignNode(String this.id, Offset position) : super(position) {
    addInput(Pin<int>(id: 'exec_in', name: 'Exec In', isInput: true));
    addOutput(Pin<int>(id: 'exec_out', name: 'Exec Out', isInput: false));
  }

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
      commands.add(AssignVariableCommand<int>(variableName, expression));


      var pin = Pin<int>(id: variableName, name: variableName, isInput: false);
      addOutput(pin);
    }
  }

  Expression parseExpression(String exprStr) {
    exprStr = exprStr.trim();

    if (RegExp(r'^\d+$').hasMatch(exprStr)) {
      return IntLiteral(int.parse(exprStr));
    } else if (exprStr.contains(' ')) {
      var tokens = exprStr.split(' ');
      if (tokens.length == 3 && ['+', '-', '*', '/'].contains(tokens[1])) {
        var left = tokens[0];
        var right = tokens[2];

        return BinaryOperations(
          parseExpression(left),
          parseExpression(right),
          tokens[1],
        );
      }
    } else {
      return VariableLiteral(exprStr);
    }

    throw Exception("Неизвестное выражение: $exprStr");
  }

  void addInput(Pin<int> pin) => _inputs.add(pin);

  void addOutput(Pin<int> pin) => _outputs.add(pin);

  @override
  Future<void> execute(VariableRegistry registry) async {
    for (var cmd in commands) {
      await cmd.execute(registry);
    }

    for (var pin in _outputs.where((p) => !p.isInput)) {
      final value = registry.getValue(pin.id);
      if (value is int?) {
        pin.setValue(value);
      }
    }
  }
}