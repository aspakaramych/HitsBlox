import 'dart:async';
import 'dart:collection';
import 'package:app/core/console_service.dart';
import 'package:app/core/node_graph.dart';
import 'package:app/core/abstracts/my_true.dart';
import 'package:app/core/abstracts/node.dart';
import 'package:app/core/debug_console_service.dart';
import 'package:app/core/nodes/if_else_node.dart';
import 'package:app/core/nodes/start_node.dart';
import 'package:app/core/nodes/while_node.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:app/core/widgets/custom_toast.dart';
import 'package:app/utils/engine_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastify/toastify.dart';

import '../utils/selected_block_service.dart';

class ExecutionLevel {
  final Set<Node> executedNodes;
  final int iteration;
  final String? sourceNodeId;

  ExecutionLevel({
    required this.executedNodes,
    this.iteration = 0,
    this.sourceNodeId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExecutionLevel &&
              runtimeType == other.runtimeType &&
              executedNodes == other.executedNodes &&
              iteration == other.iteration &&
              sourceNodeId == other.sourceNodeId;

  @override
  int get hashCode => executedNodes.hashCode ^ iteration.hashCode ^ sourceNodeId.hashCode;
}

class ExecutionContext {
  final List<ExecutionLevel> _levels;

  ExecutionContext(this._levels);

  ExecutionLevel get currentLevel => _levels.last;

  factory ExecutionContext.global() {
    return ExecutionContext([ExecutionLevel(executedNodes: HashSet<Node>(), iteration: 0)]);
  }

  ExecutionContext enterWhileLoop(String whileNodeId, int iteration) {
    final newLevels = List<ExecutionLevel>.from(_levels);
    newLevels.add(ExecutionLevel(
      executedNodes: HashSet<Node>(),
      iteration: iteration,
      sourceNodeId: whileNodeId,
    ));
    return ExecutionContext(newLevels);
  }

  ExecutionContext exitWhileLoop() {
    if (_levels.length <= 1) {
      return this;
    }
    final newLevels = List<ExecutionLevel>.from(_levels);
    newLevels.removeLast();
    return ExecutionContext(newLevels);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExecutionContext &&
              runtimeType == other.runtimeType &&
              const ListEquality().equals(_levels, other._levels);

  @override
  int get hashCode => const ListEquality().hash(_levels);
}

class QueueItem {
  final Node node;
  final ExecutionContext context;
  QueueItem(this.node, this.context);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is QueueItem &&
              runtimeType == other.runtimeType &&
              node == other.node &&
              context == other.context;
  @override
  int get hashCode => node.hashCode ^ context.hashCode;
}

class Engine {
  late NodeGraph graph;
  late VariableRegistry registry;
  bool _debugMode = false;
  Completer<void>? _debugCompleter;
  Node? _curNode;

  Engine();


  Node? getCurNode(){
    return _curNode;
  }

  void setDebugMode(bool enable){
    _debugMode = enable;
    if (!_debugMode){
      _debugCompleter?.complete();
      _debugCompleter = null;
    }
  }

  bool getDebugMode(){
    return _debugMode;
  }

  void next(){
    _debugCompleter?.complete();
    _debugCompleter = null;
  }

  Future<void> run(
      NodeGraph nodeGraph,
      VariableRegistry variableRegistry,
      ConsoleService console,
      DebugConsoleService debugConsoleService,
      SelectedBlockService selectedBlockService,
      EngineState state,
      BuildContext context) async {
    if (_debugMode){
      CustomToast.showCustomToast(context, 'Режим debug', 'Debug активирован', Colors.grey);
    }
    else{
      CustomToast.showCustomToastWithDuration(context, 'Программа запущена', 'Идёт выполнение программы', Colors.grey, 1);
    }
    this.graph = nodeGraph;
    this.registry = variableRegistry;
    registry.Clear();
    state.setRunning(true);

    final Queue<QueueItem> queue = Queue();
    ExecutionContext currentGlobalContext = ExecutionContext.global();

    final Map<String, int> whileNodeTotalIterations = {};

    nodeGraph.nodes.forEach((el) {
      el.clearOutputs();
      el.clearInputs();
    });

    for (var node in graph.nodes){
      if (node.inputs.length == 0 && node is !StartNode){
        console.log("Ноды должны быть соединены со стартом");
        CustomToast.showCustomToast(context, 'Ошибка', "Ноды должны быть соединены со стартом", Colors.red);
        return;
      }
    }

    for (var node in graph.nodes.where((n) => n is StartNode)) {
      queue.add(QueueItem(node, currentGlobalContext));
    }
    if (queue.isEmpty){
      console.log("Отсутствует start node");
      CustomToast.showCustomToast(context, 'Ошибка', "Отсутствует блок start", Colors.red);
      return;
    }

    bool progressMadeInThisIteration;

    while (queue.isNotEmpty) {
      if (!state.getAreRunning()){
        CustomToast.showCustomToast(context, 'Программа остановлена', 'Программа остановлена', Colors.grey);
        return;
      }
      final List<QueueItem> currentBatch = queue.toList();
      queue.clear();

      progressMadeInThisIteration = false;

      for (var item in currentBatch) {
        final Node node = item.node;
        if (_debugMode){
          _debugCompleter = Completer<void>();
          console.clear();
          var registerStr = registry.toString();
          debugConsoleService.clear();
          debugConsoleService.log(registerStr);
          _curNode = node;
          selectedBlockService.add(_curNode!);
          // print(_curNode);
          await _debugCompleter!.future;
        }
        final ExecutionContext nodeExecutionContext = item.context;
        final ExecutionLevel currentLevel = nodeExecutionContext.currentLevel;
        if (currentLevel.executedNodes.contains(node)) {
          print('Нод "${node.title}" (контекст итерации: ${currentLevel.iteration}, уровень: ${nodeExecutionContext._levels.length}) уже выполнен на текущем уровне, пропускаем.');
          continue;
        }

        if (node.areAllInputsReady()) {
          print('Выполняю нод: ${node.title} (контекст итерации: ${currentLevel.iteration}, уровень: ${nodeExecutionContext._levels.length})');
          try {
            await node.execute(registry);

            progressMadeInThisIteration = true;
            currentLevel.executedNodes.add(node);

            for (var conn in graph.connections.where((c) => c.fromNodeId == node.id)) {
              var nextNode = graph.getNodeById(conn.toNodeId);
              if (nextNode == null) continue;

              var outputPin = node.outputs.firstWhereOrNull((p) => p.id == conn.fromPinId);
              var inputPin = nextNode.inputs.firstWhereOrNull((p) => p.id == conn.toPinId);

              if (outputPin != null && inputPin != null) {
                inputPin.setValue(outputPin.getValue());
              }

              ExecutionContext nextExecutionContext = nodeExecutionContext;

              if (node is WhileNode) {

                if (outputPin?.id == node.outputs[0].id) {
                  int nextIteration = (whileNodeTotalIterations[node.id] ?? 0) + 1;
                  whileNodeTotalIterations[node.id] = nextIteration;

                  nextExecutionContext = nodeExecutionContext.enterWhileLoop(node.id, nextIteration);
                  nextNode.clearInputs();
                  nextNode.clearOutputs();

                } else if (outputPin?.id == node.outputs[1].id) {
                  nextExecutionContext = nodeExecutionContext.exitWhileLoop();
                  whileNodeTotalIterations.remove(node.id);
                }
              }
              var proceedBasedOnValue = outputPin?.getValue() is MyTrue;
              var isStandardNode = (node is! IfElseNode && node is! WhileNode);

              if (proceedBasedOnValue || isStandardNode) {
                bool alreadyInQueue = queue.contains(QueueItem(nextNode, nextExecutionContext));
                bool alreadyExecutedInItsLevel = nextExecutionContext.currentLevel.executedNodes.contains(nextNode);

                if (!alreadyInQueue && !alreadyExecutedInItsLevel) {
                  queue.add(QueueItem(nextNode, nextExecutionContext));
                } else {

                }
              }
            }

          } catch (ex) {
            console.log(ex.toString());
            CustomToast.showCustomToast(context, 'Ошибка', ex.toString(), Colors.red);
            return;
          }
        } else {
          queue.add(item);
          print('Нод "${node.title}" (контекст итерации: ${currentLevel.iteration}, уровень: ${nodeExecutionContext._levels.length}) отложен — не все входные пины заполнены');
        }
      }

      if (!progressMadeInThisIteration && queue.isNotEmpty) {
        print("Обнаружена блокировка. Невозможно выполнить оставшиеся ноды.");
        console.log("Обнаружена блокировка. Невозможно выполнить оставшиеся ноды.");
        CustomToast.showCustomToast(context, 'Ошибка', "Программа заблокирована: не все узлы могут быть выполнены.", Colors.green);
        break;
      }
      if (!_debugMode){
        await Future<void>.delayed(Duration(milliseconds: 100));
      }

    }

    if (queue.isEmpty) {
      state.setRunning(false);
      CustomToast.showCustomToast(context, 'Успех', 'Программа выполнена успешно', Colors.green);
      selectedBlockService.clear();
    }
  }
}