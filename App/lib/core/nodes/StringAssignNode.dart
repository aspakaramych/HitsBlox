import 'package:app/core/literals/GetArrayValue.dart';
import 'package:app/core/pins/Pin.dart';
import 'package:app/core/abstracts/Command.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/literals/StringLiteral.dart';
import 'package:app/core/nodes/AssignNode.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../abstracts/Expression.dart';
import '../literals/VariableLiteral.dart';
import '../models/commands/AssignVariableCommand.dart';

class StringAssignNode extends Node implements AssignNode{
  final List<Command> commands = [];
    @override
  String rawExpression = '';
  final TextEditingController controller = TextEditingController();

  @override
  final List<Pin> _inputs = [];

  @override
  final List<Pin> _outputs = [];

  @override
  final String id;

  @override
  String get title => "Присвоить (string)";

  StringAssignNode(String this.id, Offset position) : super(position) {

  }

  void setAssignmentsFromText(String text, VariableRegistry registry) {
    rawExpression = text;
    commands.clear();

    var lines = text.split(';');
    for (var line in lines) {
      var trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      var match = RegExp(r'^\s*(\w+)\s*=\s*(.*?)\s*$').firstMatch(trimmedLine);
      if (match == null) continue;

      var variableName = match.group(1)!;
      var exprStr = match.group(2)!;

      Expression expression = parseExpression(exprStr, registry);
      commands.add(AssignVariableCommand<String>(variableName, expression));
      for (var p in outputs){
        p.setValue(variableName);
      }
    }
  }

  Expression parseExpression(String exprStr, VariableRegistry registry) {

    exprStr = exprStr.trim();
    if (exprStr.startsWith('"') && exprStr.endsWith('"')) {
      return StringLiteral(exprStr.substring(1, exprStr.length - 1));
    }else if (exprStr.contains('[') && exprStr.contains(']')) {
      try {
        return GetArrayValue.parse(exprStr, registry);
      } on FormatException {
        return VariableLiteral(exprStr);
      }
    }
    return VariableLiteral(exprStr);
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
  bool areAllInputsReady() {
    final execIn = inputs.firstWhereOrNull((p) => p.id.contains('exec_in')) as Pin?;

    if (execIn == null) {
      return false;
    }

    return true;
  }
  @override
  void setText(String text) => rawExpression = text;
  void clearOutputs(){
    for (var p in outputs){
      p.setValue(null);
    };
  }
}