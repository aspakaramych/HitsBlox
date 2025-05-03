import 'package:app/core/abstracts/Command.dart';
import 'package:app/core/abstracts/Expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class AssignVariableCommand<T> implements Command{
  final String variableName;
  final Expression expression;

  AssignVariableCommand(this.variableName, this.expression);

  @override
  void execute(VariableRegistry registry) {
    var result = expression.evaluate(registry);
    registry.setValue<T>(variableName, result as T);
  }
  
  
}