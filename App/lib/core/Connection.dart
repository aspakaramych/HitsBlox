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

  Map<String, dynamic> toJson() {
    return {
      'fromNodeId': fromNodeId,
      'toNodeId': fromPinId,
      'fromPinId': toNodeId,
      'toPinId': toPinId,
    };
  }

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
        fromNodeId: json['fromNodeId'],
        fromPinId: json['fromPinId'],
        toNodeId: json['toNodeId'],
        toPinId: json['toPinId']
    );
  }
}
