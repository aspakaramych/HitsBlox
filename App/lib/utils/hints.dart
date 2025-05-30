import 'package:app/core/abstracts/node.dart';
import 'package:app/core/nodes/array_add_node.dart';
import 'package:app/core/nodes/array_assign_node.dart';
import 'package:app/core/nodes/bool_assign_node.dart';
import 'package:app/core/nodes/increment_node.dart';
import 'package:app/core/nodes/int_assign_node.dart';
import 'package:app/core/nodes/length_node.dart';
import 'package:app/core/nodes/print_node.dart';
import 'package:app/core/nodes/string_assign_node.dart';
import 'package:app/core/nodes/while_node.dart';

enum Hints {
  INT("name = 123"),
  STRING("name = \"text\""),
  BOOL("name = true/false"),
  ARRAY("int arr = [size] / int arr = {1,2,3}"),
  ARRAYADD("arr[idx] = value"),
  LENGTH("name"),
  INCREMENT("name++ | name--"),
  PRINT("name"),
  WHILE("predicate"),
  SWAP("name / arr[idx]"),;

  const Hints(this.hintText);

  final String hintText;
}

class HintsUtils {
  static String getHintText(Node node) {
    if(node is IntAssignNode) {
      return Hints.INT.hintText;
    } else if(node is StringAssignNode) {
      return Hints.STRING.hintText;
    } else if(node is BoolAssignNode) {
      return Hints.BOOL.hintText;
    } else if(node is ArrayAsignNode) {
      return Hints.ARRAY.hintText;
    } else if(node is ArrayAddNode) {
      return Hints.ARRAYADD.hintText;
    } else if(node is LengthNode) {
      return Hints.LENGTH.hintText;
    } else if(node is IncrementNode) {
      return Hints.INCREMENT.hintText;
    } else if(node is PrintNode) {
      return Hints.PRINT.hintText;
    } else if(node is WhileNode) {
      return Hints.WHILE.hintText;
    }

    return "";
  }
}