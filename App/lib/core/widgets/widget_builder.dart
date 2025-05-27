import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/widgets/print_block_widget.dart';
import 'package:app/core/widgets/swap_block_widget.dart';
import 'package:app/core/widgets/while_block_widget.dart';
import 'package:app/screens/test_screen.dart';
import 'package:flutter/cupertino.dart';

import '../../blocks/assignment_block.dart';
import '../../blocks/comment_block.dart';
import '../../blocks/if_else_block.dart';
import '../../blocks/logic_block.dart';
import '../../blocks/print_block.dart';
import '../../blocks/swap_block.dart';
import '../../blocks/while_block.dart';
import '../../utils/pair.dart';
import 'assignment_widget.dart';
import 'comment_block_widget.dart';
import 'if_else_block_widget.dart';
import 'logic_block_widget.dart';

class TestScreenWidgetBuilder {
  final TestScreen widget;
  final Function() refreshUI;
  final Function(String) deleteNode;
  final Function(String) deleteConnection;
  final Function(String, String, Node, Node) deleteConnectionBetween;
  final Function(String) deleteCalibrations;
  final Function(Node, Node, int, int, bool, bool) makeConnection;
  var temp;
  int outputIndex = 1;
  var currOutputCalibration;

  TestScreenWidgetBuilder(
    this.widget,
    this.refreshUI,
    this.deleteNode,
    this.deleteConnection,
    this.deleteConnectionBetween,
    this.deleteCalibrations,
    this.makeConnection,
    this.temp,
    this.currOutputCalibration,
  );

  Widget buildAssignmentBlock(AssignmentBlock block) {
    return AssignmentBlockWidget(
      key: ValueKey(block.node.id),
      block: block,
      mark: (widget.selectedBlockService.activeNodeIds.contains(block.nodeId)),
      onEditToggle: () {
        block.isEditing = !block.isEditing;
        refreshUI();
      },
      deleteNode: () {
        widget.assignmentBlocks.remove(block);
        widget.wiredBlocks.removeWhere(
          (binding) =>
              binding.first.nodeId == block.node.id ||
              binding.second.nodeId == block.node.id,
        );

        widget.calibrations.removeWhere(
          (key, value) => key.contains(block.nodeId),
        );
        widget.outputCalibrations.removeWhere(
          (key, value) => key.contains(block.nodeId),
        );

        deleteNode(block.nodeId);
        deleteConnection(block.nodeId);

        deleteCalibrations(block.nodeId);
        refreshUI();
      },
      onPositionChanged: (newPosition) {
        refreshUI();
        block.position = newPosition;
      },
      onLeftArrowClick: (index) {
        if (temp != null) {
          if (widget.calibrations.containsKey(
            "${temp.nodeId}${block.nodeId}",
          )) {
            widget.wiredBlocks.removeWhere(
              (binding) =>
                  binding.first.nodeId == temp.nodeId &&
                  binding.second.nodeId == block.nodeId,
            );

            deleteConnectionBetween(
              temp.nodeId,
              block.nodeId,
              temp.node,
              block.node,
            );

            widget.calibrations.remove("${temp.nodeId}${block.nodeId}");
            widget.outputCalibrations.remove("${temp.nodeId}${block.nodeId}");

            temp = null;
            refreshUI();
            return;
          }

          makeConnection(temp.node as Node, block.node as Node, index, outputIndex, false, temp is IfElseBlock);
          widget.calibrations["${temp.nodeId}${block.nodeId}"] = Offset(0, 60);
          if (currOutputCalibration != null) {
            widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                currOutputCalibration;
          } else {
            widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] = Offset(
              0,
              0,
            );
            ;
          }
          widget.wiredBlocks.add(Pair(temp, block));
          temp = null;
          currOutputCalibration = null;
        }
        refreshUI();
      },
      onRightArrowClick: () {
        temp = block;
        currOutputCalibration = Offset(block.width, block.height / 2 + 15);
        refreshUI();
      },
    );
  }

  Widget buildLogicBlock(LogicBlock block) {
    return LogicBlockWidget(
      key: ValueKey(block.nodeId),
      block: block,
      mark: (widget.selectedBlockService.activeNodeIds.contains(block.nodeId)),
      deleteNode: () {
        widget.logicBlocks.remove(block);
        widget.wiredBlocks.removeWhere(
          (binding) =>
              binding.first.nodeId == block.nodeId ||
              binding.second.nodeId == block.nodeId,
        );

        widget.calibrations.removeWhere(
          (key, value) => key.contains(block.nodeId),
        );
        widget.outputCalibrations.removeWhere(
          (key, value) => key.contains(block.nodeId),
        );

        deleteNode(block.nodeId);
        deleteConnection(block.nodeId);

        deleteCalibrations(block.nodeId);
        refreshUI();
      },
      onPositionChanged: (newPosition) {
        block.position = newPosition;
        refreshUI();
      },
      onLeftArrowClick: (position, index) {
        if (temp != null) {
          if (widget.calibrations.containsKey(
            "${temp.nodeId}${block.nodeId}",
          )) {
            widget.wiredBlocks.removeWhere(
              (binding) =>
                  binding.first.nodeId == temp.nodeId &&
                  binding.second.nodeId == block.nodeId,
            );

            deleteConnectionBetween(
              temp.nodeId,
              block.nodeId,
              temp.node,
              block.node,
            );

            widget.calibrations.remove("${temp.nodeId}${block.nodeId}");
            widget.outputCalibrations.remove("${temp.nodeId}${block.nodeId}");

            temp = null;
            refreshUI();
            return;
          }

          makeConnection(temp.node as Node, block.node as Node, index, outputIndex, true, temp is IfElseBlock);
          widget.calibrations["${temp.nodeId}${block.nodeId}"] = Offset(
            0,
            position.dy + 10,
          );

          if (currOutputCalibration != null) {
            widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                currOutputCalibration;
          } else {
            widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] = Offset(
              0,
              0,
            );
          }

          widget.wiredBlocks.add(Pair(temp, block));

          temp = null;
          currOutputCalibration = null;
        }
        refreshUI();
      },
      onRightArrowClick: () {
        temp = block;
        currOutputCalibration = Offset(block.width, block.height / 2 + 15);
        refreshUI();
      },
    );
  }

  Widget buildPrintBlock(PrintBlock block) {
    return PrintBlockWidget(
      key: ValueKey(block.node.id),
      block: block,
      mark: (widget.selectedBlockService.activeNodeIds.contains(block.nodeId)),
      onEditToggle: () {
        block.isEditing = !block.isEditing;
        refreshUI();
      },
      deleteNode: () {
        widget.printBlocks.remove(block);
        widget.wiredBlocks.removeWhere(
          (binding) =>
              binding.first.nodeId == block.node.id ||
              binding.second.nodeId == block.node.id,
        );

        widget.calibrations.removeWhere(
          (key, value) => key.contains(block.nodeId),
        );
        widget.outputCalibrations.removeWhere(
          (key, value) => key.contains(block.nodeId),
        );

        deleteNode(block.nodeId);
        deleteConnection(block.nodeId);

        deleteCalibrations(block.nodeId);
        refreshUI();
      },
      onPositionChanged: (newPosition) {
        block.position = newPosition;
        refreshUI();
      },
      onLeftArrowClick: (index) {
        if (temp != null) {
          if (widget.calibrations.containsKey(
            "${temp.nodeId}${block.nodeId}",
          )) {
            widget.wiredBlocks.removeWhere(
              (binding) =>
                  binding.first.nodeId == temp.nodeId &&
                  binding.second.nodeId == block.nodeId,
            );

            deleteConnectionBetween(
              temp.nodeId,
              block.nodeId,
              temp.node,
              block.node,
            );

            widget.calibrations.remove("${temp.nodeId}${block.nodeId}");
            widget.outputCalibrations.remove("${temp.nodeId}${block.nodeId}");

            temp = null;
            refreshUI();
            return;
          }
          makeConnection(temp.node as Node, block.node as Node, index, outputIndex, false, temp is IfElseBlock);
          widget.calibrations["${temp.nodeId}${block.nodeId}"] = Offset(
            0,
            block.height / 2 + 15,
          );
          if (currOutputCalibration != null) {
            widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                currOutputCalibration;
          } else {
            widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] = Offset(
              0,
              0,
            );
          }
          widget.wiredBlocks.add(Pair(temp, block));
          temp = null;
          currOutputCalibration = null;
        }
        refreshUI();
      },
      onRightArrowClick: () {
        temp = block;
        currOutputCalibration = Offset(block.width, block.height / 2 + 15);
        refreshUI();
      },
    );
  }

  Widget buildIfElseBlock(IfElseBlock block) {
    return IfElseBlockWidget(
      key: ValueKey(block.nodeId),
      block: block,
      mark: (widget.selectedBlockService.activeNodeIds.contains(block.nodeId)),
      deleteNode: () {
        widget.ifElseBlocks.remove(block);
        widget.wiredBlocks.removeWhere(
          (binding) =>
              binding.first.nodeId == block.nodeId ||
              binding.second.nodeId == block.nodeId,
        );

        widget.calibrations.removeWhere(
          (key, value) => key.contains(block.nodeId),
        );
        widget.outputCalibrations.removeWhere(
          (key, value) => key.contains(block.nodeId),
        );

        deleteNode(block.nodeId);
        deleteConnection(block.nodeId);

        deleteCalibrations(block.nodeId);
        refreshUI();
      },
      onPositionChanged: (newPosition) {
        block.position = newPosition;
        refreshUI();
      },
      onLeftArrowClick: (position, inputIndex) {
        if (temp != null) {
          if (widget.calibrations.containsKey(
            "${temp.nodeId}${block.nodeId}",
          )) {
            widget.wiredBlocks.removeWhere(
              (binding) =>
                  binding.first.nodeId == temp.nodeId &&
                  binding.second.nodeId == block.nodeId,
            );

            deleteConnectionBetween(
              temp.nodeId,
              block.nodeId,
              temp.node,
              block.node,
            );

            widget.calibrations.remove("${temp.nodeId}${block.nodeId}");
            widget.outputCalibrations.remove("${temp.nodeId}${block.nodeId}");

            temp = null;
            refreshUI();
            return;
          }
          makeConnection(temp.node as Node, block.node as Node, inputIndex, outputIndex, true, temp is IfElseBlock);
          widget.calibrations["${temp.nodeId}${block.nodeId}"] = Offset(
            0,
            position.dy + 5,
          );

          if (currOutputCalibration != null) {
            widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                currOutputCalibration;
          } else {
            widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] = Offset(
              0,
              0,
            );
            ;
          }
          widget.wiredBlocks.add(Pair(temp, block));
          temp = null;
          currOutputCalibration = null;
        }
        refreshUI();
      },
      onRightArrowClick: (position, index) {
        temp = block;
        currOutputCalibration = Offset(block.width, position.dy + 10);
        outputIndex = index;
        refreshUI();
      },
    );
  }

  Widget buildWhileBlock(WhileBlock block) {
    return WhileBlockWidget(
      key: ValueKey(block.nodeId),
      block: block,
      mark: (widget.selectedBlockService.activeNodeIds.contains(block.nodeId)),
      onEditToggle: () {
        block.isEditing = !block.isEditing;
        refreshUI();
      },
      deleteNode: () {
        widget.whileBlocks.remove(block);
        widget.wiredBlocks.removeWhere(
          (binding) =>
              binding.first.nodeId == block.nodeId ||
              binding.second.nodeId == block.nodeId,
        );

        widget.calibrations.removeWhere(
          (key, value) => key.contains(block.nodeId),
        );
        widget.outputCalibrations.removeWhere(
          (key, value) => key.contains(block.nodeId),
        );

        deleteNode(block.nodeId);
        deleteConnection(block.nodeId);

        deleteCalibrations(block.nodeId);
        refreshUI();
      },
      onPositionChanged: (newPosition) {
        block.position = newPosition;
        refreshUI();
      },
      onLeftArrowClick: (index) {
        if (temp != null) {
          if (widget.calibrations.containsKey(
            "${temp.nodeId}${block.nodeId}",
          )) {
            widget.wiredBlocks.removeWhere(
              (binding) =>
                  binding.first.nodeId == temp.nodeId &&
                  binding.second.nodeId == block.nodeId,
            );

            deleteConnectionBetween(
              temp.nodeId,
              block.nodeId,
              temp.node,
              block.node,
            );

            widget.calibrations.remove("${temp.nodeId}${block.nodeId}");
            widget.outputCalibrations.remove("${temp.nodeId}${block.nodeId}");

            temp = null;
            refreshUI();
            return;
          }
          makeConnection(temp.node as Node, block.node as Node, index, outputIndex, false, temp is IfElseBlock);
          widget.calibrations["${temp.nodeId}${block.nodeId}"] = Offset(0, 55);

          if (currOutputCalibration != null) {
            widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                currOutputCalibration;
          } else {
            widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] = Offset(
              0,
              0,
            );
            ;
          }
          widget.wiredBlocks.add(Pair(temp, block));
          temp = null;
          currOutputCalibration = null;
        }
        refreshUI();
      },
      onRightArrowClick: (position) {
        temp = block;
        currOutputCalibration = Offset(block.width, position.dy + 10);
        refreshUI();
      },
    );
  }

  Widget buildCommentBlock(CommentBlock block) {
    return CommentBlockWidget(
      key: ValueKey(block.nodeId),
      block: block,
      onEditToggle: () {
        block.isEditing = !block.isEditing;
        refreshUI();
      },
      deleteNode: () {
        widget.commentBlocks.remove(block);

        deleteCalibrations(block.nodeId);
        refreshUI();
      },
      onPositionChanged: (newPosition) {
        block.position = newPosition;
        refreshUI();
      },
    );
  }

  Widget buildSwapBlock(SwapBlock block) {
    return SwapBlockWidget(
      key: ValueKey(block.node.id),
      block: block,
      mark: (widget.selectedBlockService.activeNodeIds.contains(block.nodeId)),
      onEditToggle: () {
        block.isEditing = !block.isEditing;
        refreshUI();
      },
      deleteNode: () {
        widget.swapBlocks.remove(block);
        widget.wiredBlocks.removeWhere(
          (binding) =>
              binding.first.nodeId == block.node.id ||
              binding.second.nodeId == block.node.id,
        );

        widget.calibrations.removeWhere(
          (key, value) => key.contains(block.nodeId),
        );
        widget.outputCalibrations.removeWhere(
          (key, value) => key.contains(block.nodeId),
        );

        deleteNode(block.nodeId);
        deleteConnection(block.nodeId);

        deleteCalibrations(block.nodeId);
        refreshUI();
      },
      onPositionChanged: (newPosition) {
        block.position = newPosition;
        refreshUI();
      },
      onLeftArrowClick: (index) {
        if (temp != null) {
          if (widget.calibrations.containsKey(
            "${temp.nodeId}${block.nodeId}",
          )) {
            widget.wiredBlocks.removeWhere(
              (binding) =>
                  binding.first.nodeId == temp.nodeId &&
                  binding.second.nodeId == block.nodeId,
            );

            deleteConnectionBetween(
              temp.nodeId,
              block.nodeId,
              temp.node,
              block.node,
            );

            widget.calibrations.remove("${temp.nodeId}${block.nodeId}");
            widget.outputCalibrations.remove("${temp.nodeId}${block.nodeId}");

            temp = null;
            return;
          }

          makeConnection(temp.node as Node, block.node as Node, index, outputIndex, false, temp is IfElseBlock);
          widget.calibrations["${temp.nodeId}${block.nodeId}"] = Offset(0, 60);
          if (currOutputCalibration != null) {
            widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                currOutputCalibration;
          } else {
            widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] = Offset(
              0,
              0,
            );
            ;
          }
          widget.wiredBlocks.add(Pair(temp, block));
          temp = null;
          currOutputCalibration = null;
        }
        refreshUI();
      },
      onRightArrowClick: () {
        temp = block;
        currOutputCalibration = Offset(block.width, 60);
        refreshUI();
      },
    );
  }
}
