import 'package:app/core/abstracts/Expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class ArraySizeLiteral<T> implements Expression {
  final int size;

  ArraySizeLiteral(this.size);

  @override
  List<T?> evaluate(VariableRegistry registry) {
    return List<T?>.filled(size, null);
  }
}