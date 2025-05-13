import '../pins/Pin.dart';

abstract class AssignNode {
  String get id;
  String get rawExpression;
  void setAssignmentsFromText(String text);
  void setText(String text);
  List<Pin> get outputs;
  List<Pin> get inputs;
  void addInput(Pin pin) => inputs.add(pin);
  void addOutput(Pin pin) => outputs.add(pin);
}