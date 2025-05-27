import 'package:app/blocks/if_else_block.dart';
import 'package:app/blocks/logic_block.dart';
import 'package:app/blocks/print_block.dart';
import 'package:app/blocks/swap_block.dart';
import 'package:app/blocks/while_block.dart';
import 'package:app/core/ConsoleService.dart';
import 'package:app/core/Engine.dart';
import 'package:app/core/NodeGraph.dart';
import 'package:app/core/debug_console_service.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/core/widgets/widget_builder.dart';
import 'package:app/design/widgets/widgets.dart';
import 'package:app/utils/Randomizer.dart';
import 'package:app/utils/pair.dart';
import 'package:app/utils/selected_block_service.dart';
import 'package:app/utils/user_position_utils.dart';
import 'package:flutter/material.dart';

import '../blocks/assignment_block.dart';
import '../blocks/block_service.dart';
import '../blocks/comment_block.dart';
import '../core/abstracts/Node.dart';
import '../core/pins/Pin.dart';
import '../utils/background_painter.dart';
import '../utils/bezier_line_painter.dart';

class TestScreen extends StatefulWidget {
  String saveName = '';
  Map<String, List<Block>> blocks = {};

  NodeGraph nodeGraph = NodeGraph();
  ConsoleService consoleService = ConsoleService();
  DebugConsoleService debugConsoleService = DebugConsoleService();
  SelectedBlockService selectedBlockService = SelectedBlockService();
  Engine engine = Engine();
  VariableRegistry registry = VariableRegistry();

  List<AssignmentBlock> assignmentBlocks = [];
  List<LogicBlock> logicBlocks = [];
  List<PrintBlock> printBlocks = [];
  List<IfElseBlock> ifElseBlocks = [];
  List<WhileBlock> whileBlocks = [];
  List<SwapBlock> swapBlocks = [];
  List<CommentBlock> commentBlocks = [];

  Map<String, Offset> calibrations = {};
  Map<String, Offset> outputCalibrations = {};

  List<Pair> wiredBlocks = [];

  TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen>
    with AutomaticKeepAliveClientMixin {
  var temp;
  var currOutputCalibration;

  final TransformationController _transformationController =
      TransformationController();
  late BlockService _blockService;
  late TestScreenWidgetBuilder _widgetBuilder;

  void makeConnection(Node first, Node second, int index, bool isLogicBlock) {
    String newOutputPinId = 'exec_out_${Randomizer.getRandomInt()}';
    String newInputPinId = 'exec_in_${Randomizer.getRandomInt()}';

    final outputPin = Pin(
      id: newOutputPinId,
      name: 'Exec Out',
      isInput: false,
      isExecutionPin: true,
    );

    final inputPin = Pin(
      id: newInputPinId,
      name: 'Exec In',
      isInput: true,
      isExecutionPin: true,
    );

    widget.nodeGraph.nodes
        .firstWhere((n) => n.id == first.id)
        .addOutput(outputPin);
    if(isLogicBlock) {
      widget.nodeGraph.nodes
          .firstWhere((n) => n.id == second.id)
          .addInputOnIndex(inputPin, index);
    } else {
      widget.nodeGraph.nodes
          .firstWhere((n) => n.id == second.id)
          .addInput(inputPin);
    }

    widget.nodeGraph.connect(first.id, outputPin.id, second.id, inputPin.id);
  }

  void deleteNode(String nodeId) {
    widget.nodeGraph.deleteNode(nodeId);
  }

  void deleteConnection(String nodeId) {
    widget.nodeGraph.disconnect(nodeId);
  }

  void deleteConnectionBetween(
    String firstNode,
    String secondNode,
    Node first,
    Node second,
  ) {
    widget.nodeGraph.deleteConnectionBetweenNodes(
      firstNode,
      secondNode,
      first,
      second,
    );
  }

  void deleteCalibrations(String nodeId) {
    var keysToRemove =
    widget.calibrations.keys.where((key) => key.contains(nodeId)).toList();

    for (var key in keysToRemove) {
      widget.calibrations.remove(key);
    }
  }

  void refreshUI() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    super.build(context);
    // initInterpreter();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserPositionUtils.centerInitialPosition(
        context,
        _transformationController,
      );
    });
    _blockService = BlockService(widget, refreshUI);
    _widgetBuilder = TestScreenWidgetBuilder(widget, refreshUI, deleteNode, deleteConnection, deleteConnectionBetween, deleteCalibrations, makeConnection, temp, currOutputCalibration);
    widget.blocks = _blockService.getBlocks(_transformationController);
    widget.selectedBlockService.addListener(refreshUI);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer(
            transformationController: _transformationController,
            constrained: false,
            minScale: 0.5,
            maxScale: 2.0,
            child: Container(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth * 10,
                minHeight: constraints.maxHeight * 10,
              ),
              color: Theme.of(context).colorScheme.surface,
              child: Stack(
                // clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(
                      constraints.maxWidth * 10,
                      constraints.maxHeight * 10,
                    ),
                    painter: BackgroundPainter(context: context),
                  ),

                  for (var block in widget.assignmentBlocks)
                    _widgetBuilder.buildAssignmentBlock(block),

                  for (var block in widget.logicBlocks)
                    _widgetBuilder.buildLogicBlock(block),

                  for (var block in widget.printBlocks)
                    _widgetBuilder.buildPrintBlock(block),

                  for (var block in widget.ifElseBlocks)
                    _widgetBuilder.buildIfElseBlock(block),

                  for (var block in widget.whileBlocks)
                    _widgetBuilder.buildWhileBlock(block),

                  for (var block in widget.swapBlocks)
                    _widgetBuilder.buildSwapBlock(block),

                  for (var block in widget.commentBlocks)
                    _widgetBuilder.buildCommentBlock(block),

                  for (var binding in widget.wiredBlocks)
                    CustomPaint(
                      key: ValueKey(
                        '${binding.first.nodeId}-${binding.second.nodeId}}',
                      ),
                      painter: BezierLinePainter(
                        binding.first.position +
                            widget
                                .outputCalibrations['${binding.first.nodeId}${binding.second.nodeId}']!,
                        binding.second.position +
                            widget
                                .calibrations['${binding.first.nodeId}${binding.second.nodeId}']!,
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

  @override
  bool get wantKeepAlive => true;
}
