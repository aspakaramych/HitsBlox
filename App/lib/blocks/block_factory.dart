import 'package:app/blocks/if_else_block.dart';
import 'package:app/core/ConsoleService.dart';
import 'package:app/core/nodes/AddNode.dart';
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
import 'package:app/blocks/start_block.dart';
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
        color: Colors.blueAccent,
        blockName: "int",
        node: assignNode,
        nodeId: assignNode.id
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
        color: Colors.deepPurple,
        blockName: "bool",
        node: assignNode,
        nodeId: assignNode.id
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
        color: Colors.pink,
        blockName: "string",
        node: assignNode,
        nodeId: assignNode.id
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
      color: Colors.orangeAccent,
      blockName: "print",
      node: printNode,
      nodeId: printNode.id,
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
      color: Colors.green,
      blockName: "start",
      width: 200,
      height: 60,
      leftArrows: [],
      rightArrows: List.of([Position(Offset(15, 15), false)]),
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
      color: Colors.deepOrangeAccent,
      blockName: "multiply",
      width: 200,
      height: 80,
      leftArrows: List.of(
          [Position(Offset(15, 15), false), Position(Offset(15, 45), false)]),
      rightArrows: List.of([Position(Offset(15, 15), false)]),
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
      color: Color.fromARGB(255, 35, 0, 124),
      blockName: "add",
      width: 200,
      height: 80,
      leftArrows: List.of(
          [Position(Offset(15, 15), false), Position(Offset(15, 45), false)]),
      rightArrows: List.of([Position(Offset(15, 15), false)]),
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
      color: Color.fromARGB(255, 163, 71, 216),
      blockName: "concat",
      width: 200,
      height: 80,
      leftArrows: List.of(
          [Position(Offset(15, 15), false), Position(Offset(15, 45), false)]),
      rightArrows: List.of([Position(Offset(15, 15), false)]),
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
      color: Color.fromARGB(255, 99, 81, 38),
      blockName: "divide",
      width: 200,
      height: 80,
      leftArrows: List.of(
          [Position(Offset(15, 15), false), Position(Offset(15, 45), false)]),
      rightArrows: List.of([Position(Offset(15, 15), false)]),
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
      color: Color.fromARGB(255, 255, 180, 117),
      blockName: "subtract",
      width: 200,
      height: 80,
      leftArrows: List.of(
          [Position(Offset(15, 15), false), Position(Offset(15, 45), false)]),
      rightArrows: List.of([Position(Offset(15, 15), false)]),
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
      color: Color.fromARGB(255, 255, 180, 117),
      blockName: "equals",
      width: 200,
      height: 80,
      leftArrows: List.of(
          [Position(Offset(15, 15), false), Position(Offset(15, 45), false)]),
      rightArrows: List.of([Position(Offset(15, 15), false)]),
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
      color: Color.fromARGB(255, 255, 180, 117),
      blockName: "more",
      width: 200,
      height: 80,
      leftArrows: List.of(
          [Position(Offset(15, 15), false), Position(Offset(15, 45), false)]),
      rightArrows: List.of([Position(Offset(15, 15), false)]),
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
      color: Color.fromARGB(255, 255, 180, 117),
      blockName: "less",
      width: 200,
      height: 80,
      leftArrows: List.of(
          [Position(Offset(15, 15), false), Position(Offset(15, 45), false)]),
      rightArrows: List.of([Position(Offset(15, 15), false)]),
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
      color: Color.fromARGB(255, 47, 44, 44),
      blockName: "if else",
      width: 200,
      height: 80,
      leftArrows: List.of(
          [Position(Offset(15, 15), false)]),
      rightArrows: List.of([Position(Offset(15, 15), false), Position(Offset(15, 45), false)]),
    );
  }
}