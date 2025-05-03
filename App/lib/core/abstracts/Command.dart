import 'package:app/core/registry/VariableRegistry.dart';

abstract class Command{
  void execute(VariableRegistry registry);
}