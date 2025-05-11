import 'package:app/core/ConsoleService.dart';
import 'package:app/core/Engine.dart';
import 'package:app/core/NodeGraph.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/core/widgets/logic_block_widget.dart';
import 'package:app/utils/pair.dart';
import 'package:app/utils/user_position_utils.dart';
import 'package:app/viewmodels/block_factory.dart';
import 'package:app/viewmodels/logic_block.dart';
import 'package:app/viewmodels/start_block.dart';
import 'package:flutter/material.dart';

import '../core/Pins/Pin.dart';
import '../core/abstracts/Node.dart';
import '../core/widgets/assignment_widget.dart';
import '../core/widgets/start_block_widget.dart';
import '../utils/background_painter.dart';
import '../utils/bezier_line_painter.dart';
import '../viewmodels/assignment_block.dart';
import 'package:app/design/widgets/widgets.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => TestScreenState();
}

class TestScreenState extends State<TestScreen> {
  final List<AssignmentBlock> assignmentBlocks = [];
  final List<LogicBlock> logicBlocks = [];
  var startBlock;

  final Map<String, Offset> calibrations = {};

  late NodeGraph nodeGraph = NodeGraph();
  final ConsoleService consoleService = new ConsoleService();
  late Engine engine = Engine();
  late VariableRegistry registry = VariableRegistry();

  final List<Pair> wiredBlocks = [];
  var temp;

  void addAssignmentBlock(AssignmentBlock block) {
    setState(() {
      assignmentBlocks.add(block);
      nodeGraph.addNode(block.node as Node);
    });
  }

  void addLogicBlock(LogicBlock block) {
    setState(() {
      logicBlocks.add(block);
      nodeGraph.addNode(block.node as Node);
    });
  }

  void addStartBlock() {
    setState(() {
      startBlock = BlockFactory.createStartBlock(_transformationController);
      nodeGraph.addNode(startBlock.node);
    });
  }

  List<Block> blocks = [];

  void makeConnection(Node first, Node second) {
    String firstNodeId = first.id;
    String secondNodeId = second.id;
    Pin firstPin = first.outputs.where((p) => p.id == 'exec_out').first;
    Pin secondPin = second.inputs.where((p) => p.id == 'exec_in').first;
    nodeGraph.connect(firstNodeId, firstPin.id, secondNodeId, secondPin.id);
  }

  void deleteNode(String nodeId) {
    nodeGraph.deleteNode(nodeId);
  }

  void deleteConnection(String nodeId) {
    nodeGraph.disconnect(nodeId);
  }

  @override
  void initState() {
    super.initState();
    // initInterpreter();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserPositionUtils.centerInitialPosition(
        context,
        _transformationController,
      );
    });
    blocks = [
      Block(
          name: "Целочисленная переменная",
          action: () => addAssignmentBlock(BlockFactory.createIntBlock(_transformationController))
      ),
      Block(
          name: "Булева переменная",
          action: () => addAssignmentBlock(BlockFactory.createBoolBlock(_transformationController))
      ),
      Block(
          name: "Строковая переменная",
          action: () => addAssignmentBlock(BlockFactory.createStringBlock(_transformationController))
      ),
      Block(
          name: "Вывод",
          action: () => addLogicBlock(BlockFactory.createPrintBlock(_transformationController, consoleService))
      ),
      Block(
          name: "Старт",
          action: addStartBlock,
      ),
      Block(
          name: "Умножение",
          action: () => addLogicBlock(BlockFactory.createMultiplyBlock(_transformationController))
      ),
      Block(
          name: "Деление",
          action: () => addLogicBlock(BlockFactory.createDivisionBlock(_transformationController))
      ),
      Block(
          name: "Вычитание",
          action: () => addLogicBlock(BlockFactory.createSubtractBlock(_transformationController))
      ),
      Block(
          name: "Сложение",
          action: () => addLogicBlock(BlockFactory.createAddictionBlock(_transformationController))
      ),
      Block(
          name: "Конкатенация",
          action: () => addLogicBlock(BlockFactory.createConcatBlock(_transformationController))
      ),
    ];
  }

  final TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer(
            transformationController: _transformationController,
            constrained: false,
            minScale: 0.5,
            maxScale: 2.0,
            child: Container(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth * 10,
                minHeight: constraints.maxHeight * 3,
              ),
              color: Colors.white10,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(
                      constraints.maxWidth * 10,
                      constraints.maxHeight * 3,
                    ),
                    painter: BackgroundPainter(),
                  ),

                  if (startBlock != null) _buildStartBlock(startBlock),

                  for (var block in assignmentBlocks)
                    _buildAssignmentBlock(block),

                  for (var block in logicBlocks) _buildLogicBlock(block),

                  for (var binding in wiredBlocks)
                    CustomPaint(
                      key: ValueKey(
                        '${binding.first.nodeId}-${binding.second.nodeId}',
                      ),
                      painter: BezierLinePainter(
                        binding.first.position,
                        binding.second.position +
                            calibrations['${binding.first.nodeId}${binding.second.nodeId}']!,
                      ),
                      size: MediaQuery.of(context).size,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAssignmentBlock(AssignmentBlock block) {
    return AssignmentBlockWidget(
      key: ValueKey(block.node.id),
      block: block,
      onEditToggle: () {
        setState(() {
          block.isEditing = !block.isEditing;
        });
      },
      deleteNode: () {
        setState(() {
          assignmentBlocks.remove(block);
          wiredBlocks.removeWhere(
            (binding) =>
                binding.first.nodeId == block.node.id ||
                binding.second.nodeId == block.node.id,
          );
          deleteNode(block.nodeId);
          deleteConnection(block.nodeId);

          var keysToRemove =
          calibrations.keys
              .where((key) => key.contains(block.nodeId))
              .toList();

          for (var key in keysToRemove) {
            calibrations.remove(key);
          }
        });
      },
      onPositionChanged: (newPosition) {
        setState(() {
          block.position = newPosition;
        });
      },
      onLeftArrowClick: () {
        setState(() {
          if (temp != null) {
            makeConnection(temp.node as Node, block.node as Node);
            calibrations["${temp.nodeId}${block.nodeId}"] = Offset(0,0);
            wiredBlocks.add(Pair(temp, block));
            temp = null;
          }
        });
      },
      onRightArrowClick: () {
        setState(() {
          temp = block;
        });
      },
    );
  }

  Widget _buildLogicBlock(LogicBlock block) {
    return LogicBlockWidget(
      key: ValueKey(block.nodeId),
      block: block,
      deleteNode: () {
        setState(() {
          logicBlocks.remove(block);
          wiredBlocks.removeWhere(
            (binding) =>
                binding.first.nodeId == block.nodeId ||
                binding.second.nodeId == block.nodeId,
          );
          deleteNode(block.nodeId);
          deleteConnection(block.nodeId);

          var keysToRemove =
              calibrations.keys
                  .where((key) => key.contains(block.nodeId))
                  .toList();

          for (var key in keysToRemove) {
            calibrations.remove(key);
          }
        });
      },
      onPositionChanged: (newPosition) {
        setState(() {
          block.position = newPosition;
        });
      },
      onLeftArrowClick: (position) {
        setState(() {
          if (temp != null) {
            makeConnection(temp.node as Node, block.node as Node);
            position -= Offset(15, 20);
            calibrations["${temp.nodeId}${block.nodeId}"] = position;
            wiredBlocks.add(Pair(temp, block));
            temp = null;
          }
        });
      },
      onRightArrowClick: () {
        setState(() {
          temp = block;
        });
      },
    );
  }

  Widget _buildStartBlock(StartBlock block) {
    return StartBlockWidget(
      key: ValueKey(block.nodeId),
      block: block,
      deleteNode: () {
        setState(() {
          startBlock = null;
          wiredBlocks.removeWhere(
            (binding) =>
                binding.first.nodeId == block.nodeId ||
                binding.second.nodeId == block.nodeId,
          );
          deleteNode(block.nodeId);
          deleteConnection(block.nodeId);

          var keysToRemove =
          calibrations.keys
              .where((key) => key.contains(block.nodeId))
              .toList();

          for (var key in keysToRemove) {
            calibrations.remove(key);
          }
        });
      },
      onPositionChanged: (newPosition) {
        setState(() {
          block.position = newPosition;
        });
      },
      onLeftArrowClick: () {
        setState(() {
          if (temp != null) {
            makeConnection(temp.node as Node, block.node as Node);
            calibrations["${temp.nodeId}${block.nodeId}"] = Offset(0,0);
            wiredBlocks.add(Pair(temp, block));
            temp = null;
          }
        });
      },
      onRightArrowClick: () {
        setState(() {
          temp = block;
        });
      },
    );
  }
}
