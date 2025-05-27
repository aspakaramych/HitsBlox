import 'package:app/core/widgets/program_processing_toast_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastify/toastify.dart';

class ShowHelpToast{
  void showIfElseToast(BuildContext context){
    showToast(context, Toast(
      lifeTime: Duration(seconds: 10),
      child: ProgramProcessingToast(
        title: 'IfElseCreated',
        description: 'Подключите в входные пины переменные или значения типа bool, (BoolAsign, More, Less, Equals)',
        backgroundColor: Colors.grey,
        textColor: Colors.grey,
      ),
    ));
  }
  void showWhileToast(BuildContext context){
    showToast(context, Toast(
      lifeTime: Duration(seconds: 10),
      child: ProgramProcessingToast(
        title: 'WhileCreated',
        description: 'Чтобы зациклить, подключите выходной пин из тела цикла ко входному в while(обязательно заполните все выходные пины while) ',
        backgroundColor: Colors.grey,
        textColor: Colors.grey,
      ),
    ));
  }
}