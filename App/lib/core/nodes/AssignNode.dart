import '../Pins/Pin.dart';

abstract class AssignNode {
  String get id;
  String get rawExpression;
  void setAssignmentsFromText(String text);
  List<Pin> get outputs;
  List<Pin> get inputs;
}