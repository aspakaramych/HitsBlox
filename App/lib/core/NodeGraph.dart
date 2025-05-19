import 'package:app/core/Connection.dart';
import 'package:app/core/ConsoleService.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:collection/collection.dart';

import 'nodes/AssignNode.dart';
import 'nodes/PrintNode.dart';

class NodeGraph {
  List<Node> nodes = [];
  List<Connection> connections = [];

  NodeGraph();

  NodeGraph.from(this.nodes, this.connections);

  void addNode(Node node) {
    nodes.add(node);
  }

  void connect(
    String fromNodeId,
    String fromPinId,
    String toNodeId,
    String toPinId,
  ) {
    connections.add(
      Connection(
        fromNodeId: fromNodeId,
        fromPinId: fromPinId,
        toNodeId: toNodeId,
        toPinId: toPinId,
      ),
    );
  }

  Node? getNodeById(String id) {
    return nodes.firstWhereOrNull((node) => node.id == id);
  }

  void deleteNode(String nodeId) {
    nodes.removeWhere((node) => node.id == nodeId);
  }

  void disconnect(String nodeId) {
    var connection = connections.firstWhereOrNull(
      (conn) => conn.fromNodeId == nodeId || conn.toNodeId == nodeId,
    );
    connections.removeWhere(
      (conn) => conn.fromNodeId == nodeId || conn.toNodeId == nodeId,
    );
    if (connection != null) {
      var nodeFrom = getNodeById(connection.fromNodeId);
      nodeFrom?.outputs.removeWhere((p) => p.id == connection.fromPinId);
      var nodeTo = getNodeById(connection.toNodeId);
      nodeTo?.inputs.removeWhere((p) => p.id == connection.toPinId);
    }
  }

  void deleteConnectionBetweenNodes(String firstNode, String secondNode, Node first, Node second) {
    var connection = connections.firstWhereOrNull(
          (conn) => conn.fromNodeId == firstNode && conn.toNodeId == secondNode,
    );

    first.outputs.removeWhere((pin) => pin.id == connection?.fromPinId);
    second.inputs.removeWhere((pin) => pin.id == connection?.toPinId);

    connections.removeWhere(
          (conn) => conn.fromNodeId == firstNode && conn.toNodeId == secondNode,
    );
    if (connection != null) {
      var nodeFrom = getNodeById(connection.fromNodeId);
      nodeFrom?.outputs.removeWhere((p) => p.id == connection.fromPinId);
      var nodeTo = getNodeById(connection.toNodeId);
      nodeTo?.inputs.removeWhere((p) => p.id == connection.toPinId);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'nodes': nodes.map((node) => serializeToJson(node)).toList(),
      'connections': connections.map((con) => con.toJson()).toList(),
    };
  }

  static Map<String, dynamic> serializeToJson(Node node) {
    if(node is AssignNode) {
      return AssignNode.toJson_(node);
    } else if (node is PrintNode) {
      return PrintNode.toJson_(node);
    } else {
      return node.toJson();
    }
  }

  factory NodeGraph.fromJson(
    Map<String, dynamic> json,
    ConsoleService consoleService,
  ) {
    return NodeGraph.from(
      getNodesFromJson(json, consoleService),
      json['connections']
          .map<Connection>((con) => Connection.fromJson(con))
          .toList(),
    );
  }

  static List<Node> getNodesFromJson(Map<String, dynamic> json, ConsoleService consoleService) {
    List<Node> newNodes = [];
    for(var node in json['nodes']) {
      if(node['title'].contains('Присвоить') || node['title'].contains('Добавить')) {
        newNodes.add(AssignNode.fromJson(node));
      } else if(node['title'] == "Распечатать") {
        newNodes.add(PrintNode.fromJson(node, consoleService));
      } else {
        newNodes.add(Node.fromJson(node));
      }
    }

    return newNodes;
  }
}
