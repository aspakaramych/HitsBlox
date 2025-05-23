import 'dart:ui';

import 'package:app/core/Pins/Pin.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class StartNode extends Node {
  final List<Pin> _inputs = [];
  final List<Pin> _outputs = [];

  @override
  List<Pin> get inputs => _inputs;
  @override
  List<Pin> get outputs => _outputs;

  @override
  final String id;
  @override
  String get title => "Старт";

  StartNode(String this.id, Offset position) : super(position) {
    addOutput(Pin(id: 'exec_out', name: 'Exec Out', isInput: false));
  }

  void addInput(Pin pin) => _inputs.add(pin);
  void addOutput(Pin pin) => _outputs.add(pin);

  @override
  Future<void> execute(VariableRegistry registry) async {

  }
}