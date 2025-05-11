import 'package:app/core/Connection.dart';
import 'package:app/core/abstracts/Node.dart';

class NodeGraph {
  final List<Node> nodes = [];
  final List<Connection> connections = [];

  void addNode(Node node){
    nodes.add(node);
  }

  void connect(String fromNodeId, String fromPinId, String toNodeId, String toPinId){
    connections.add(Connection(fromNodeId: fromNodeId, fromPinId: fromPinId, toNodeId: toNodeId, toPinId: toPinId));
  }

  void disconnect(String nodeId) {
    connections.removeWhere(
            (conn) => conn.fromNodeId == nodeId || conn.toNodeId == nodeId);
  }

  Node? getNodeById(String id){
    return nodes.firstWhere((node) => node.id == id);
  }

  void deleteNode(String nodeId) {
    nodes.removeWhere(
            (node) => node.id == nodeId);
  }
}
