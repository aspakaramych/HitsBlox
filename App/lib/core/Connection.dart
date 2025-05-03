class Connection {
  final String fromNodeId;
  final String toNodeId;
  final String fromPinId;
  final String toPinId;

  Connection({
    required this.fromNodeId,
    required this.fromPinId,
    required this.toNodeId,
    required this.toPinId,
  });
}
