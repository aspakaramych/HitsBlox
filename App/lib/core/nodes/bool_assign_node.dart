import 'dart:math';

import 'package:app/core/literals/get_array_value.dart';
import 'package:app/core/literals/variable_literal.dart';
import 'package:app/core/nodes/assign_node.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

import '../pins/pin.dart';
import '../abstracts/command.dart';
import '../abstracts/expression.dart';
import '../abstracts/node.dart';
import '../literals/bool_literal.dart';
import '../models/commands/assign_variable_command.dart';
import '../registry/VariableRegistry.dart';

class BoolAssignNode extends Node implements AssignNode {
  final List<Command> commands = [];

  @override
  String rawExpression = '';
  final TextEditingController controller = TextEditingController();

  @override
  final String id;

  @override
  String get title => "Присвоить (bool)";

  BoolAssignNode(String this.id, Offset position) : super(position) {}

  @override
  void setAssignmentsFromText(String text, VariableRegistry registry) {
    rawExpression = text;
    commands.clear();

    var lines = text.split(';');
    for (var line in lines) {
      var trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      var match = RegExp(r'^\s*(\w+)\s*=\s*(.+)\s*$').firstMatch(trimmedLine);
      if (match == null) continue;

      var variableName = match.group(1)!;
      var exprStr = match.group(2)!;

      Expression expression = parseExpression(exprStr, registry);

      commands.add(AssignVariableCommand<bool>(variableName, expression));
      for (var p in outputs) {
        p.setValue(variableName);
      }
    }
  }

  Expression parseExpression(String exprStr, VariableRegistry registry) {
    exprStr = exprStr.trim();

    if (exprStr == 'true' || exprStr == 'false') {
      return BoolLiteral(exprStr == 'true');
    } else if (exprStr.contains('[') && exprStr.contains(']')) {
      try {
        return GetArrayValue.parse(exprStr, registry);
      } on FormatException {
        return VariableLiteral(exprStr);
      }
    } else {
      return VariableLiteral(exprStr);
    }
  }

  @override
  Future<void> execute(VariableRegistry registry) async {
    clearOutputs();
    setAssignmentsFromText(rawExpression, registry);
    for (var cmd in commands) {
      await cmd.execute(registry);
    }
  }

  @override
  void setText(String text) => rawExpression = text;

  bool areAllInputsReady() {
    final execIn =
        inputs.firstWhereOrNull((p) => p.id.contains('exec_in')) as Pin?;

    if (execIn == null) {
      return false;
    }

    return true;
  }

  void clearOutputs() {
    for (var p in outputs) {
      p.setValue(null);
    }
    ;
  }
}
