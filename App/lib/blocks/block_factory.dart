import 'package:app/blocks/if_else_block.dart';
import 'package:app/core/ConsoleService.dart';
import 'package:app/core/nodes/AddNode.dart';
import 'package:app/core/nodes/ArrayAddNode.dart';
import 'package:app/core/nodes/ArrayAsignNode.dart';
import 'package:app/core/nodes/ConcatNode.dart';
import 'package:app/core/nodes/DivideNode.dart';
import 'package:app/core/nodes/EqualsNode.dart';
import 'package:app/core/nodes/IfElseNode.dart';
import 'package:app/core/nodes/LessNode.dart';
import 'package:app/core/nodes/MoreNode.dart';
import 'package:app/core/nodes/MultiplyNode.dart';
import 'package:app/core/nodes/PrintNode.dart';
import 'package:app/core/nodes/StartNode.dart';
import 'package:app/core/nodes/SubNode.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/blocks/assignment_block.dart';
import 'package:app/blocks/logic_block.dart';
import 'package:app/blocks/position.dart';
import 'package:app/blocks/print_block.dart';
import 'package:flutter/material.dart';

import '../core/nodes/BoolAssignNode.dart';
import '../core/nodes/IntAssignNode.dart';
import '../core/nodes/StringAssignNode.dart';
import '../utils/Randomizer.dart';
import '../utils/user_position_utils.dart';

class BlockFactory {
  static AssignmentBlock createIntBlock(
      TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final assignNode = IntAssignNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 50),
    );

    return AssignmentBlock(
        position: assignNode.position,
        blockName: "int",
        node: assignNode,
    );
  }

  static AssignmentBlock createBoolBlock(
      TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final assignNode = BoolAssignNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 50),
    );

    return AssignmentBlock(
        position: assignNode.position,
        blockName: "bool",
        node: assignNode,
    );
  }

  static createStringBlock(TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final assignNode = StringAssignNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 50),
    );

    return AssignmentBlock(
        position: assignNode.position,
        blockName: "string",
        node: assignNode,
    );
  }

  static createArrayBlock(TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final assignNode = ArrayAsignNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 50),
    );

    return AssignmentBlock(
        position: assignNode.position,
        blockName: "array",
        node: assignNode,
    );
  }

  static createAddArrayBlock(TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final assignNode = ArrayAddNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 50),
    );

    return AssignmentBlock(
      position: assignNode.position,
      blockName: "arrayAdd",
      node: assignNode,
    );
  }

  static createPrintBlock(TransformationController transformationController,
      ConsoleService consoleService, VariableRegistry registry) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final printNode = PrintNode(
      consoleService: consoleService,
      id: 'node_${Randomizer.getRandomInt()}',
      position: Offset(currUserOffset.dx + 50, currUserOffset.dy + 100),
    );

    return PrintBlock(
      position: printNode.position,
      blockName: "print",
      node: printNode,
      registry: registry,
      width: 200,
      height: 90,
    );
  }

  static createStartBlock(TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final startNode = StartNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: startNode.position,
      node: startNode,
      blockName: "start",
      width: 100,
      height: 100,
      leftArrows: [],
      rightArrows: List.of([Position(Offset(15, 55), false)]),
    );
  }

  static createMultiplyBlock(
      TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final multiplyNode = MultiplyNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: multiplyNode.position,
      node: multiplyNode,
      blockName: "multiply",
      width: 120,
      height: 120,
      leftArrows: List.of(
          [Position(Offset(15, 45), false), Position(Offset(15, 90), false)]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createAddictionBlock(
      TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final addictionNode = AddNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: addictionNode.position,
      node: addictionNode,
      blockName: "add",
      width: 120,
      height: 120,
      leftArrows: List.of(
          [Position(Offset(15, 45), false), Position(Offset(15, 90), false)]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createConcatBlock(TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final concatNode = ConcatNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: concatNode.position,
      node: concatNode,
      blockName: "concat",
      width: 120,
      height: 120,
      leftArrows: List.of(
          [Position(Offset(15, 45), false), Position(Offset(15, 90), false)]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createDivisionBlock(
      TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final divideNode = DivideNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: divideNode.position,
      node: divideNode,
      blockName: "divide",
      width: 120,
      height: 120,
      leftArrows: List.of(
          [Position(Offset(15, 45), false), Position(Offset(15, 90), false)]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createSubtractBlock(
      TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final subNode = SubNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: subNode.position,
      node: subNode,
      blockName: "subtract",
      width: 120,
      height: 120,
      leftArrows: List.of(
          [Position(Offset(15, 45), false), Position(Offset(15, 90), false)]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createEqualsBlock(TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final equalsNode = EqualsNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: equalsNode.position,
      node: equalsNode,
      blockName: "equals",
      width: 120,
      height: 120,
      leftArrows: List.of(
          [Position(Offset(15, 45), false), Position(Offset(15, 90), false)]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }
  static createMoreBlock(TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final moreNode = MoreNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: moreNode.position,
      node: moreNode,
      blockName: "more",
      width: 120,
      height: 120,
      leftArrows: List.of(
          [Position(Offset(15, 45), false), Position(Offset(15, 90), false)]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }
  static createLessBlock(TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final lessNode = LessNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: lessNode.position,
      node: lessNode,
      blockName: "less",
      width: 120,
      height: 120,
      leftArrows: List.of(
          [Position(Offset(15, 45), false), Position(Offset(15, 90), false)]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createIfElseBlock(TransformationController transformationController) {
    final currUserOffset = UserPositionUtils
        .getVisibleContentRect(transformationController)
        .topLeft;
    final ifElseNode = IfElseNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 50, currUserOffset.dy + 100),
    );

    return IfElseBlock(
      position: ifElseNode.position,
      node: ifElseNode,
      blockName: "conditional",
      width: 200,
      height: 100,
      leftArrows: List.of(
          [Position(Offset(15, 40), false)]),
      rightArrows: List.of([Position(Offset(15, 40), false), Position(Offset(15, 70), false)]),
    );
  }
}