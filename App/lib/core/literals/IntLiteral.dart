import 'package:app/core/abstracts/Expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class IntLiteral implements Expression {
  final int value;

  IntLiteral(this.value);

  @override
  int evaluate(VariableRegistry registry) => value;
}
