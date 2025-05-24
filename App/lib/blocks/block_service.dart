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

  List<Block> getBlocks(TransformationController _transformationController) {
    return [
      Block(
        name: "Целочисленная переменная",
        action:
            () => addAssignmentBlock(
          BlockFactory.createIntBlock(_transformationController),
        ),
      ),
      Block(
        name: "Булева переменная",
        action:
            () => addAssignmentBlock(
          BlockFactory.createBoolBlock(_transformationController),
        ),
      ),
      Block(
        name: "Строковая переменная",
        action:
            () => addAssignmentBlock(
          BlockFactory.createStringBlock(_transformationController),
        ),
      ),
      Block(
        name: "Массив",
        action:
            () => addAssignmentBlock(
          BlockFactory.createArrayBlock(_transformationController),
        ),
      ),
      Block(
        name: "Добавление в массив",
        action:
            () => addAssignmentBlock(
          BlockFactory.createAddArrayBlock(_transformationController),
        ),
      ),
      Block(
        name: "Получение длины массива",
        action:
            () => addAssignmentBlock(
          BlockFactory.createLengthBlock(_transformationController),
        ),
      ),
      Block(
        name: "Вывод",
        action:
            () => addPrintBlock(
          BlockFactory.createPrintBlock(
            _transformationController,
            widget.consoleService,
            widget.registry,
          ),
        ),
      ),
      Block(
        name: "Старт",
        action:
            () => addLogicBlock(
          BlockFactory.createStartBlock(_transformationController),
        ),
      ),
      Block(
        name: "Умножение",
        action:
            () => addLogicBlock(
          BlockFactory.createMultiplyBlock(_transformationController),
        ),
      ),
      Block(
        name: "Swap",
        action:
            () => addSwapBlock(
          BlockFactory.createSwapBlock(_transformationController),
        ),
      ),
      Block(
        name: "Деление",
        action:
            () => addLogicBlock(
          BlockFactory.createDivisionBlock(_transformationController),
        ),
      ),
      Block(
        name: "Остаток от деления",
        action:
            () => addLogicBlock(
          BlockFactory.createModBlock(_transformationController),
        ),
      ),
      Block(
        name: "Вычитание",
        action:
            () => addLogicBlock(
          BlockFactory.createSubtractBlock(_transformationController),
        ),
      ),
      Block(
        name: "Сложение",
        action:
            () => addLogicBlock(
          BlockFactory.createAddictionBlock(_transformationController),
        ),
      ),
      Block(
        name: "Инкремент",
        action:
            () => addAssignmentBlock(
          BlockFactory.createIncrementBlock(_transformationController),
        ),
      ),
      Block(
        name: "Конкатенация",
        action:
            () => addLogicBlock(
          BlockFactory.createConcatBlock(_transformationController),
        ),
      ),
      Block(
        name: "Эквивалентность",
        action:
            () => addLogicBlock(
          BlockFactory.createEqualsBlock(_transformationController),
        ),
      ),
      Block(
        name: "Больше",
        action:
            () => addLogicBlock(
          BlockFactory.createMoreBlock(_transformationController),
        ),
      ),
      Block(
        name: "Меньше",
        action:
            () => addLogicBlock(
          BlockFactory.createLessBlock(_transformationController),
        ),
      ),
      Block(
        name: "Условие",
        action:
            () => addIfElseBlock(
          BlockFactory.createIfElseBlock(_transformationController),
        ),
      ),
      Block(
        name: "While",
        action:
            () => addWhileBlock(
          BlockFactory.createWhileBlock(_transformationController),
        ),
      ),
      Block(
        name: "Комментарий",
        action:
            () => addCommentBlock(
          BlockFactory.createCommentBlock(_transformationController),
        ),
      ),
    ];
  }
}