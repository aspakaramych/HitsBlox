import 'package:app/core/abstracts/command.dart';
import 'package:app/core/abstracts/expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class AssignVariableCommand<T> implements Command{
  final String variableName;
  final Expression expression;

  AssignVariableCommand(this.variableName, this.expression);

  @override
  Future<void> execute(VariableRegistry registry) async {
    var result = expression.evaluate(registry);
    registry.setValue<T>(variableName, result as T);
  }

}