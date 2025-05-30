import 'package:app/core/abstracts/expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class BoolLiteral implements Expression {
  final bool value;

  BoolLiteral(this.value);

  @override
  bool evaluate(VariableRegistry registry) => value;

  @override
  String toString() {
    return value ? "true" : "false";
  }
}
