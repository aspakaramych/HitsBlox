import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/nodes/AssignNode.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:flutter/cupertino.dart';

class LengthNode extends Node implements AssignNode{
  @override
  String rawExpression = '';
  final TextEditingController controller = TextEditingController();

  @override
  final String id;

  @override
  String get title => "Получение длины массива";

  LengthNode(String this.id, Offset position) : super(position){

  }

  @override
  Future<void> execute(VariableRegistry registry) async {
    if (inputs.length != 1){
      throw Exception("Должен можно подсоединить только 1 входной пин");
    }
    if (inputs[0].getValue() is !String){
      throw Exception("Вы не передали переменную");
    }
    var input = registry.getValue(inputs[0].getValue());
    if (input is !List || input is !String){
      throw Exception("Вы передали не массив или строку");
    }
    registry.setValue(rawExpression, input.length);
    for (var p in outputs){
      p.setValue(rawExpression);
    }
  }

  @override
  void setAssignmentsFromText(String text, VariableRegistry registry) {
    return;
  }

  @override
  void setText(String text) {
    rawExpression = text;
  }
}