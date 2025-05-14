import 'package:app/core/Connection.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:collection/collection.dart';

class NodeGraph {
  final List<Node> nodes = [];
  final List<Connection> connections = [];

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
    return nodes.firstWhere((node) => node.id == id);
  }

  void deleteNode(String nodeId) {
    nodes.removeWhere((node) => node.id == nodeId);
  }

  void disconnect(String nodeId) {
    //TODO: добавить проверку на null
    // var connection = connections.firstWhere((conn) => conn.fromNodeId == nodeId || conn.toNodeId == nodeId);
    connections.removeWhere((conn) =>
    conn.fromNodeId == nodeId || conn.toNodeId == nodeId);
    // var nodeFrom = getNodeById(connection.fromNodeId);
    // nodeFrom?.outputs.removeWhere((p) => p.id == connection.fromPinId);
    // var nodeTo = getNodeById(connection.toNodeId);
    // nodeTo?.inputs.removeWhere((p) => p.id == connection.toPinId);
  }
}
