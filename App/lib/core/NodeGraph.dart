import 'package:app/core/Connection.dart';
import 'package:app/core/ConsoleService.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/nodes/WhileNode.dart';
import 'package:app/core/pins/EmptyPin.dart';
import 'package:collection/collection.dart';

import 'nodes/AssignNode.dart';
import 'nodes/PrintNode.dart';
import 'nodes/SwapNode.dart';

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



    connections.removeWhere(
          (conn) => conn.fromNodeId == firstNode && conn.toNodeId == secondNode,
    );
    if (connection != null) {
      var nodeFrom = getNodeById(connection.fromNodeId);
      final indexFrom = nodeFrom?.outputs.indexWhere((p) => p.id == connection.fromPinId);
      if (indexFrom != null && indexFrom >= 0) {
        nodeFrom?.outputs[indexFrom] = EmptyPin();
      }
      var nodeTo = getNodeById(connection.toNodeId);
      final indexTo = nodeTo?.inputs.indexWhere((p) => p.id == connection.toPinId);
      if (indexTo != null && indexTo >= 0) {
        nodeTo?.inputs[indexTo] = EmptyPin();
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'nodes': nodes.map((node) => serializeToJson(node)).toList(),
      'connections': connections.map((con) => con.toJson()).toList(),
    };
  }

  static Map<String, dynamic> serializeToJson(Node node) {
    if(node is WhileNode) {
      return WhileNode.toJson_(node);
    } else if(node is AssignNode) {
      return AssignNode.toJson_(node);
    }  else if(node is SwapNode) {
      return SwapNode.toJson_(node);
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
      if(node['title'].contains('while')) {
        newNodes.add(WhileNode.fromJson(node));
      } else if(node['title'] == "Swap") {
        newNodes.add(SwapNode.fromJson(node));
      } else if(node['title'].contains('Присвоить') || node['title'].contains('Добавить') || node['title'] == "Инкремент") {
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
