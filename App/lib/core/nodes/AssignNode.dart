import 'dart:ui';

import 'package:app/core/abstracts/Node.dart';
import 'package:app/utils/offset_extension.dart';

import '../pins/Pin.dart';
import 'assignment_node_factory.dart';

abstract class AssignNode extends Node{
  String get id;
  String rawExpression = '';
  void setAssignmentsFromText(String text);
  void setText(String text);
  List<Pin> outputs = [];
  List<Pin> inputs = [];

  Offset position;

  String get title;

  AssignNode(this.position) : super(position);

  void addInput(Pin pin) => inputs.add(pin);
  void addOutput(Pin pin) => outputs.add(pin);

  static Map<String, dynamic> toJson_(AssignNode node) {
    return {
      'id': node.id,
      'position': node.position.toJson(),
      'title': node.title,
      'rawExpression': node.rawExpression,
      'inputs': node.inputs.map(pinToJson).toList(),
      'outputs': node.outputs.map(pinToJson).toList(),
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
    final rawExpression = json['rawExpression'];

    node.inputs = inputPins;
    node.outputs = outputPins;
    node.rawExpression = rawExpression;

    return node;
  }
}