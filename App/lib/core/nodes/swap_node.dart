import 'dart:ui';

import 'package:app/core/abstracts/expression.dart';
import 'package:app/core/abstracts/node.dart';
import 'package:app/core/literals/bool_literal.dart';
import 'package:app/core/literals/int_literal.dart';
import 'package:app/core/literals/string_literal.dart';
import 'package:app/core/literals/variable_literal.dart';
import 'package:app/core/models/commands/swap_command.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/utils/offset_extension.dart';
import 'package:flutter/cupertino.dart';

import '../pins/Pin.dart';

class SwapNode extends Node {
  String rawExpressionFirst = '';
  String rawExpressionSecond = '';

  final TextEditingController controller = TextEditingController();

  @override
  final String id;

  @override
  String get title => "Swap";

  SwapNode(String this.id, Offset position) : super(position) {}

  List<String> setAssignmentsFromText(String text) {
    var line = text.trim();
    var match = RegExp(
      r'^([a-zA-Z_]\w*)\[([^\]]+)\]$',
    ).firstMatch(line);
    if (match == null) return [];
    var varName = match.group(1)!;
    var idxMatch = match.group(2)!;
    return [varName, idxMatch];
  }

  @override
  Future<void> execute(VariableRegistry registry) async {
    List<String> first = setAssignmentsFromText(rawExpressionFirst);
    List<String> second = setAssignmentsFromText(rawExpressionSecond);
    var val1 = registry.getValue(first[1]) is int
        ? registry.getValue(first[1])
        : int.tryParse(first[1]);
    var val2 = registry.getValue(second[1]) is int
        ? registry.getValue(second[1])
        : int.tryParse(second[1]);
    var command = SwapCommand(
      first[0],
      val1,
      second[0],
      val2,
    );
    command.execute(registry);
  }

  static Map<String, dynamic> toJson_(SwapNode node) {
    return {
      'id': node.id,
      'position': node.position.toJson(),
      'title': node.title,
      'rawExpressionFirst': node.rawExpressionFirst,
      'rawExpressionSecond': node.rawExpressionSecond,
      'inputs': node.inputs.map(pinToJson).toList(),
      'outputs': node.outputs.map(pinToJson).toList(),
    };
  }

  factory SwapNode.fromJson(Map<String, dynamic> json) {
    final node = SwapNode(
      json['id'],
      OffsetExtension.fromJson(json['position']),
    );

    final inputPins =
        (json['inputs'] as List).map((p) => pinFromJson(p)).toList();
    final outputPins =
        (json['outputs'] as List).map((p) => pinFromJson(p)).toList();

    node.inputs = inputPins;
    node.outputs = outputPins;
    node.rawExpressionFirst = json['rawExpressionFirst'];
    node.rawExpressionSecond = json['rawExpressionSecond'];

    return node;
  }
}
