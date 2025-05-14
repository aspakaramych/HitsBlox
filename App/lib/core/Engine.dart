import 'dart:collection';
import 'dart:math';

import 'package:app/core/NodeGraph.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/nodes/PrintNode.dart';
import 'package:app/core/nodes/StartNode.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:collection/collection.dart';

class Engine {
  late NodeGraph graph;
  late VariableRegistry registry;

  Engine();

  Future<void> run(NodeGraph nodeGraph, VariableRegistry variableRegistry) async {
    this.graph = nodeGraph;
    this.registry = variableRegistry;

    final Queue<Node> queue = Queue();
    final Set<Node> executedNodes = Set();
    final List<Node> nodesToRetry = [];

    for (var node in graph.nodes.where((n) => n is StartNode)) {
      queue.add(node);
    }

    while (queue.isNotEmpty || nodesToRetry.isNotEmpty) {
      final List<Node> currentBatch = queue.toList();
      queue.clear();

      bool progressMade = false;

      for (var node in currentBatch) {
        if (executedNodes.contains(node)) continue;

        if (node.areAllInputsReady()) {
          print('Выполняю нод: ${node.title}');
          await node.execute(registry);
          executedNodes.add(node);
          progressMade = true;

          for (var conn in graph.connections.where((c) => c.fromNodeId == node.id)) {
            var nextNode = graph.getNodeById(conn.toNodeId);
            var outputPin = node.outputs.firstWhereOrNull((p) => p.id == conn.fromPinId);
            var inputPin = nextNode?.inputs.firstWhereOrNull((p) => p.id == conn.toPinId);

            if (outputPin != null && inputPin != null) {
              inputPin.setValue(outputPin.getValue());
            }

            if (nextNode != null && !executedNodes.contains(nextNode)) {
              if (!queue.contains(nextNode)) {
                queue.add(nextNode);
              }
            }
          }
        } else {
          nodesToRetry.add(node);
          print('Нод "${node.title}" отложен — не все входные пины заполнены');
        }
      }

      queue.addAll(nodesToRetry);
      nodesToRetry.clear();

      if (!progressMade && queue.length == nodesToRetry.length) {
        print("Обнаружена блокировка. Невозможно выполнить оставшиеся ноды.");
        break;
      }

      await Future<void>.delayed(Duration(milliseconds: 100));
    }
  }

  Future<void> executeNode(Node node) async {
    if (!node.areAllInputsReady()) {
      print('Node "${node.title}" skipped: not all inputs ready');
      return;
    }

    print('Executing node: ${node.title}');
    await node.execute(registry);
    for (var conn in graph.connections.where((c) => c.fromNodeId == node.id)) {
      var nextNode = graph.getNodeById(conn.toNodeId);
      var outputPin = node.outputs.firstWhereOrNull((p) => p.id == conn.fromPinId);
      var inputPin = nextNode?.inputs.firstWhereOrNull((p) => p.id == conn.toPinId);

      if (outputPin != null && inputPin != null) {
        inputPin.setValue(outputPin.getValue());
        scheduleExecution(nextNode!);
      }
    }

    for (var conn in graph.connections.where((c) => c.fromNodeId == node.id && c.fromPinId.contains('exec_out') )) {
      var nextNode = graph.getNodeById(conn.toNodeId);
      if (nextNode != null) {
        await executeNode(nextNode);
      }
    }
  }

  void scheduleExecution(Node node) {
    Future.microtask(() => executeNode(node));
  }
}