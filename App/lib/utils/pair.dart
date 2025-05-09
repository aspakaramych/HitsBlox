import '../viewmodels/positioned_block.dart';

class Pair<T1 extends PositionedBlock, T2 extends PositionedBlock> {
  final T1 first;
  final T2 second;

  const Pair(this.first, this.second);

  @override
  String toString() => '($first, $second)';
}