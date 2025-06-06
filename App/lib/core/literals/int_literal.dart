import 'package:app/core/abstracts/expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class IntLiteral implements Expression {
  final int value;

  IntLiteral(this.value);

  @override
  int evaluate(VariableRegistry registry) => value;

  @override
  String toString() {
    return value.toString();
  }
}
