import 'package:app/core/abstracts/expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class ArrayLiteral<T> implements Expression {
  final List<Expression> elements;

  ArrayLiteral(this.elements);

  @override
  List<T> evaluate(VariableRegistry registry) {
    return elements.map((e) {
      var value = e.evaluate(registry);
      if (T != dynamic && value is! T) {
        throw Exception(
          "TypeError. Expected ${T}, got ${value.runtimeType}",
        );
      }
      return value as T;
    }).toList();
  }
}
