import 'package:app/core/abstracts/Expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class ArrayLiteral implements Expression {
  final List<dynamic> elements;

  ArrayLiteral(this.elements);

  @override
  List<dynamic> evaluate(VariableRegistry registry) =>
      elements.map((e) => e.evaluate(registry)).toList();
}
