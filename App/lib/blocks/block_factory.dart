import 'package:app/blocks/comment_block.dart';
import 'package:app/blocks/if_else_block.dart';
import 'package:app/blocks/swap_block.dart';
import 'package:app/blocks/while_block.dart';
import 'package:app/core/console_service.dart';
import 'package:app/core/nodes/add_node.dart';
import 'package:app/core/nodes/array_add_node.dart';
import 'package:app/core/nodes/array_assign_node.dart';
import 'package:app/core/nodes/concat_node.dart';
import 'package:app/core/nodes/divide_node.dart';
import 'package:app/core/nodes/equals_node.dart';
import 'package:app/core/nodes/greater_or_equal_node.dart';
import 'package:app/core/nodes/if_else_node.dart';
import 'package:app/core/nodes/increment_node.dart';
import 'package:app/core/nodes/length_node.dart';
import 'package:app/core/nodes/less_node.dart';
import 'package:app/core/nodes/less_or_equal_node.dart';
import 'package:app/core/nodes/mod_node.dart';
import 'package:app/core/nodes/more_node.dart';
import 'package:app/core/nodes/multiply_node.dart';
import 'package:app/core/nodes/print_node.dart';
import 'package:app/core/nodes/start_node.dart';
import 'package:app/core/nodes/sub_node.dart';
import 'package:app/core/nodes/swap_node.dart';
import 'package:app/core/nodes/while_node.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/blocks/assignment_block.dart';
import 'package:app/blocks/logic_block.dart';
import 'package:app/blocks/position.dart';
import 'package:app/blocks/print_block.dart';
import 'package:flutter/material.dart';

import '../core/nodes/bool_assign_node.dart';
import '../core/nodes/int_assign_node.dart';
import '../core/nodes/string_assign_node.dart';
import '../utils/randomizer.dart';
import '../utils/user_position_utils.dart';

class BlockFactory {
  static AssignmentBlock createIntBlock(
    TransformationController transformationController,
  ) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final assignNode = IntAssignNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return AssignmentBlock(
      position: assignNode.position,
      blockName: "int",
      node: assignNode,
    );
  }

  static AssignmentBlock createBoolBlock(
    TransformationController transformationController,
  ) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final assignNode = BoolAssignNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return AssignmentBlock(
      position: assignNode.position,
      blockName: "bool",
      node: assignNode,
    );
  }

  static createStringBlock(TransformationController transformationController) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final assignNode = StringAssignNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return AssignmentBlock(
      position: assignNode.position,
      blockName: "string",
      node: assignNode,
    );
  }

  static createArrayBlock(TransformationController transformationController) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final assignNode = ArrayAsignNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return AssignmentBlock(
      position: assignNode.position,
      blockName: "array",
      node: assignNode,
    );
  }

  static createAddArrayBlock(
    TransformationController transformationController,
  ) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final assignNode = ArrayAddNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return AssignmentBlock(
      position: assignNode.position,
      blockName: "arrayAdd",
      node: assignNode,
    );
  }

  static createLengthBlock(TransformationController transformationController) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final assignNode = LengthNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return AssignmentBlock(
      position: assignNode.position,
      blockName: "length",
      node: assignNode,
    );
  }

  static createPrintBlock(
    TransformationController transformationController,
    ConsoleService consoleService,
    VariableRegistry registry,
  ) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final printNode = PrintNode(
      consoleService: consoleService,
      id: 'node_${Randomizer.getRandomInt()}',
      position: Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
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
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final startNode = StartNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
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
    TransformationController transformationController,
  ) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final multiplyNode = MultiplyNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: multiplyNode.position,
      node: multiplyNode,
      blockName: "multiply",
      width: 120,
      height: 120,
      leftArrows: List.of([
        Position(Offset(15, 45), false),
        Position(Offset(15, 90), false),
      ]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createAddictionBlock(
    TransformationController transformationController,
  ) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final addictionNode = AddNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: addictionNode.position,
      node: addictionNode,
      blockName: "add",
      width: 120,
      height: 120,
      leftArrows: List.of([
        Position(Offset(15, 45), false),
        Position(Offset(15, 90), false),
      ]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createConcatBlock(TransformationController transformationController) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final concatNode = ConcatNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: concatNode.position,
      node: concatNode,
      blockName: "concat",
      width: 120,
      height: 120,
      leftArrows: List.of([
        Position(Offset(15, 45), false),
        Position(Offset(15, 90), false),
      ]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createDivisionBlock(
    TransformationController transformationController,
  ) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final divideNode = DivideNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: divideNode.position,
      node: divideNode,
      blockName: "divide",
      width: 120,
      height: 120,
      leftArrows: List.of([
        Position(Offset(15, 45), false),
        Position(Offset(15, 90), false),
      ]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createIncrementBlock(
    TransformationController transformationController,
  ) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final assignNode = IncrementNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return AssignmentBlock(
      position: assignNode.position,
      blockName: "increment",
      node: assignNode,
    );
  }

  static createModBlock(TransformationController transformationController) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final modNode = ModNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: modNode.position,
      node: modNode,
      blockName: "mod",
      width: 120,
      height: 120,
      leftArrows: List.of([
        Position(Offset(15, 45), false),
        Position(Offset(15, 90), false),
      ]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createSubtractBlock(
    TransformationController transformationController,
  ) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final subNode = SubNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: subNode.position,
      node: subNode,
      blockName: "subtract",
      width: 120,
      height: 120,
      leftArrows: List.of([
        Position(Offset(15, 45), false),
        Position(Offset(15, 90), false),
      ]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createEqualsBlock(TransformationController transformationController) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final equalsNode = EqualsNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: equalsNode.position,
      node: equalsNode,
      blockName: "==",
      width: 120,
      height: 120,
      leftArrows: List.of([
        Position(Offset(15, 45), false),
        Position(Offset(15, 90), false),
      ]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createMoreBlock(TransformationController transformationController) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final moreNode = MoreNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: moreNode.position,
      node: moreNode,
      blockName: ">",
      width: 120,
      height: 120,
      leftArrows: List.of([
        Position(Offset(15, 45), false),
        Position(Offset(15, 90), false),
      ]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createGreaterOrEqualsBlock(
    TransformationController transformationController,
  ) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).bottomRight;
    final greaterOrEqualNode = GreaterOrEqualNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: greaterOrEqualNode.position,
      node: greaterOrEqualNode,
      blockName: ">=",
      width: 120,
      height: 120,
      leftArrows: List.of([
        Position(Offset(15, 45), false),
        Position(Offset(15, 90), false),
      ]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createLessBlock(TransformationController transformationController) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final lessNode = LessNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: lessNode.position,
      node: lessNode,
      blockName: "<",
      width: 120,
      height: 120,
      leftArrows: List.of([
        Position(Offset(15, 45), false),
        Position(Offset(15, 90), false),
      ]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createLessOrEqualsBlock(
    TransformationController transformationController,
  ) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final lessNodeOrEqualNode = LessOrEqualNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return LogicBlock(
      position: lessNodeOrEqualNode.position,
      node: lessNodeOrEqualNode,
      blockName: "<=",
      width: 120,
      height: 120,
      leftArrows: List.of([
        Position(Offset(15, 45), false),
        Position(Offset(15, 90), false),
      ]),
      rightArrows: List.of([Position(Offset(15, 65), false)]),
    );
  }

  static createIfElseBlock(TransformationController transformationController) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final ifElseNode = IfElseNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return IfElseBlock(
      position: ifElseNode.position,
      node: ifElseNode,
      blockName: "conditional",
      width: 200,
      height: 120,
      leftArrows: List.of([Position(Offset(15, 40), false)]),
      rightArrows: List.of([
        Position(Offset(15, 40), false),
        Position(Offset(15, 80), false),
      ]),
    );
  }

  static createWhileBlock(TransformationController transformationController) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final whileNode = WhileNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return WhileBlock(
      position: whileNode.position,
      node: whileNode,
      blockName: "while",
      width: 200,
      height: 120,
    );
  }

  static createCommentBlock(TransformationController transformationController) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final stringNode = StringAssignNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return CommentBlock(
      position: stringNode.position,
      node: stringNode,
      blockName: "comment",
      width: 220,
      height: 150,
    );
  }

  static createSwapBlock(TransformationController transformationController) {
    final currUserOffset =
        UserPositionUtils.getVisibleContentRect(
          transformationController,
        ).topLeft;
    final swapNode = SwapNode(
      'node_${Randomizer.getRandomInt()}',
      Offset(currUserOffset.dx + 100, currUserOffset.dy + 100),
    );

    return SwapBlock(
      position: swapNode.position,
      node: swapNode,
      blockName: "swap",
      width: 220,
      height: 200,
    );
  }
}
