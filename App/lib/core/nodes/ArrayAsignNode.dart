import 'package:app/core/abstracts/Command.dart';
import 'package:app/core/abstracts/Expression.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/literals/ArrayLiteral.dart';
import 'package:app/core/literals/BoolLiteral.dart';
import 'package:app/core/literals/IntLiteral.dart';
import 'package:app/core/literals/StringLiteral.dart';
import 'package:app/core/literals/VariableLiteral.dart';
import 'package:app/core/models/commands/AssignVariableCommand.dart';
import 'package:app/core/nodes/AssignNode.dart';
import 'package:app/core/pins/Pin.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

class ArrayAsignNode extends Node implements AssignNode {
  final List<Command> commands = [];

  @override
  String rawExpression = '';
  final TextEditingController controller = TextEditingController();


  @override
  final String id;

  @override
  String get title => "Присвоить (array)";

  ArrayAsignNode(String this.id, Offset position) : super(position) {}

  @override
  void setAssignmentsFromText(String text, VariableRegistry registry) {
    rawExpression = text;
    commands.clear();

    var lines = text.split(';');
    for (var line in lines) {
      var trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      var match = RegExp(r'^\s*(.+?)\s*=\s*(.*?)\s*$').firstMatch(trimmedLine);
      if (match == null) continue;

      var variableName = match.group(1)!;
      var exprStr = match.group(2)!;
      var type = parseVariable(variableName)[0];
      var variable = parseVariable(variableName)[1];
      Expression expression = parseExpression(exprStr, type);
      commands.add(AssignVariableCommand(variable, expression));

      for (var p in outputs) {
        p.setValue(variable);
      }
    }
  }

  List<String> parseVariable(String exprStr) {
    var newExpr = exprStr.split(' ');
    String type = newExpr[0].trim();
    String varName = newExpr[1].trim();
    return [type, varName];
  }

  Expression parseExpression(String exprStr, String type) {
    exprStr = exprStr.trim();

    if (exprStr.startsWith('{') && exprStr.endsWith('}')) {
      var inner = exprStr.substring(1, exprStr.length - 1).trim();
      var items = inner.split(',').map((s) => s.trim()).toList();
      var expressions =
          items.map((item) {
            if (RegExp(r'^(-)?\d+$').hasMatch(item)) {
              return IntLiteral(int.parse(item));
            } else if (item.startsWith('"') && item.endsWith('"')) {
              return StringLiteral(item.substring(1, item.length - 1));
            } else if (item == 'true' || item == 'false') {
              return BoolLiteral(item == 'true');
            } else {
              return VariableLiteral(item);
            }
          }).toList();
      switch (type) {
        case "int":
          return ArrayLiteral<int>(expressions);
        case "string":
          return ArrayLiteral<String>(expressions);
        case "bool":
          return ArrayLiteral<bool>(expressions);
      }
    }

    if (exprStr.startsWith('[') && exprStr.endsWith(']')) {
      var inner = exprStr.substring(1, exprStr.length - 1).trim();
      var nums = int.parse(inner);

      List<Expression> expressions = [];
      for (int i = 0; i < nums; i++) {
        switch (type) {
          case "int":
            expressions.add(IntLiteral(0));
          case "string":
            expressions.add(StringLiteral(""));
          case "bool":
            expressions.add(BoolLiteral(true));
        }
      }

      switch (type) {
        case "int":
          return ArrayLiteral<int>(expressions);
        case "string":
          return ArrayLiteral<String>(expressions);
        case "bool":
          return ArrayLiteral<bool>(expressions);
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

  String strToRaw(String x) => '\r$x';

  @override
  void setText(String text) => rawExpression = strToRaw(text);

  bool areAllInputsReady() {
    final execIn =
        inputs.firstWhereOrNull((p) => p.id.contains('exec_in')) as Pin?;

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
