import 'package:app/core/registry/VariableRegistry.dart';

abstract class Command {
  Future<void> execute(VariableRegistry registry);
}
