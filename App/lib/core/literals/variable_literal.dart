import 'package:app/core/abstracts/expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class VariableLiteral implements Expression {
  final String name;

  VariableLiteral(this.name);

  @override
  dynamic evaluate([VariableRegistry? registry]) {
    if (registry != null) {
      return registry.getValue(name);
    }
    return null;
  }
}
