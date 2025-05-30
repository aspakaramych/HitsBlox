// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:app/blocks/block_factory.dart';
import 'package:app/core/nodes/assignment_node_factory.dart';
import 'package:app/core/pins/pin.dart';
import 'package:app/utils/offset_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OffsetExtension toJson/fromJson tests', () {
    test('Offset.toJson() should return correct Map', () {
      final offset = Offset(10.5, -20.5);
      final json = offset.toJson();

      expect(json, isA<Map<String, double>>());
      expect(json['dx'], equals(10.5));
      expect(json['dy'], equals(-20.5));
    });

    test('Offset.fromJson() should return correct Offset', () {
      final json = {'dx': 30.0, 'dy': 40.5};
      final offset = OffsetExtension.fromJson(json);

      expect(offset.dx, equals(30.0));
      expect(offset.dy, equals(40.5));
    });

    test('Round-trip: Offset -> toJson -> fromJson should be equal', () {
      final original = Offset(100.0, -50.0);
      final json = original.toJson();
      final restored = OffsetExtension.fromJson(json);

      expect(restored, equals(original));
    });
  });

  group('AssignmentBlock toJson', () {
    test('AssignmentBlocks toJson should return correct data', () {
      final position = Offset(10.5, -20.5);
      final node = AssignmentNodeFactory.createNode(position, "1", "int");
      final block = BlockFactory.createIntBlock(TransformationController());
      block.node.inputs.add(Pin(id: "pinid", name: "input", isInput: true));
      print(block.toJson());
    });
  });
}
