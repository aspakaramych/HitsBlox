import '../../abstracts/Expression.dart';
import '../../registry/VariableRegistry.dart';

class ConcatCommand implements Expression {
  final Expression left;
  final Expression right;
  final String operator;

  ConcatCommand(this.left, this.right, this.operator);

  @override
  String evaluate(VariableRegistry registry) {
    var l = left.evaluate(registry);
    var r = right.evaluate(registry);
    if (operator == "+" && left is String && right is String) {
      return l + r;
    } else {
      throw Exception("unknown operator $operator");
    }
  }
}
