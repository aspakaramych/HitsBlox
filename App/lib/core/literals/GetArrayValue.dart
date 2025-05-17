import 'package:app/core/abstracts/Expression.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class GetArrayValue implements Expression {
  final String arrayName;
  final int index;

  GetArrayValue(this.arrayName, this.index);

  factory GetArrayValue.parse(String exprStr) {
    final RegExp arrayRegex = RegExp(r'(\w+)\[(\d+)\]');
    final match = arrayRegex.firstMatch(exprStr.trim());
    if (match != null) {
      final arrayName = match.group(1)!;
      final indexStr = match.group(2)!;
      final index = int.tryParse(indexStr);
      if (index != null) {
        return GetArrayValue(arrayName, index);
      }
    }
    throw FormatException('Некорректный формат массива: $exprStr');
  }

  @override
  dynamic evaluate(VariableRegistry registry) {
    final array = registry.getValue(arrayName);
    if (array is List && index >= 0 && index < array.length) {
      return array[index];
    } else {
      throw RangeError('Индекс за пределами массива или переменная не является массивом: $arrayName[$index]');
    }
  }
}