import 'package:flutter/cupertino.dart';

import 'ShowHelpToast.dart';

class ToastService{
  final ShowHelpToast showHelpToast = ShowHelpToast();
  void Show(BuildContext context, String name, bool enable){
    if (enable) {
      switch (name){
        case "conditional":
          showHelpToast.showIfElseToast(context);
          return;
        case "while":
          showHelpToast.showWhileToast(context);
          return;
        case "int":
          showHelpToast.showIntToast(context);
          return;
        case "string":
          showHelpToast.showStringToast(context);
          return;
        case "bool":
          showHelpToast.showBoolToast(context);
          return;
        case "array":
          showHelpToast.showArrayToast(context);
          return;
        case "arrayAdd":
          showHelpToast.showArrayAddToast(context);
          return;
        case "length":
          showHelpToast.showLengthToast(context);
          return;
        case "add":
          showHelpToast.showBinToast(context);
          return;
        case "subtract":
          showHelpToast.showBinToast(context);
          return;
        case "multiply":
          showHelpToast.showBinToast(context);
          return;
        case "divide":
          showHelpToast.showBinToast(context);
          return;
        case "mod":
          showHelpToast.showBinToast(context);
          return;
        case "swap":
          showHelpToast.showSwapToast(context);
          return;
        case "increment":
          showHelpToast.showIncrementToast(context);
          return;
        case "concat":
          showHelpToast.showConcatToast(context);
          return;
        case "==":
          showHelpToast.showLogicToast(context);
          return;
        case ">":
          showHelpToast.showLogicToast(context);
          return;
        case "<":
          showHelpToast.showLogicToast(context);
          return;
        case ">=":
          showHelpToast.showLogicToast(context);
          return;
        case "<=":
          showHelpToast.showLogicToast(context);
          return;
        case "print":
          showHelpToast.showPrintToast(context);
          return;
      }
    }
  }
}