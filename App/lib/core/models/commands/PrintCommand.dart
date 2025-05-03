import 'package:app/core/abstracts/Command.dart';
import 'package:app/core/abstracts/Expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class PrintCommand implements Command{
  final Expression expression;

  PrintCommand(this.expression);

  @override
  void execute(VariableRegistry registry) {
    var result = expression.evaluate(registry);
    print(result);
  }

}