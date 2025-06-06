import 'package:app/utils/offset_extension.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../console_service.dart';
import 'package:app/core/pins/pin.dart';
import '../abstracts/node.dart';
import '../registry/VariableRegistry.dart';

class PrintNode extends Node {
  final TextEditingController controller = TextEditingController();
  String rawExpression = '';

  final ConsoleService consoleService;

  @override
  final String id;

  @override
  String get title => "Распечатать";

  PrintNode({
    required this.consoleService,
    required String this.id,
    required Offset position,
  }) : super(position) {}

  String parseInput(String text, VariableRegistry registry) {
    var result = text;
    if (result == "") {
      return "";
    }
    final regex = RegExp(r'\{(\w+)\}');

    final matches = regex.allMatches(text);
    for (var match in matches) {
      var variableName = match.group(1)!;
      var value = registry.getValue(variableName)?.toString() ?? '?';
      result = result.replaceAll('{${variableName}}', value);
    }

    return result;
  }

  @override
  Future<void> execute(VariableRegistry registry) async {
    clearOutputs();
    var parsedText = parseInput(rawExpression, registry);
    if (parsedText == "" && inputs[0].value != null) {
      consoleService.log(inputs[0].value.toString());
      return;
    }
    consoleService.log(parsedText);
  }

  bool areAllInputsReady() {
    final execIn =
        inputs.firstWhereOrNull((p) => p.id.contains('exec_in')) as Pin?;

    if (execIn == null) {
      return false;
    }

    return true;
  }

  static Map<String, dynamic> toJson_(PrintNode node) {
    return {
      'id': node.id,
      'position': node.position.toJson(),
      'title': node.title,
      'rawExpression': node.rawExpression,
      'inputs': node.inputs.map(pinToJson).toList(),
      'outputs': node.outputs.map(pinToJson).toList(),
    };
  }

  factory PrintNode.fromJson(
    Map<String, dynamic> json,
    ConsoleService consoleService,
  ) {
    final node = PrintNode(
      consoleService: consoleService,
      id: json['id'],
      position: OffsetExtension.fromJson(json['position']),
    );
    final inputPins =
        (json['inputs'] as List).map((p) => pinFromJson(p)).toList();
    final outputPins =
        (json['outputs'] as List).map((p) => pinFromJson(p)).toList();

    node.inputs = inputPins;
    node.outputs = outputPins;
    node.rawExpression = json['rawExpression'];

    return node;
  }

  void clearOutputs() {
    for (var p in outputs) {
      p.setValue(null);
    }
    ;
  }
}
