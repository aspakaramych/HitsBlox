import 'package:app/core/Pins/Pin.dart';
import 'package:app/core/abstracts/Command.dart';
import 'package:app/core/abstracts/Node.dart';
import 'package:app/core/registry/VariableRegistry.dart';

class PrintNode extends Node{
  final Command command;

  PrintNode(String id, this.command) : super(id){
    addInput(Pin(id: 'exec_in', name: 'Exec In', isInput: true));
    addOutput(Pin(id: 'exec_out', name: 'Exec Out', isInput: false));
  }


  @override
  Future<void> execute(VariableRegistry registry) async {
    command.execute(registry);
  }

}