import 'dart:ui';

import 'package:app/core/abstracts/expression.dart';
import 'package:app/core/abstracts/my_true.dart';
import 'package:app/core/abstracts/node.dart';
import 'package:app/core/literals/get_array_value.dart';
import 'package:app/core/literals/int_literal.dart';
import 'package:app/core/literals/variable_literal.dart';
import 'package:app/core/pins/pin.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/offset_extension.dart';

class WhileNode extends Node {
  @override
  final String id;

  @override
  String get title => "Цикл while";
  @override
  String rawExpression = '';
  final TextEditingController controller = TextEditingController();

  WhileNode(String this.id, Offset position) : super(position) {}

  List<String> setAssignmentsFromText(String text) {
    rawExpression = text;

    var line = text;

    var trimmedLine = line.trim();
    if (trimmedLine.isEmpty) return [];
    if (trimmedLine[trimmedLine.length - 1] == ';') {
      trimmedLine = trimmedLine.substring(0, trimmedLine.length - 1);
    }
    var match = RegExp(
      r'^\s*([a-zA-Z_]\w*(?:$\s*[^\$$]+\s*$)?)\s*([=<>!]=?|>=|<=|!=)\s*([a-zA-Z_]\w*(?:$\s*[^\$$]+\s*$)?|[-+]?\d+|"(.*?)"|true|false)\s*$',
    ).firstMatch(trimmedLine);
    if (match == null) return [];

    var leftExpr = match.group(1)!;
    var operator = match.group(2)!;
    var rightExpr = match.group(3)!;
    return [leftExpr, operator, rightExpr];
  }

  Expression parseExpression(String exprStr, VariableRegistry registry) {
    exprStr = exprStr.trim();

    if (int.tryParse(exprStr) != null) {
      return IntLiteral(int.parse(exprStr));
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
    var express = setAssignmentsFromText(rawExpression);
    if (express == []) {
      throw Exception("Ввели пустое условие");
    }
    var leftExpr = express[0];
    var operator = express[1];
    var rightExpr = express[2];
    var expressionLeft = parseExpression(leftExpr, registry);
    var expressionRight = parseExpression(rightExpr, registry);
    if (operator == "==" ||
        operator == ">" ||
        operator == "<" ||
        operator == "!=") {
      switch (operator) {
        case "==":
          if (expressionLeft.evaluate(registry) ==
              expressionRight.evaluate(registry)) {
            outputs[0].setValue(MyTrue());
            return;
          }
        case ">":
          if (expressionLeft.evaluate(registry) >
              expressionRight.evaluate(registry)) {
            outputs[0].setValue(MyTrue());
            return;
          }
        case "<":
          if (expressionLeft.evaluate(registry) <
              expressionRight.evaluate(registry)) {
            outputs[0].setValue(MyTrue());
            return;
          }
        case "!=":
          if (expressionLeft.evaluate(registry) !=
              expressionRight.evaluate(registry)) {
            outputs[0].setValue(MyTrue());
            return;
          }
      }
      outputs[1].setValue(MyTrue());
      return;
    }
    throw Exception("неизвестный оператор в while");
  }

  String strToRaw(String x) => '\r$x';

  void setText(String text) => rawExpression = strToRaw(text);

  void clearOutputs() {
    for (var p in outputs) {
      p.setValue(null);
    }
    ;
  }

  static Map<String, dynamic> toJson_(WhileNode node) {
    return {
      'id': node.id,
      'position': node.position.toJson(),
      'title': node.title,
      'rawExpression': node.rawExpression,
      'inputs': node.inputs.map(pinToJson).toList(),
      'outputs': node.outputs.map(pinToJson).toList(),
    };
  }

  factory WhileNode.fromJson(Map<String, dynamic> json) {
    final node = WhileNode(
      json['id'],
      OffsetExtension.fromJson(json['position']),
    );

    final inputPins =
        (json['inputs'] as List).map((p) => pinFromJson(p)).toList();
    final outputPins =
        (json['outputs'] as List).map((p) => pinFromJson(p)).toList();
    final rawExpression = json['rawExpression'];

    node.inputs = inputPins;
    node.outputs = outputPins;
    node.rawExpression = rawExpression;

    return node;
  }
}
