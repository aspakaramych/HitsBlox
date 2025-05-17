import 'package:app/utils/offset_extension.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../ConsoleService.dart';
import 'package:app/core/pins/Pin.dart';
import '../abstracts/Node.dart';
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
  }) : super(position) {

  }
  @override
  void addInput(Pin pin) => inputs.add(pin);
  @override
  void addOutput(Pin pin) => outputs.add(pin);

  String parseInput(String text, VariableRegistry registry) {
    var result = text;
    if (result == ""){
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
    var parsedText = parseInput(rawExpression, registry);
    if (parsedText == "" && inputs[0].value != null){
      consoleService.log(inputs[0].value.toString());
      return;
    }
    consoleService.log(parsedText);
  }
  bool areAllInputsReady() {
    final execIn = inputs.firstWhereOrNull((p) => p.id.contains('exec_in')) as Pin?;

    if (execIn == null) {
      return false;
    }

    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position.toJson(),
      'title': title,
      'inputs': inputs.map(pinToJson).toList(),
      'outputs': outputs.map(pinToJson).toList(),
    };
  }

  factory PrintNode.fromJson(Map<String, dynamic> json, ConsoleService consoleService) {
    final node = PrintNode(consoleService: consoleService, id: json['title'], position: OffsetExtension.fromJson(json['position']));
    final inputPins = (json['inputs'] as List).map((p) => pinFromJson(p)).toList();
    final outputPins = (json['outputs'] as List).map((p) => pinFromJson(p)).toList();

    node.inputs = inputPins;
    node.outputs = outputPins;

    return node;
  }
}
