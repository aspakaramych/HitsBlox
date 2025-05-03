import 'package:app/core/Engine.dart';
import 'package:app/core/Pins/Pin.dart';
import 'package:app/core/registry/VariableRegistry.dart';

abstract class Node {
  final String id;
  final List<Pin> inputs = [];
  final List<Pin> outputs = [];

  Node(this.id);

  void addInput(Pin pin){
    inputs.add(pin);
  }

  void addOutput(Pin pin){
    outputs.add(pin);
  }

  Future<void> execute(VariableRegistry registry, Engine engine);
}