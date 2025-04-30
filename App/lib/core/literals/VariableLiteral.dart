import 'package:app/core/abstracts/Expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class VariableLiteral implements Expression {
  final String name;

  VariableLiteral(this.name);

  @override
  evaluate(VariableRegistry registry) => registry.get(name);
}
