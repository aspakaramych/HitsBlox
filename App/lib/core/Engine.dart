import 'dart:collection';
import 'dart:math';

import 'package:app/core/ConsoleService.dart';
import 'package:app/core/NodeGraph.dart';
import 'package:app/core/abstracts/MyTrue.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/nodes/IfElseNode.dart';
import 'package:app/core/nodes/PrintNode.dart';
import 'package:app/core/nodes/StartNode.dart';
import 'package:app/core/nodes/WhileNode.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/core/widgets/program_processing_toast_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastify/toastify.dart';

class Engine {
  late NodeGraph graph;
  late VariableRegistry registry;

  Engine();

  Future<void> run(NodeGraph nodeGraph, VariableRegistry variableRegistry, ConsoleService console, BuildContext context) async {
    this.graph = nodeGraph;
    this.registry = variableRegistry;
    registry.Clear();

    final Queue<Node> queue = Queue();
    final Set<Node> executedNodes = Set();
    final List<Node> nodesToRetry = [];
    nodeGraph.nodes.map((el) => el.clearOutputs());
    nodeGraph.nodes.map((el) => el.clearInputs());

    for (var node in graph.nodes.where((n) => n is StartNode)) {
      queue.add(node);
    }
    if (queue.isEmpty){
      console.log("Отсутствует start node");
      _showErrorToast(context, "Отсутствует блок start");
      return;
    }

    while (queue.isNotEmpty || nodesToRetry.isNotEmpty) {
      final List<Node> currentBatch = queue.toList();
      queue.clear();

      bool progressMade = false;

      for (var node in currentBatch) {
        if (executedNodes.contains(node)) continue;

        if (node.areAllInputsReady()) {
          print('Выполняю нод: ${node.title}');
          try{
            await node.execute(registry);
          }
          catch(ex){
            console.log(ex.toString());
            _showErrorToast(context, ex.toString());
            return;
          }
          executedNodes.add(node);
          progressMade = true;

          for (var conn in graph.connections.where((c) => c.fromNodeId == node.id)) {
            var cond1 = (node is IfElseNode && node.outputs.firstWhere((p) => p.id == conn.fromPinId).getValue() is MyTrue);
            var cond2 = (node is WhileNode && node.outputs.firstWhere((p) => p.id == conn.fromPinId).getValue() is MyTrue);
            var cond3 = (node is !IfElseNode && node is !WhileNode);
            if (cond1 || cond2 || cond3){
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

    showToast(
      context,
      Toast(
        // title: 'title',
        // description: 'description'
        child: ProgramProcessingToast(
          title: 'Successful running',
          description: 'Check the console',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        ),
      ),
    );
  }

  void _showErrorToast(BuildContext context, String errorMessage) {
    showToast(
      context,
      Toast(
        // title: 'title',
        // description: 'description'
        child: ProgramProcessingToast(
          title: 'Error',
          description: errorMessage,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        ),
      ),
    );
  }
}