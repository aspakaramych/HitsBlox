import 'dart:ui';

import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/utils/offset_extension.dart';
import 'package:flutter/cupertino.dart';

import '../pins/Pin.dart';

class SwapNode extends Node {

  String rawExpressionFirst = '';
  String rawExpressionSecond= '';

  final TextEditingController controller = TextEditingController();

  @override
  final List<Pin> _inputs = [];

  @override
  final List<Pin> _outputs = [];

  @override
  final String id;

  @override
  String get title => "Swap";

  SwapNode(String this.id, Offset position) : super(position) {
  }


  @override
  Future<void> execute(VariableRegistry registry) {
    // TODO: implement execute
    throw UnimplementedError();
  }

  static Map<String, dynamic> toJson_(SwapNode node) {
    return {
      'id': node.id,
      'position': node.position.toJson(),
      'title': node.title,
      'rawExpressionFirst': node.rawExpressionFirst,
      'rawExpressionSecond': node.rawExpressionSecond,
      'inputs': node.inputs.map(pinToJson).toList(),
      'outputs': node.outputs.map(pinToJson).toList(),
    };
  }

  factory SwapNode.fromJson(Map<String, dynamic> json) {
    final node = SwapNode(json['id'], OffsetExtension.fromJson(json['position']));

    final inputPins = (json['inputs'] as List).map((p) => pinFromJson(p)).toList();
    final outputPins = (json['outputs'] as List).map((p) => pinFromJson(p)).toList();

    node.inputs = inputPins;
    node.outputs = outputPins;
    node.rawExpressionFirst = json['rawExpressionFirst'];
    node.rawExpressionSecond = json['rawExpressionSecond'];

    return node;
  }
}