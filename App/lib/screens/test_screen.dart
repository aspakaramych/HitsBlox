import 'package:app/blocks/block_factory.dart';
import 'package:app/blocks/if_else_block.dart';
import 'package:app/blocks/logic_block.dart';
import 'package:app/blocks/print_block.dart';
import 'package:app/blocks/while_block.dart';
import 'package:app/core/ConsoleService.dart';
import 'package:app/core/Engine.dart';
import 'package:app/core/NodeGraph.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/core/widgets/if_else_block_widget.dart';
import 'package:app/core/widgets/logic_block_widget.dart';
import 'package:app/core/widgets/print_block_widget.dart';
import 'package:app/core/widgets/while_block_widget.dart';
import 'package:app/design/widgets/widgets.dart';
import 'package:app/utils/Randomizer.dart';
import 'package:app/utils/pair.dart';
import 'package:app/utils/user_position_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocks/assignment_block.dart';
import '../blocks/comment_block.dart';
import '../blocks/positioned_block.dart';
import '../core/Connection.dart';
import '../core/abstracts/Node.dart';
import '../core/pins/Pin.dart';
import '../core/widgets/assignment_widget.dart';
import '../core/widgets/comment_block_widget.dart';
import '../utils/background_painter.dart';
import '../utils/bezier_line_painter.dart';

class TestScreen extends StatefulWidget {
  String saveName = '';
  List<Block> blocks = [];

  NodeGraph nodeGraph = NodeGraph();
  ConsoleService consoleService = ConsoleService();
  Engine engine = Engine();
  VariableRegistry registry = VariableRegistry();

  List<AssignmentBlock> assignmentBlocks = [];
  List<LogicBlock> logicBlocks = [];
  List<PrintBlock> printBlocks = [];
  List<IfElseBlock> ifElseBlocks = [];
  List<WhileBlock> whileBlocks = [];
  List<CommentBlock> commentBlocks = [];

  Map<String, Offset> calibrations = {};
  Map<String, Offset> outputCalibrations = {};

  List<Pair> wiredBlocks = [];

  TestScreen({super.key});

  Map<String, dynamic> saveScreenState() {
    return {
      'assignmentBlocks': assignmentBlocks.map((b) => b.toJson()).toList(),
      'logicBlocks': logicBlocks.map((b) => b.toJson()).toList(),
      'printBlocks': printBlocks.map((b) => b.toJson()).toList(),
      'ifElseBlocks': ifElseBlocks.map((b) => b.toJson()).toList(),
      'whileBlocks': whileBlocks.map((b) => b.toJson()).toList(),
      'commentBlocks': commentBlocks.map((b) => b.toJson()).toList(),
      'wiredBlocks': wiredBlocks.map((p) => p.toJson()).toList(),
      'calibrations': calibrations.map(
        (key, value) => MapEntry(key, {'dx': value.dx, 'dy': value.dy}),
      ),
      'outputCalibrations': outputCalibrations.map(
        (key, value) => MapEntry(key, {'dx': value.dx, 'dy': value.dy}),
      ),
      'nodeGraph': nodeGraph.toJson(),
    };
  }

  void loadFromJson(Map<String, dynamic> screenJson) {
    assignmentBlocks =
        screenJson['assignmentBlocks']
            .map<AssignmentBlock>((block) => AssignmentBlock.fromJson(block))
            .toList();
    logicBlocks =
        screenJson['logicBlocks']
            .map<LogicBlock>((block) => LogicBlock.fromJson(block))
            .toList();
    printBlocks =
        screenJson['printBlocks']
            .map<PrintBlock>(
              (block) => PrintBlock.fromJson(block, registry, consoleService),
            )
            .toList();
    ifElseBlocks =
        screenJson['ifElseBlocks']
            .map<IfElseBlock>((block) => IfElseBlock.fromJson(block))
            .toList();
    whileBlocks =
        screenJson['whileBlocks']
            .map<WhileBlock>((block) => WhileBlock.fromJson(block))
            .toList();
    commentBlocks =
        screenJson['commentBlocks']
            .map<CommentBlock>((block) => CommentBlock.fromJson(block))
            .toList();
    wiredBlocks =
        screenJson['wiredBlocks']
            .map<Pair>((block) => Pair.fromJson(block))
            .toList();
    calibrations =
        ((screenJson['calibrations'] as Map<String, dynamic>)?.map((
              key,
              value,
            ) {
              final dx = value['dx'] as double? ?? 0.0;
              final dy = value['dy'] as double? ?? 0.0;
              return MapEntry(key, Offset(dx, dy));
            }) ??
            <String, Offset>{});
    outputCalibrations =
        ((screenJson['outputCalibrations'] as Map<String, dynamic>)?.map((
              key,
              value,
            ) {
              final dx = value['dx'] as double? ?? 0.0;
              final dy = value['dy'] as double? ?? 0.0;
              return MapEntry(key, Offset(dx, dy));
            }) ??
            <String, Offset>{});
    nodeGraph = NodeGraph.fromJson(screenJson['nodeGraph'], consoleService);
    refillWiredBlocks();
  }

  void refillNodeGraph(Map<String, dynamic> json) {
    List<Node> nodes = [];
    List<Connection> connections =
        json['connections']
            .map<Connection>((con) => Connection.fromJson(con))
            .toList();

    nodeGraph = NodeGraph.from(nodes, connections);
  }

  void refillWiredBlocks() {
    List<Pair> newWiredBlocks = [];
    for (int i = 0; i < wiredBlocks.length; i++) {
      var oldFirst = wiredBlocks[i].first;
      var oldSecond = wiredBlocks[i].second;
      PositionedBlock? newFirst = findPositionedBlock(oldFirst.nodeId);
      PositionedBlock? newSecond = findPositionedBlock(oldSecond.nodeId);
      newWiredBlocks.add(Pair(newFirst!, newSecond!));
    }

    wiredBlocks = newWiredBlocks;
  }

  PositionedBlock? findPositionedBlock(String nodeId) {
    for (var block in assignmentBlocks) {
      if (block.nodeId == nodeId) {
        return block;
      }
    }
    for (var block in logicBlocks) {
      if (block.nodeId == nodeId) {
        return block;
      }
    }
    for (var block in printBlocks) {
      if (block.nodeId == nodeId) {
        return block;
      }
    }
    for (var block in ifElseBlocks) {
      if (block.nodeId == nodeId) {
        return block;
      }
    }
    for (var block in whileBlocks) {
      if (block.nodeId == nodeId) {
        return block;
      }
    }
    return null;
  }

  void clear() {
    nodeGraph = NodeGraph();
    consoleService = ConsoleService();
    engine = Engine();
    registry = VariableRegistry();

    assignmentBlocks = [];
    logicBlocks = [];
    printBlocks = [];
    ifElseBlocks = [];
    whileBlocks = [];
    commentBlocks = [];

    calibrations = {};
    outputCalibrations = {};

    wiredBlocks = [];
  }

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen>
    with AutomaticKeepAliveClientMixin {
  var temp;
  var currOutputCalibration;

  void addAssignmentBlock(AssignmentBlock block) {
    setState(() {
      widget.assignmentBlocks.add(block);
      widget.nodeGraph.addNode(block.node as Node);
    });
  }

  void addLogicBlock(LogicBlock block) {
    setState(() {
      widget.logicBlocks.add(block);
      widget.nodeGraph.addNode(block.node as Node);
    });
  }

  void addIfElseBlock(IfElseBlock block) {
    setState(() {
      widget.ifElseBlocks.add(block);
      widget.nodeGraph.addNode(block.node as Node);
    });
  }

  void addWhileBlock(WhileBlock block) {
    setState(() {
      widget.whileBlocks.add(block);
      widget.nodeGraph.addNode(block.node as Node);
    });
  }

  void addCommentBlock(CommentBlock block) {
    setState(() {
      widget.commentBlocks.add(block);
      widget.nodeGraph.addNode(block.node as Node);
    });
  }

  void addPrintBlock(PrintBlock block) {
    setState(() {
      widget.printBlocks.add(block);
      widget.nodeGraph.addNode(block.node as Node);
    });
  }

  void makeConnection(Node first, Node second) {
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

    widget.nodeGraph.nodes.firstWhere((n) => n.id == first.id).addOutput(outputPin);
    widget.nodeGraph.nodes.firstWhere((n) => n.id == second.id).addInput(inputPin);

    widget.nodeGraph.connect(first.id, outputPin.id, second.id, inputPin.id);
  }

  void deleteNode(String nodeId) {
    widget.nodeGraph.deleteNode(nodeId);
  }

  void deleteConnection(String nodeId) {
    widget.nodeGraph.disconnect(nodeId);
  }

  void deleteConnectionBetween(String firstNode, String secondNode, Node first, Node second) {
    widget.nodeGraph.deleteConnectionBetweenNodes(firstNode, secondNode, first, second);
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
    widget.blocks = [
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

  final TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
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
                minHeight: constraints.maxHeight * 10,
              ),
              color: Colors.white10,
              child: Stack(
                // clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(
                      constraints.maxWidth * 10,
                      constraints.maxHeight * 10,
                    ),
                    painter: BackgroundPainter(),
                  ),

                  for (var block in widget.assignmentBlocks)
                    _buildAssignmentBlock(block),

                  for (var block in widget.logicBlocks) _buildLogicBlock(block),

                  for (var block in widget.printBlocks) _buildPrintBlock(block),

                  for (var block in widget.ifElseBlocks)
                    _buildIfElseBlock(block),

                  for (var block in widget.whileBlocks)
                    _buildWhileBlock(block),

                  for (var block in widget.commentBlocks)
                    _buildCommentBlock(block),

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

          deleteKey(block.nodeId);
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
            if (widget.calibrations.containsKey(
              "${temp.nodeId}${block.nodeId}",
            )) {
              widget.wiredBlocks.removeWhere(
                    (binding) =>
                binding.first.nodeId == temp.nodeId &&
                    binding.second.nodeId == block.nodeId,
              );

              deleteConnectionBetween(temp.nodeId, block.nodeId, temp.node, block.node);

              widget.calibrations.remove("${temp.nodeId}${block.nodeId}");
              widget.outputCalibrations.remove("${temp.nodeId}${block.nodeId}");

              temp = null;
              return;
            }

            makeConnection(temp.node as Node, block.node as Node);
            widget.calibrations["${temp.nodeId}${block.nodeId}"] = Offset(
              0,
              60,
            );
            if (currOutputCalibration != null) {
              widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                  currOutputCalibration;
            } else {
              widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                  Offset(0, 0);
              ;
            }
            widget.wiredBlocks.add(Pair(temp, block));
            temp = null;
            currOutputCalibration = null;
          }
        });
      },
      onRightArrowClick: () {
        setState(() {
          temp = block;
          currOutputCalibration = Offset(block.width, block.height / 2 + 15);
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

          deleteKey(block.nodeId);
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
            if (widget.calibrations.containsKey(
              "${temp.nodeId}${block.nodeId}",
            )) {
              widget.wiredBlocks.removeWhere(
                    (binding) =>
                binding.first.nodeId == temp.nodeId &&
                    binding.second.nodeId == block.nodeId,
              );

              deleteConnectionBetween(temp.nodeId, block.nodeId, temp.node, block.node);

              widget.calibrations.remove("${temp.nodeId}${block.nodeId}");
              widget.outputCalibrations.remove("${temp.nodeId}${block.nodeId}");

              temp = null;
              return;
            }

            makeConnection(temp.node as Node, block.node as Node);
            widget.calibrations["${temp.nodeId}${block.nodeId}"] = Offset(
              0,
              position.dy + 10,
            );

            if (currOutputCalibration != null) {
              widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                  currOutputCalibration;
            } else {
              widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                  Offset(0, 0);
            }

            widget.wiredBlocks.add(Pair(temp, block));

            temp = null;
            currOutputCalibration = null;
          }
        });
      },
      onRightArrowClick: () {
        setState(() {
          temp = block;
          currOutputCalibration = Offset(block.width, block.height / 2 + 15);
        });
      },
    );
  }

  Widget _buildPrintBlock(PrintBlock block) {
    return PrintBlockWidget(
      key: ValueKey(block.node.id),
      block: block,
      onEditToggle: () {
        setState(() {
          block.isEditing = !block.isEditing;
        });
      },
      deleteNode: () {
        setState(() {
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

          deleteKey(block.nodeId);
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
            if (widget.calibrations.containsKey(
              "${temp.nodeId}${block.nodeId}",
            )) {
              widget.wiredBlocks.removeWhere(
                    (binding) =>
                binding.first.nodeId == temp.nodeId &&
                    binding.second.nodeId == block.nodeId,
              );

              deleteConnectionBetween(temp.nodeId, block.nodeId, temp.node, block.node);

              widget.calibrations.remove("${temp.nodeId}${block.nodeId}");
              widget.outputCalibrations.remove("${temp.nodeId}${block.nodeId}");

              temp = null;
              return;
            }
            makeConnection(temp.node as Node, block.node as Node);
            widget.calibrations["${temp.nodeId}${block.nodeId}"] = Offset(0, block.height/2 + 15);
            if (currOutputCalibration != null) {
              widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                  currOutputCalibration;
            } else {
              widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                  Offset(0, 0);
            }
            widget.wiredBlocks.add(Pair(temp, block));
            temp = null;
            currOutputCalibration = null;
          }
        });
      },
      onRightArrowClick: () {
        setState(() {
          temp = block;
          currOutputCalibration = Offset(block.width, block.height / 2 + 15);
        });
      },
    );
  }

  Widget _buildIfElseBlock(IfElseBlock block) {
    return IfElseBlockWidget(
      key: ValueKey(block.nodeId),
      block: block,
      deleteNode: () {
        setState(() {
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

          deleteKey(block.nodeId);
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
            if (widget.calibrations.containsKey(
              "${temp.nodeId}${block.nodeId}",
            )) {
              widget.wiredBlocks.removeWhere(
                    (binding) =>
                binding.first.nodeId == temp.nodeId &&
                    binding.second.nodeId == block.nodeId,
              );

              deleteConnectionBetween(temp.nodeId, block.nodeId, temp.node, block.node);

              widget.calibrations.remove("${temp.nodeId}${block.nodeId}");
              widget.outputCalibrations.remove("${temp.nodeId}${block.nodeId}");

              temp = null;
              return;
            }
            makeConnection(temp.node as Node, block.node as Node);
            widget.calibrations["${temp.nodeId}${block.nodeId}"] =
                Offset(0, position.dy + 5);

            if (currOutputCalibration != null) {
              widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                  currOutputCalibration;
            } else {
              widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                  Offset(0, 0);
              ;
            }
            widget.wiredBlocks.add(Pair(temp, block));
            temp = null;
            currOutputCalibration = null;
          }
        });
      },
      onRightArrowClick: (position) {
        setState(() {
          temp = block;
          currOutputCalibration = Offset(block.width, position.dy + 10);
        });
      },
    );
  }

  Widget _buildWhileBlock(WhileBlock block) {
    return WhileBlockWidget(
      key: ValueKey(block.nodeId),
      block: block,
      onEditToggle: () {
        setState(() {
          block.isEditing = !block.isEditing;
        });
      },
      deleteNode: () {
        setState(() {
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

          deleteKey(block.nodeId);
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
            if (widget.calibrations.containsKey(
              "${temp.nodeId}${block.nodeId}",
            )) {
              widget.wiredBlocks.removeWhere(
                    (binding) =>
                binding.first.nodeId == temp.nodeId &&
                    binding.second.nodeId == block.nodeId,
              );

              deleteConnectionBetween(temp.nodeId, block.nodeId, temp.node, block.node);

              widget.calibrations.remove("${temp.nodeId}${block.nodeId}");
              widget.outputCalibrations.remove("${temp.nodeId}${block.nodeId}");

              temp = null;
              return;
            }
            makeConnection(temp.node as Node, block.node as Node);
            widget.calibrations["${temp.nodeId}${block.nodeId}"] =
                Offset(0, 55);

            if (currOutputCalibration != null) {
              widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                  currOutputCalibration;
            } else {
              widget.outputCalibrations["${temp.nodeId}${block.nodeId}"] =
                  Offset(0, 0);
              ;
            }
            widget.wiredBlocks.add(Pair(temp, block));
            temp = null;
            currOutputCalibration = null;
          }
        });
      },
      onRightArrowClick: (position) {
        setState(() {
          temp = block;
          currOutputCalibration = Offset(block.width, position.dy + 10);
        });
      },
    );
  }

  Widget _buildCommentBlock(CommentBlock block) {
    return CommentBlockWidget(
      key: ValueKey(block.nodeId),
      block: block,
      onEditToggle: () {
        setState(() {
          block.isEditing = !block.isEditing;
        });
      },
      deleteNode: () {
        setState(() {
          widget.commentBlocks.remove(block);

          deleteKey(block.nodeId);
        });
      },
      onPositionChanged: (newPosition) {
        setState(() {
          block.position = newPosition;
        });
      },
    );
  }

  void deleteKey(String nodeId) {
    var keysToRemove =
        widget.calibrations.keys.where((key) => key.contains(nodeId)).toList();

    for (var key in keysToRemove) {
      widget.calibrations.remove(key);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
