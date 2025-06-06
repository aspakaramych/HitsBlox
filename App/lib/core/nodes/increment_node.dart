import 'dart:ui';

import 'package:app/core/abstracts/command.dart';
import 'package:app/core/abstracts/expression.dart';
import 'package:app/core/abstracts/node.dart';
import 'package:app/core/models/commands/assign_variable_command.dart';
import 'package:app/core/nodes/assign_node.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:flutter/cupertino.dart';

class IncrementNode extends Node implements AssignNode {
  final List<Command> commands = [];

  @override
  String rawExpression = '';
  final TextEditingController controller = TextEditingController();

  @override
  final String id;

  @override
  String get title => "Инкремент";

  IncrementNode(this.id, Offset position) : super(position) {}

  @override
  List<String> setAssignmentsFromText(String text, VariableRegistry registry) {
    rawExpression = text;
    commands.clear();

    var line = text;

    var trimmedLine = line.trim();
    if (trimmedLine.isEmpty) return [];
    if (trimmedLine[trimmedLine.length - 1] == ';') {
      trimmedLine = trimmedLine.substring(0, trimmedLine.length - 1);
    }
    var match = RegExp(r'^(\w+)(\+\+|--)$').firstMatch(trimmedLine);
    if (match == null) {
      return [];
    }

    var variableName = match.group(1)!;
    var exprStr = match.group(2)!;
    return [variableName, exprStr];
  }

  @override
  Future<void> execute(VariableRegistry registry) async {
    clearOutputs();
    var express = setAssignmentsFromText(rawExpression, registry);
    if (express == []) {
      throw Exception("Ввели пустой или нерпавильный инкремент");
    }
    var variableName = express[0];
    var exprStr = express[1];
    if (variableName != null && exprStr != null) {
      var val = registry.getValue(variableName);
      if (val is int) {
        switch (exprStr) {
          case "++":
            registry.setValue(variableName, val + 1);
            return;
          case "--":
            registry.setValue(variableName, val - 1);
            return;
        }
      }

      throw Exception("Нельзя сложить");
    }
  }

  @override
  void setText(String text) => rawExpression = text;
}
