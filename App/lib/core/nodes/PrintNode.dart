import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../ConsoleService.dart';
import '../Pins/Pin.dart';
import '../abstracts/Node.dart';
import '../registry/VariableRegistry.dart';

class PrintNode extends Node {
  String inputVarName = 'value';
  final TextEditingController controller = TextEditingController();
  String rawExpression = '';
  final List<Pin> _inputs = [];
  final List<Pin> _outputs = [];

  @override
  List<Pin> get inputs => _inputs;

  @override
  List<Pin> get outputs => _outputs;

  final ConsoleService consoleService;

  @override
  final String id;

  @override
  String get title => "Вывести";

  PrintNode({
    required this.consoleService,
    required String this.id,
    required Offset position,
  }) : super(position) {
    addInput(Pin(id: 'exec_in', name: 'Exec In', isInput: true));
    addInput(Pin(id: "value", name: "Value", isInput: true));
    addOutput(Pin(id: 'exec_out', name: 'Exec Out', isInput: false));
  }

  void addInput(Pin pin) => _inputs.add(pin);
  void addOutput(Pin pin) => _outputs.add(pin);

  String parseInput(String text, VariableRegistry registry) {
    var result = text;
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
    consoleService.log(parsedText);
  }
}
