import 'dart:ui';

import 'package:app/core/abstracts/Expression.dart';
import 'package:app/core/abstracts/MyTrue.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/literals/GetArrayValue.dart';
import 'package:app/core/literals/IntLiteral.dart';
import 'package:app/core/literals/VariableLiteral.dart';
import 'package:app/core/pins/Pin.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:flutter/cupertino.dart';

class WhileNode extends Node {
  @override
  final String id;

  @override
  String get title => "Цикл while";
  @override
  String rawExpression = '';
  final TextEditingController controller = TextEditingController();

  WhileNode(String this.id, Offset position) : super(position) {}

  (String, String, String) setAssignmentsFromText(String text) {
    rawExpression = text;

    var lines = text.split(';');
    for (var line in lines) {
      var trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      var match = RegExp(
        r'^\s*([a-zA-Z_]\w*(?:$\s*[^\$$]+\s*$)?)\s*([=<>!]=?|>=|<=|!=)\s*([a-zA-Z_]\w*(?:$\s*[^\$$]+\s*$)?|[-+]?\d+|"(.*?)"|true|false)\s*$',
      ).firstMatch(trimmedLine);
      if (match == null) continue;

      var leftExpr = match.group(1)!;
      var operator = match.group(2)!;
      var rightExpr = match.group(3)!;
      return (leftExpr, operator, rightExpr);

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
  Future<void> execute(VariableRegistry registry) async {
    clearOutputs();
    var leftExpr, operator, rightExpr = parseExpression(rawExpression);
    var expressionLeft = parseExpression(leftExpr);
    var expressionRight = parseExpression(rightExpr);
    if (operator != "==" || operator != ">" || operator != "<" || operator != "!="){
      throw Exception("неизвестный оператор в while");
    }
    switch (operator){
      case "==":
        if (expressionLeft.evaluate(registry) == expressionRight.evaluate(registry)){
          outputs[0].setValue(MyTrue());
          return;
        }
      case ">":
        if (expressionLeft.evaluate(registry) > expressionRight.evaluate(registry)){
          outputs[0].setValue(MyTrue());
          return;
        }
      case "<":
        if (expressionLeft.evaluate(registry) < expressionRight.evaluate(registry)){
          outputs[0].setValue(MyTrue());
          return;
        }
      case "!=":
        if (expressionLeft.evaluate(registry) != expressionRight.evaluate(registry)){
          outputs[0].setValue(MyTrue());
          return;
        }
    }
    outputs[1].setValue(MyTrue());
  }

  void addInput(Pin pin) => inputs.add(pin);

  void addOutput(Pin pin) => outputs.add(pin);

  String strToRaw(String x) => '\r$x';

  void setText(String text) => rawExpression = strToRaw(text);

  void clearOutputs() {
    for (var p in outputs) {
      p.setValue(null);
    }
    ;
  }
}
