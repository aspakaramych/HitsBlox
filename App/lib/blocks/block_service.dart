import 'package:app/blocks/print_block.dart';
import 'package:app/blocks/swap_block.dart';
import 'package:app/blocks/while_block.dart';
import 'package:app/design/widgets/widgets.dart';
import 'package:app/screens/test_screen.dart';
import 'package:flutter/cupertino.dart';

import '../core/abstracts/Node.dart';
import 'assignment_block.dart';
import 'block_factory.dart';
import 'comment_block.dart';
import 'if_else_block.dart';
import 'logic_block.dart';

class BlockService {
  final TestScreen widget;
  final Function() refreshUI;

  BlockService(this.widget, this.refreshUI);

  void addAssignmentBlock(AssignmentBlock block) {
      widget.assignmentBlocks.add(block);
      widget.nodeGraph.addNode(block.node as Node);
      refreshUI();
  }

  void addLogicBlock(LogicBlock block) {
    widget.logicBlocks.add(block);
    widget.nodeGraph.addNode(block.node as Node);
    refreshUI();
  }

  void addIfElseBlock(IfElseBlock block) {
      widget.ifElseBlocks.add(block);
      widget.nodeGraph.addNode(block.node as Node);
      refreshUI();
  }

  void addWhileBlock(WhileBlock block) {
      widget.whileBlocks.add(block);
      widget.nodeGraph.addNode(block.node as Node);
      refreshUI();
  }

  void addSwapBlock(SwapBlock block) {
      widget.swapBlocks.add(block);
      widget.nodeGraph.addNode(block.node as Node);
      refreshUI();
  }

  void addCommentBlock(CommentBlock block) {
      widget.commentBlocks.add(block);
      widget.nodeGraph.addNode(block.node as Node);
      refreshUI();
  }

  void addPrintBlock(PrintBlock block) {
      widget.printBlocks.add(block);
      widget.nodeGraph.addNode(block.node as Node);
      refreshUI();
  }

  Map<String, List<Block>> getBlocks(TransformationController _transformationController) {
    return {
      'Переменные': [
        Block(
          name: "int",
          action:
              () =>
              addAssignmentBlock(
                BlockFactory.createIntBlock(_transformationController),
              ),
        ),
        Block(
          name: "bool",
          action:
              () =>
              addAssignmentBlock(
                BlockFactory.createBoolBlock(_transformationController),
              ),
        ),
        Block(
          name: "string",
          action:
              () =>
              addAssignmentBlock(
                BlockFactory.createStringBlock(_transformationController),
              ),
        ),
        Block(
          name: "array",
          action:
              () =>
              addAssignmentBlock(
                BlockFactory.createArrayBlock(_transformationController),
              ),
        ),
      ],
      "Функции" : [
      Block(
        name: "arrrayAdd",
        action:
            () =>
            addAssignmentBlock(
              BlockFactory.createAddArrayBlock(_transformationController),
            ),
      ),
      Block(
        name: "length",
        action:
            () =>
            addAssignmentBlock(
              BlockFactory.createLengthBlock(_transformationController),
            ),
      ),
      Block(
        name: "multiply",
        action:
            () =>
            addLogicBlock(
              BlockFactory.createMultiplyBlock(_transformationController),
            ),
      ),
      Block(
        name: "swap",
        action:
            () =>
            addSwapBlock(
              BlockFactory.createSwapBlock(_transformationController),
            ),
      ),
      Block(
        name: "divide",
        action:
            () =>
            addLogicBlock(
              BlockFactory.createDivisionBlock(_transformationController),
            ),
      ),
      Block(
        name: "mod",
        action:
            () =>
            addLogicBlock(
              BlockFactory.createModBlock(_transformationController),
            ),
      ),
      Block(
        name: "subtract",
        action:
            () =>
            addLogicBlock(
              BlockFactory.createSubtractBlock(_transformationController),
            ),
      ),
      Block(
        name: "add",
        action:
            () =>
            addLogicBlock(
              BlockFactory.createAddictionBlock(_transformationController),
            ),
      ),
      Block(
        name: "increment",
        action:
            () =>
            addAssignmentBlock(
              BlockFactory.createIncrementBlock(_transformationController),
            ),
      ),
      Block(
        name: "concat",
        action:
            () =>
            addLogicBlock(
              BlockFactory.createConcatBlock(_transformationController),
            ),
      ),
      ],
      'Логические операторы' : [
      Block(
        name: "equal",
        action:
            () =>
            addLogicBlock(
              BlockFactory.createEqualsBlock(_transformationController),
            ),
      ),
      Block(
        name: "more",
        action:
            () =>
            addLogicBlock(
              BlockFactory.createMoreBlock(_transformationController),
            ),
      ),
      Block(
        name: "less",
        action:
            () =>
            addLogicBlock(
              BlockFactory.createLessBlock(_transformationController),
            ),
      ),
      ],
      'Другое' : [
      Block(
        name: "start",
        action:
            () =>
            addLogicBlock(
              BlockFactory.createStartBlock(_transformationController),
            ),
      ),
      Block(
        name: "print",
        action:
            () =>
            addPrintBlock(
              BlockFactory.createPrintBlock(
                _transformationController,
                widget.consoleService,
                widget.registry,
              ),
            ),
      ),
      Block(
        name: "conditional",
        action:
            () =>
            addIfElseBlock(
              BlockFactory.createIfElseBlock(_transformationController),
            ),
      ),
      Block(
        name: "while",
        action:
            () =>
            addWhileBlock(
              BlockFactory.createWhileBlock(_transformationController),
            ),
      ),
      Block(
        name: "comment",
        action:
            () =>
            addCommentBlock(
              BlockFactory.createCommentBlock(_transformationController),
            ),
      ),
      ]
    };
  }
}