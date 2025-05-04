import 'dart:ui';

import 'package:app/core/ConsoleService.dart';
import 'package:app/core/Pins/Pin.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:flutter/material.dart';

class PrintNode extends Node {
  final TextEditingController controller = TextEditingController();
  String inputVarName = 'value';

  final List<Pin> _inputs = [];
  final List<Pin> _outputs = [];

  @override
  List<Pin> get inputs => _inputs;
  @override
  List<Pin> get outputs => _outputs;

  @override
  final String id;
  @override
  String get title => "Вывести";

  PrintNode(String this.id, Offset position) : super(position) {
    controller.text = 'value';
    addInput(Pin(id: 'exec_in', name: 'Exec In', isInput: true));
    addInput(Pin(id: 'value', name: 'Value', isInput: true));
    addOutput(Pin(id: 'exec_out', name: 'Exec Out', isInput: false));
  }

  void addInput(Pin pin) => _inputs.add(pin);
  void addOutput(Pin pin) => _outputs.add(pin);

  @override
  Future<void> execute(VariableRegistry registry) async {
    inputVarName = controller.text.trim();

    var value = registry.getValue(inputVarName);
    ConsoleService().log("$inputVarName = $value");
  }
}