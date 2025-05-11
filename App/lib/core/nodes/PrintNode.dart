import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../ConsoleService.dart';
import '../Pins/Pin.dart';
import '../abstracts/Node.dart';
import '../registry/VariableRegistry.dart';

class PrintNode extends Node {
  Pin? get valuePin => inputs.firstWhereOrNull((p) => p.id == 'value');

  @override
  final List<Pin> inputs = [];
  @override
  final List<Pin> outputs = [];

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
    addInput(Pin(id: 'value', name: 'Value', isInput: true));
    addOutput(Pin(id: 'exec_out', name: 'Exec Out', isInput: false));
  }

  void addInput(Pin pin) => inputs.add(pin);

  void addOutput(Pin pin) => outputs.add(pin);

  @override
  Future<void> execute(VariableRegistry registry) async {
    var valuePin = inputs.firstWhereOrNull((p) => p.id == 'value');
    if (valuePin != null && valuePin.getValue() != null) {
      consoleService.log("${valuePin.name} = ${valuePin.getValue()}");
    }
  }
}
