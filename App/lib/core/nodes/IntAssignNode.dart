import 'package:app/core/literals/GetArrayValue.dart';
import 'package:app/core/pins/Pin.dart';
import 'package:app/core/abstracts/Command.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/nodes/AssignNode.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../abstracts/Expression.dart';
import '../literals/IntLiteral.dart';
import '../literals/VariableLiteral.dart';
import '../models/commands/AssignVariableCommand.dart';

class IntAssignNode extends Node implements AssignNode{
  final List<Command> commands = [];

  @override
  String rawExpression = '';
  final TextEditingController controller = TextEditingController();



  @override
  final String id;

  @override
  String get title => "Присвоить (int)";

  IntAssignNode(String this.id, Offset position) : super(position) {

  }

  @override
  void setAssignmentsFromText(String text) {
    rawExpression = text;
    commands.clear();


    var lines = text.split(';');
    for (var line in lines) {
      var trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      var match = RegExp(r'^\s*(\w+)\s*=\s*([+-]?[\d\w$\[\]\s*[^\$$]*\s*$|$)\s*$').firstMatch(trimmedLine);
      if (match == null) continue;

      var variableName = match.group(1)!;
      var exprStr = match.group(2)!;

      Expression expression = parseExpression(exprStr);
      commands.add(AssignVariableCommand<int>(variableName, expression));


      for (var p in outputs){
        p.setValue(variableName);
      }
    }
  }

  Expression parseExpression(String exprStr) {
    exprStr = exprStr.trim();

    if (int.tryParse(exprStr) != null) {
      return IntLiteral(int.parse(exprStr));
    } else if (exprStr.contains('[') && exprStr.contains(']')) {
      try {
        return GetArrayValue.parse(exprStr);
      } on FormatException {
        return VariableLiteral(exprStr);
      }
    } else {
      return VariableLiteral(exprStr);
    }
  }


  @override
  void setText(String text) => rawExpression = text;

  @override
  Future<void> execute(VariableRegistry registry) async {
    clearOutputs();
    setAssignmentsFromText(rawExpression);
    for (var cmd in commands) {
      await cmd.execute(registry);
    }
  }
  bool areAllInputsReady() {
    final execIn = inputs.firstWhereOrNull((p) => p.id.contains('exec_in')) as Pin?;

    if (execIn == null) {
      return false;
    }

    return true;
  }
  void clearOutputs(){
    for (var p in outputs){
      p.setValue(null);
    };
  }
}