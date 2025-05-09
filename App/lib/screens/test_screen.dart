import 'package:app/core/Engine.dart';
import 'package:app/core/NodeGraph.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/core/widgets/logic_block_widget.dart';
import 'package:app/utils/pair.dart';
import 'package:app/utils/user_position_utils.dart';
import 'package:app/viewmodels/assignment_block_factory.dart';
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

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final List<AssignmentBlock> assignmentBlocks = [];
  final List<LogicBlock> logicBlocks = [];
  var startBlock;

  late NodeGraph nodeGraph = NodeGraph();
  late Engine engine = Engine();
  late VariableRegistry registry = VariableRegistry();

  final List<Pair> wiredBlocks = [];
  var temp;

  void addIntBlock() {
    setState(() {
      var block = BlockFactory.createIntBlock(_transformationController);
      assignmentBlocks.add(block);
      nodeGraph.addNode(block.node as Node);
    });
  }

  void addBoolBlock() {
    setState(() {
      var block = BlockFactory.createBoolBlock(_transformationController);
      assignmentBlocks.add(block);
      nodeGraph.addNode(block.node as Node);
    });
  }

  void addStringBlock() {
    setState(() {
      var block = BlockFactory.createStringBlock(_transformationController);
      assignmentBlocks.add(block);
      nodeGraph.addNode(block.node as Node);
    });
  }

  void addPrintBlock() {
    setState(() {
      var block = BlockFactory.createPrintBlock(_transformationController);
      logicBlocks.add(block);
      nodeGraph.addNode(block.node);
    });
  }

  void addStartBlock() {
    setState(() {
      startBlock = BlockFactory.createStartBlock(_transformationController);
      nodeGraph.addNode(startBlock.node);
    });
  }

  void makeConnection(Node first, Node second) {
    String firstNodeId = first.id;
    String secondNodeId = second.id;
    Pin firstPin = first.outputs
        .where((p) => p.id == 'exec_out').first;
    Pin secondPin = second.inputs
        .where((p) => p.id == 'exec_in').first;
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

                  if(startBlock != null)
                    _buildStartBlock(startBlock),

                  for (var block in assignmentBlocks)
                    _buildAssignmentBlock(block),

                  for(var block in logicBlocks)
                    _buildLogicBlock(block),

                  for (var binding in wiredBlocks)
                    CustomPaint(
                      key: ValueKey(
                        '${binding.first.nodeId}-${binding.second.nodeId}',
                      ),
                      painter: BezierLinePainter(
                        binding.first.position,
                        binding.second.position,
                      ),
                      size: MediaQuery.of(context).size,
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: addIntBlock,
            child: const Icon(Icons.access_alarm),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: addBoolBlock,
            child: const Icon(Icons.add),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: addStringBlock,
            child: const Icon(Icons.account_tree),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: addPrintBlock,
            child: const Icon(Icons.add_call),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: addStartBlock,
            child: const Icon(Icons.ac_unit),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => engine.run(nodeGraph, registry),
            child: const Icon(Icons.adb),
          ),
        ],
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
          wiredBlocks.removeWhere((binding) =>
          binding.first.nodeId == block.node.id ||
              binding.second.nodeId == block.node.id);
          deleteNode(block.nodeId);
          deleteConnection(block.nodeId);
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
          wiredBlocks.removeWhere((binding) =>
          binding.first.nodeId == block.nodeId ||
              binding.second.nodeId == block.nodeId);
          deleteNode(block.nodeId);
          deleteConnection(block.nodeId);
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
            makeConnection(temp.node as Node, block.node);
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
          wiredBlocks.removeWhere((binding) =>
          binding.first.nodeId == block.nodeId ||
              binding.second.nodeId == block.nodeId);
          deleteNode(block.nodeId);
          deleteConnection(block.nodeId);
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
