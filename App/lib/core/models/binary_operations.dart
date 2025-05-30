import 'package:app/core/abstracts/expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class BinaryOperations implements Expression {
  final Expression left;
  final Expression right;
  final String operator;

  BinaryOperations(this.left, this.right, this.operator);

  @override
  dynamic evaluate(VariableRegistry registry) {
    var l = left.evaluate(registry);
    var r = right.evaluate(registry);
    switch (operator) {
      case "+":
        return (l is num && r is num) ? l + r : throw "Invalid types";
      case "-":
        return (l is num && r is num) ? l - r : throw "Invalid types";
      case "*":
        return (l is num && r is num) ? l * r : throw "Invalid types";
      case "/":
        return (l is num && r is num)
            ? ((r != 0) ? (l ~/ r) : throw "Divide zero")
            : throw "Invalid types";
      case "==":
        return l == r;
      case "!=":
        return l != r;
      case ">":
        return (l is Comparable && r is Comparable)
            ? l.compareTo(r) > 0
            : false;
      case "<":
        return (l is Comparable && r is Comparable)
            ? l.compareTo(r) < 0
            : false;
      default:
        throw Exception("unknown operator $operator");
    }
  }
}
