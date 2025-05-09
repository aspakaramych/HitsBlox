import 'package:app/core/nodes/PrintNode.dart';
import 'package:app/core/nodes/StartNode.dart';
import 'package:app/viewmodels/assignment_block.dart';
import 'package:app/viewmodels/logic_block.dart';
import 'package:app/viewmodels/start_block.dart';
import 'package:flutter/material.dart';

import '../core/nodes/BoolAssignNode.dart';
import '../core/nodes/IntAssignNode.dart';
import '../core/nodes/StringAssignNode.dart';
import '../utils/Randomizer.dart';
import '../utils/user_position_utils.dart';

class BlockFactory {
  static AssignmentBlock createIntBlock(TransformationController transformationController) {
    final currUserOffset = UserPositionUtils.getVisibleContentRect(transformationController).topLeft;
    final assignNode = IntAssignNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 50),
    );

    return AssignmentBlock(
            position: assignNode.position,
            color: Colors.blueAccent,
            blockName: "int",
            node: assignNode,
            nodeId: assignNode.id
        );
  }

  static AssignmentBlock createBoolBlock(TransformationController transformationController) {
    final currUserOffset = UserPositionUtils.getVisibleContentRect(transformationController).topLeft;
    final assignNode = BoolAssignNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 50),
    );

    return AssignmentBlock(
            position: assignNode.position,
            color: Colors.deepPurple,
            blockName: "bool",
            node: assignNode,
            nodeId: assignNode.id
        );
  }

  static createStringBlock(TransformationController transformationController) {
    final currUserOffset = UserPositionUtils.getVisibleContentRect(transformationController).topLeft;
    final assignNode = StringAssignNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 50),
    );

    return AssignmentBlock(
        position: assignNode.position,
        color: Colors.pink,
        blockName: "string",
        node: assignNode,
        nodeId: assignNode.id
    );
  }

  static createPrintBlock(TransformationController transformationController) {
    final currUserOffset = UserPositionUtils.getVisibleContentRect(transformationController).topLeft;
    final printNode = PrintNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: printNode.position,
      node: printNode,
      color: Colors.orangeAccent,
      blockName: "print",
      leftArrowsCount: 1,
      rightArrowsCount: 1,
    );
  }

  static createStartBlock(TransformationController transformationController) {
    final currUserOffset = UserPositionUtils.getVisibleContentRect(transformationController).topLeft;
    final startNode = StartNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 100),
    );

    return StartBlock(
      position: startNode.position,
      node: startNode,
      color: Colors.yellow,
      blockName: "start",
    );
  }
}