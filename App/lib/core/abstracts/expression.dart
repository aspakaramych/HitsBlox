import 'package:app/core/registry/VariableRegistry.dart';

abstract class Expression {
  dynamic evaluate(VariableRegistry registry);
}
