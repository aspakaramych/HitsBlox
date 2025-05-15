import 'dart:ui';

import 'package:app/utils/offset_extension.dart';

import '../pins/Pin.dart';
import 'assignment_node_factory.dart';

abstract class AssignNode {
  String get id;
  String get rawExpression;
  void setAssignmentsFromText(String text);
  void setText(String text);
  List<Pin> outputs = [];
  List<Pin> inputs = [];

  Offset position;

  String get title;

  AssignNode(this.position);

  void addInput(Pin pin) => inputs.add(pin);
  void addOutput(Pin pin) => outputs.add(pin);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position.toJson(),
      'title': title,
      'inputs': inputs.map(pinToJson).toList(),
      'outputs': outputs.map(pinToJson).toList(),
    };
  }

  factory AssignNode.fromJson(Map<String, dynamic> json) {
    final node = AssignmentNodeFactory.createNode(
      OffsetExtension.fromJson(json['position']),
      json['id'],
      json['title'],
    );
    final inputPins = (json['inputs'] as List).map((p) => pinFromJson(p)).toList();
    final outputPins = (json['outputs'] as List).map((p) => pinFromJson(p)).toList();

    node.inputs = inputPins;
    node.outputs = outputPins;

    return node;
  }
}