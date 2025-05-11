import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../ConsoleService.dart';
import '../Pins/Pin.dart';
import '../abstracts/Node.dart';
import '../registry/VariableRegistry.dart';

class PrintNode extends Node {
  String inputVarName = 'value';
  final TextEditingController controller = TextEditingController(text: 'value');

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
    addOutput(Pin(id: 'exec_out', name: 'Exec Out', isInput: false));
  }

  void addInput(Pin pin) => _inputs.add(pin);
  void addOutput(Pin pin) => _outputs.add(pin);

  @override
  Future<void> execute(VariableRegistry registry) async {
    var names = inputVarName.trim().split(", ");
    for (var name in names){
      var val = registry.getValue(name);
      if (val != null){
        consoleService.log("$inputVarName = $val");
      }
      else{
        throw Exception("$val is not exist");
      }
    }
  }
}
