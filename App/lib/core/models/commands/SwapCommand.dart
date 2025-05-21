import 'package:app/core/abstracts/Command.dart';
import 'package:app/core/abstracts/Expression.dart';
import 'package:app/core/literals/IntLiteral.dart';
import 'package:app/core/models/commands/ArraySetCommand.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class SwapCommand implements Command{
  final String varName1;
  final int? idx1;
  final String varName2;
  final int? idx2;

  SwapCommand(this.varName1, this.idx1, this.varName2, this.idx2){}
  @override
  Future<void> execute(VariableRegistry registry) async {
    dynamic aVal, bVal;
    if (idx1 == null){
      aVal = registry.getValue(varName1);
    }
    else{
      aVal = registry.getValue(varName1)[idx1];
    }
    if (idx2 == null){
      bVal = registry.getValue(varName2);
    }
    else{
      bVal = registry.getValue(varName2)[idx2];
    }
    if (aVal == null || bVal == null) return;
    if (idx1 == null){
      registry.setValue(varName1, bVal);
    }
    else {
      var command = ArraySetCommand(arrayName: varName1, index: idx1!, valueExpression: IntLiteral(bVal));
      command.execute(registry);
    }
    if (idx2 == null){
      registry.setValue(varName2, aVal);
    }
    else {
      var command = ArraySetCommand(arrayName: varName2, index: idx2!, valueExpression: IntLiteral(aVal));
      command.execute(registry);
    }

  }

}