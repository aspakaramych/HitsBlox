import 'package:app/core/abstracts/command.dart';
import 'package:app/core/abstracts/expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class ArraySetCommand implements Command {
  final String arrayName;
  final int index;
  final Expression valueExpression;

  ArraySetCommand({
    required this.arrayName,
    required this.index,
    required this.valueExpression,
  });

  @override
  Future<void> execute(VariableRegistry registry) async {
    var value = valueExpression.evaluate(registry);
    var array = registry.getValue<List<dynamic>>(arrayName);

    if (array == null) {
      throw Exception("Массив '$arrayName' не найден");
    }

    if (index >= array.length || index < 0) {
      throw Exception("Индекс $index вне диапазона массива '$arrayName'");
    }

    array[index] = value;
    registry.setValue(arrayName, array);
  }
}
