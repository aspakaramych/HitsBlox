import 'dart:ui';

import 'package:app/core/nodes/node_factory.dart';
import 'package:app/core/pins/empty_pin.dart';
import 'package:app/core/pins/pin.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/utils/offset_extension.dart';

abstract class Node {
  String get id;

  List<Pin> inputs = [];
  List<Pin> outputs = [];

  Offset position;

  String get title;

  Node(this.position);

  Future<void> execute(VariableRegistry registry);

  bool areAllInputsReady() {
    return inputs.every(
      (pin) =>
          !pin.isInput ||
          pin.isExecutionPin ||
          !pin.isRequired ||
          pin.getValue() != null,
    );
  }

  void addInput(Pin pin) {
    var oldPin = inputs.indexWhere((p) => p.id == "empty");
    if (oldPin >= 0 && oldPin != null) {
      inputs[oldPin] = pin;
      return;
    }
    inputs.add(pin);
  }

  void addInputOnIndex(Pin pin, int index) {
    if (index + 1 > inputs.length) {
      int diff = (index + 1) - inputs.length;
      while (diff > 0) {
        inputs.add(EmptyPin());
        diff--;
      }
    }
    inputs[index] = pin;
  }

  void addOutput(Pin pin) {
    var oldPin = outputs.indexWhere((p) => p.id == "empty");
    if (oldPin >= 0 && oldPin != null) {
      outputs[oldPin] = pin;
      return;
    }
    outputs.add(pin);
  }

  void addOutputOnIndex(Pin pin, int index) {
    if (index + 1 > outputs.length) {
      int diff = (index + 1) - outputs.length;
      while (diff > 0) {
        outputs.add(EmptyPin());
        diff--;
      }
    }
    outputs[index] = pin;
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

  factory Node.fromJson(Map<String, dynamic> json) {
    final node = NodeFactory.createNode(
      OffsetExtension.fromJson(json['position']),
      json['id'],
      json['title'],
    );
    final inputPins =
        (json['inputs'] as List).map((p) => pinFromJson(p)).toList();
    final outputPins =
        (json['outputs'] as List).map((p) => pinFromJson(p)).toList();

    node.inputs = inputPins;
    node.outputs = outputPins;

    return node;
  }

  void clearOutputs() {
    for (var p in outputs) {
      p.setValue(null);
    }
  }

  void clearInputs() {
    for (var p in inputs) {
      p.setValue(null);
    }
  }
}
