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

  Node? getNodeById(String id){
    nodes.firstWhere((node) => node.id == id);
  }
}
