import 'dart:ui';

import 'package:app/core/abstracts/command.dart';
import 'package:app/core/abstracts/expression.dart';
import 'package:app/core/abstracts/node.dart';
import 'package:app/core/literals/bool_literal.dart';
import 'package:app/core/literals/int_literal.dart';
import 'package:app/core/literals/string_literal.dart';
import 'package:app/core/literals/variable_literal.dart';
import 'package:app/core/models/commands/array_set_command.dart';
import 'package:app/core/nodes/assign_node.dart';
import 'package:app/core/pins/Pin.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

class ArrayAddNode extends Node implements AssignNode{
  final List<Command> commands = [];

  @override
  String rawExpression = '';
  final TextEditingController controller = TextEditingController();

  @override
  final String id;

  @override
  String get title => "Добавить (array)";

  ArrayAddNode(String this.id, Offset position) : super(position) {}

  @override
    void setAssignmentsFromText(String text, VariableRegistry registry) {
      rawExpression = text;
      commands.clear();

      var lines = text.split(';');
      for (var line in lines) {
        var trimmedLine = line.trim();
        if (trimmedLine.isEmpty) continue;

        final match = RegExp(r'^\s*(.+?)\s*=\s*(.*?)\s*$').firstMatch(trimmedLine);
        if (match == null) continue;

        var targetStr = match.group(1)!.trim();
        var valueStr = match.group(2)!.trim();


        final arrayMatch = RegExp(r'^\s*(\w+)\s*(\[\d+\])\s*$').firstMatch(targetStr);
        if (arrayMatch == null) continue;

        var arrayName = arrayMatch.group(1)!;
        var index = int.parse(arrayMatch.group(2)!.substring(1, arrayMatch.group(2)!.length - 1));

        commands.add(ArraySetCommand(
          arrayName: arrayName,
          index: index,
          valueExpression: parseValue(valueStr),
        ));
      }

  }

  Expression parseValue(String exprStr) {
    exprStr = exprStr.trim();

    if (exprStr.startsWith('"') && exprStr.endsWith('"')) {
      return StringLiteral(exprStr.substring(1, exprStr.length - 1));
    } else if (int.tryParse(exprStr) != null) {
      return IntLiteral(int.parse(exprStr));
    } else if(exprStr == 'true' || exprStr == 'false'){
      return BoolLiteral(exprStr == 'true');
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