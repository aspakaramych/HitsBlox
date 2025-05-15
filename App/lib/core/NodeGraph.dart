import 'package:app/core/Connection.dart';
import 'package:app/core/ConsoleService.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:collection/collection.dart';

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
    connections.add(Connection(
      fromNodeId: fromNodeId,
      fromPinId: fromPinId,
      toNodeId: toNodeId,
      toPinId: toPinId,
    ));
  }

  Node? getNodeById(String id) {
    return nodes.firstWhereOrNull((node) => node.id == id);
  }

  void deleteNode(String nodeId) {
    nodes.removeWhere((node) => node.id == nodeId);
  }

  void disconnect(String nodeId) {
    var connection = connections.firstWhereOrNull((conn) => conn.fromNodeId == nodeId || conn.toNodeId == nodeId);
    connections.removeWhere((conn) =>
    conn.fromNodeId == nodeId || conn.toNodeId == nodeId);
    if (connection != null){
      var nodeFrom = getNodeById(connection.fromNodeId);
      nodeFrom?.outputs.removeWhere((p) => p.id == connection.fromPinId);
      var nodeTo = getNodeById(connection.toNodeId);
      nodeTo?.inputs.removeWhere((p) => p.id == connection.toPinId);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'nodes': nodes.map((node) => node.toJson()).toList(),
      'connections': connections.map((con) => con.toJson()).toList(),
    };
  }

  factory NodeGraph.fromJson(Map<String, dynamic> json, ConsoleService consoleService) {
    return NodeGraph.from(
      json['nodes'].map<Node>((node) => (node['title'] != 'Распечатать') ? Node.fromJson(node) : PrintNode.fromJson(node, consoleService)).toList(),
      json['connections'].map<Connection>((con) => Connection.fromJson(con)).toList(),
    );
  }
}
