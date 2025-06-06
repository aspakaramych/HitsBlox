import '../blocks/positioned_block.dart';

class Pair {
  final PositionedBlock first;
  final PositionedBlock second;

  const Pair(this.first, this.second);

  Map<String, dynamic> toJson() {
    return {
      'first': PositionedBlock.toJson(first),
      'second': PositionedBlock.toJson(second),
    };
  }

  factory Pair.fromJson(Map<String, dynamic> json) {
    return Pair(
      PositionedBlock.fromJson(json['first']),
      PositionedBlock.fromJson(json['second']),
    );
  }
}
