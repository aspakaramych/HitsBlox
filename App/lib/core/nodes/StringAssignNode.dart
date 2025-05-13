import 'package:app/core/Pins/Pin.dart';
import 'package:app/core/abstracts/Command.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/literals/StringLiteral.dart';
import 'package:app/core/nodes/AssignNode.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:flutter/material.dart';

import '../abstracts/Expression.dart';
import '../literals/VariableLiteral.dart';
import '../models/commands/AssignVariableCommand.dart';

class StringAssignNode extends Node implements AssignNode{
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
  String get title => "Присвоить";

  StringAssignNode(String this.id, Offset position) : super(position) {
    addInput(Pin<String>(id: 'exec_in', name: 'Exec In', isInput: true));
    addOutput(Pin<String>(id: 'exec_out', name: 'Exec Out', isInput: false));
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
      commands.add(AssignVariableCommand<String>(variableName, expression));


      var pin = Pin<String>(id: "value", name: variableName, isInput: false);
      pin.setValue(variableName);
      addOutput(pin);
    }
  }

  Expression parseExpression(String exprStr) {

    exprStr = exprStr.trim();
    if (exprStr.startsWith('"') && exprStr.endsWith('"')) {
      return StringLiteral(exprStr.substring(1, exprStr.length - 1));
    }
    return VariableLiteral(exprStr);
  }
  @override
  void addInput(Pin pin) => _inputs.add(pin);
  @override
  void addOutput(Pin pin) => _outputs.add(pin);

  @override
  Future<void> execute(VariableRegistry registry) async {
    setAssignmentsFromText(rawExpression);
    for (var cmd in commands) {
      await cmd.execute(registry);
    }
  }

  @override
  void setText(String text) => rawExpression = text;
}