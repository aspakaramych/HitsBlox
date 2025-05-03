import 'package:app/core/NodeGraph.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class Engine {
  late NodeGraph graph;
  late VariableRegistry registry;

  Engine();

  void run(NodeGraph graph, VariableRegistry registry){
    this.graph = graph;
    this.registry = registry;

    for (var node in graph.nodes){
      if (node.inputs.isEmpty){
        startExecution(node);
        break;
      }
    }
  }

  Future<void> startExecution(Node node) async {
    await node.execute(registry, this);
  }

  Future<void> triggerConnections(Node currentNode) async{
    for (var conn in graph.connections.where((c) => c.fromNodeId == currentNode.id)){
      var nextNode = graph.getNodeById(conn.toNodeId);
      if (nextNode != null){
        await nextNode.execute(registry, this);
      }
    }
  }
}