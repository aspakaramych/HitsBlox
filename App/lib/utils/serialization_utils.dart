import 'dart:ui';

import 'package:app/screens/test_screen.dart';
import 'package:app/utils/pair.dart';

import '../blocks/assignment_block.dart';
import '../blocks/comment_block.dart';
import '../blocks/if_else_block.dart';
import '../blocks/logic_block.dart';
import '../blocks/positioned_block.dart';
import '../blocks/print_block.dart';
import '../blocks/swap_block.dart';
import '../blocks/while_block.dart';
import '../core/Connection.dart';
import '../core/ConsoleService.dart';
import '../core/Engine.dart';
import '../core/NodeGraph.dart';
import '../core/abstracts/Node.dart';
import '../core/registry/VariableRegistry.dart';

class SerializationUtils {
  static Map<String, dynamic> saveScreenState(TestScreen widget) {
    return {
      'assignmentBlocks': widget.assignmentBlocks.map((b) => b.toJson()).toList(),
      'logicBlocks': widget.logicBlocks.map((b) => b.toJson()).toList(),
      'printBlocks': widget.printBlocks.map((b) => b.toJson()).toList(),
      'ifElseBlocks': widget.ifElseBlocks.map((b) => b.toJson()).toList(),
      'whileBlocks': widget.whileBlocks.map((b) => b.toJson()).toList(),
      'swapBlocks': widget.swapBlocks.map((b) => b.toJson()).toList(),
      'commentBlocks': widget.commentBlocks.map((b) => b.toJson()).toList(),
      'wiredBlocks': widget.wiredBlocks.map((p) => p.toJson()).toList(),
      'calibrations': widget.calibrations.map(
            (key, value) => MapEntry(key, {'dx': value.dx, 'dy': value.dy}),
      ),
      'outputCalibrations': widget.outputCalibrations.map(
            (key, value) => MapEntry(key, {'dx': value.dx, 'dy': value.dy}),
      ),
      'nodeGraph': widget.nodeGraph.toJson(),
    };
  }

  static void loadFromJson(Map<String, dynamic> screenJson, TestScreen widget) {
    widget.assignmentBlocks =
        screenJson['assignmentBlocks']
            .map<AssignmentBlock>((block) => AssignmentBlock.fromJson(block))
            .toList();
    widget.logicBlocks =
        screenJson['logicBlocks']
            .map<LogicBlock>((block) => LogicBlock.fromJson(block))
            .toList();
    widget.printBlocks =
        screenJson['printBlocks']
            .map<PrintBlock>(
              (block) => PrintBlock.fromJson(block, widget.registry, widget.consoleService),
        )
            .toList();
    widget.ifElseBlocks =
        screenJson['ifElseBlocks']
            .map<IfElseBlock>((block) => IfElseBlock.fromJson(block))
            .toList();
    widget.whileBlocks =
        screenJson['whileBlocks']
            .map<WhileBlock>((block) => WhileBlock.fromJson(block))
            .toList();
    widget.swapBlocks =
        screenJson['swapBlocks']
            .map<SwapBlock>((block) => SwapBlock.fromJson(block))
            .toList();
    widget.commentBlocks =
        screenJson['commentBlocks']
            .map<CommentBlock>((block) => CommentBlock.fromJson(block))
            .toList();
    widget.wiredBlocks =
        screenJson['wiredBlocks']
            .map<Pair>((block) => Pair.fromJson(block))
            .toList();
    widget.calibrations =
    ((screenJson['calibrations'] as Map<String, dynamic>)?.map((
        key,
        value,
        ) {
      final dx = value['dx'] as double? ?? 0.0;
      final dy = value['dy'] as double? ?? 0.0;
      return MapEntry(key, Offset(dx, dy));
    }) ??
        <String, Offset>{});
    widget.outputCalibrations =
    ((screenJson['outputCalibrations'] as Map<String, dynamic>)?.map((
        key,
        value,
        ) {
      final dx = value['dx'] as double? ?? 0.0;
      final dy = value['dy'] as double? ?? 0.0;
      return MapEntry(key, Offset(dx, dy));
    }) ??
        <String, Offset>{});
    _refillNodeGraph(screenJson['nodeGraph'], widget);
    _refillWiredBlocks(widget);
  }

  static void _refillNodeGraph(Map<String, dynamic> json, TestScreen widget) {
    List<Connection> connections =
    json['connections']
        .map<Connection>((con) => Connection.fromJson(con))
        .toList();

    widget.nodeGraph = NodeGraph.from(_refillNodes(widget), connections);
  }

  static List<Node> _refillNodes(TestScreen widget) {
    List<Node> nodes = [];

    for (var block in widget.assignmentBlocks) {
      nodes.add(block.node);
    }
    for (var block in widget.logicBlocks) {
      nodes.add(block.node);
    }
    for (var block in widget.printBlocks) {
      nodes.add(block.node);
    }
    for (var block in widget.ifElseBlocks) {
      nodes.add(block.node);
    }
    for (var block in widget.whileBlocks) {
      nodes.add(block.node);
    }
    for (var block in widget.swapBlocks) {
      nodes.add(block.node);
    }
    return nodes;
  }

  static void _refillWiredBlocks(TestScreen widget) {
    List<Pair> newWiredBlocks = [];
    for (int i = 0; i < widget.wiredBlocks.length; i++) {
      var oldFirst = widget.wiredBlocks[i].first;
      var oldSecond = widget.wiredBlocks[i].second;
      PositionedBlock? newFirst = _findPositionedBlock(oldFirst.nodeId, widget);
      PositionedBlock? newSecond = _findPositionedBlock(oldSecond.nodeId, widget);
      newWiredBlocks.add(Pair(newFirst!, newSecond!));
    }

    widget.wiredBlocks = newWiredBlocks;
  }

  static PositionedBlock? _findPositionedBlock(String nodeId, TestScreen widget) {
    for (var block in widget.assignmentBlocks) {
      if (block.nodeId == nodeId) {
        return block;
      }
    }
    for (var block in widget.logicBlocks) {
      if (block.nodeId == nodeId) {
        return block;
      }
    }
    for (var block in widget.printBlocks) {
      if (block.nodeId == nodeId) {
        return block;
      }
    }
    for (var block in widget.ifElseBlocks) {
      if (block.nodeId == nodeId) {
        return block;
      }
    }
    for (var block in widget.whileBlocks) {
      if (block.nodeId == nodeId) {
        return block;
      }
    }
    for (var block in widget.swapBlocks) {
      if (block.nodeId == nodeId) {
        return block;
      }
    }
    return null;
  }

  static void clear(TestScreen widget) {
    widget.nodeGraph = NodeGraph();
    widget.consoleService = ConsoleService();
    widget.engine = Engine();
    widget.registry = VariableRegistry();

    widget.assignmentBlocks = [];
    widget.logicBlocks = [];
    widget.printBlocks = [];
    widget.ifElseBlocks = [];
    widget.whileBlocks = [];
    widget.swapBlocks = [];
    widget.commentBlocks = [];

    widget.calibrations = {};
    widget.outputCalibrations = {};

    widget.wiredBlocks = [];
  }

}