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

    for (var node in graph.nodes) {
      if (node is StartNode) {
        await executeNode(node);
        break;
      }
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