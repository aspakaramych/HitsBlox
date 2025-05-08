import 'package:app/viewmodels/assignment_block.dart';

class Pair<T1 extends AssignmentBlock, T2 extends AssignmentBlock> {
  final T1 first;
  final T2 second;

  const Pair(this.first, this.second);

  @override
  String toString() => '($first, $second)';
}