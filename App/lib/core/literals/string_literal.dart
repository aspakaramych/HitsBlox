import 'package:app/core/abstracts/expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class StringLiteral implements Expression{
  final String value;

  StringLiteral(this.value);

  @override
  String evaluate(VariableRegistry registry) => value;
}