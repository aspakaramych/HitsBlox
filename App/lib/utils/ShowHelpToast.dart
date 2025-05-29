import 'package:app/core/widgets/program_processing_toast_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastify/toastify.dart';

class ShowHelpToast {
  void showIfElseToast(BuildContext context) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 10),
        child: ProgramProcessingToast(
          title: 'IfElseCreated',
          description:
              'Подключите в входные пины переменные или значения типа bool, (BoolAsign, More, Less, Equals)',
          backgroundColor: Colors.grey,
          textColor: Colors.grey,
        ),
      ),
    );
  }

  void showWhileToast(BuildContext context) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 10),
        child: ProgramProcessingToast(
          title: 'WhileCreated',
          description:
              'Чтобы зациклить, подключите выходной пин из тела цикла ко входному в while(обязательно заполните все выходные пины while)',
          backgroundColor: Colors.grey,
          textColor: Colors.grey,
        ),
      ),
    );
  }

  void showIntToast(BuildContext context) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 10),
        child: ProgramProcessingToast(
          title: 'IntAssignCreated',
          description:
              'Сначала напишите название переменной, через равно число, элемент массива или арифмитическое выражение, в конце поставьте ; (a = 12;, b = a[i];, a = 45 * 5 + b[i];)',
          backgroundColor: Colors.grey,
          textColor: Colors.grey,
        ),
      ),
    );
  }

  void showStringToast(BuildContext context) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 10),
        child: ProgramProcessingToast(
          title: 'StringAssignCreated',
          description:
              'Сначала напишите название переменной, через равно напишите строчку в "", в конце поставьте ; (a = "пупу";)',
          backgroundColor: Colors.grey,
          textColor: Colors.grey,
        ),
      ),
    );
  }

  void showBoolToast(BuildContext context) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 10),
        child: ProgramProcessingToast(
          title: 'BoolAssignCreated',
          description:
              'Сначала напишите название переменной, через равно напишите true или false, в конце поставьте ; (a = true;, b = false;)',
          backgroundColor: Colors.grey,
          textColor: Colors.grey,
        ),
      ),
    );
  }

  void showArrayToast(BuildContext context) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 10),
        child: ProgramProcessingToast(
          title: 'ArrayAssignCreated',
          description:
              'type a = {}; \ntype a = []; \ntype - тип значений в массиве(int, string, bool) \na - название переменной (любое) \n{value1, value2, ...} заполнить своими значениями \n[size] создать массив размером size, зполненный стандартными значениями(0, "", true)',
          backgroundColor: Colors.grey,
          textColor: Colors.grey,
        ),
      ),
    );
  }
  void showArrayAddToast(BuildContext context) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 10),
        child: ProgramProcessingToast(
          title: 'ArrayAddCreated',
          description:
          'Сначала напишите название уже созданного массива, в [] укажите индекс, через равно укажите значение, которое вы хотите присвоить этому элементу массива(a[i] = 45;)',
          backgroundColor: Colors.grey,
          textColor: Colors.grey,
        ),
      ),
    );
  }
  void showLengthToast(BuildContext context) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 10),
        child: ProgramProcessingToast(
          title: 'LengthCreated',
          description:
          'На вход соедините блок с массивом, внутри напишите название переменной, значение которой будет длинной массива',
          backgroundColor: Colors.grey,
          textColor: Colors.grey,
        ),
      ),
    );
  }
  void showBinToast(BuildContext context) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 10),
        child: ProgramProcessingToast(
          title: 'OperationsCreated',
          description:
          'На вход подается 2 числа \nВерхний треугольник - a \nНижний треугольник - b',
          backgroundColor: Colors.grey,
          textColor: Colors.grey,
        ),
      ),
    );
  }
  void showSwapToast(BuildContext context) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 10),
        child: ProgramProcessingToast(
          title: 'SwapCreated',
          description:
          'В поля пишутся переменные или массивы с индексами',
          backgroundColor: Colors.grey,
          textColor: Colors.grey,
        ),
      ),
    );
  }
  void showIncrementToast(BuildContext context) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 10),
        child: ProgramProcessingToast(
          title: 'IncrementCreated',
          description:
          'Напишите переменную, после неё:\n++ если хотите увеличить на 1\n-- если хотите уменьшить на 1',
          backgroundColor: Colors.grey,
          textColor: Colors.grey,
        ),
      ),
    );
  }
  void showConcatToast(BuildContext context) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 10),
        child: ProgramProcessingToast(
          title: 'ConcatCreated',
          description:
          'На вход подается 2 строки \nВерхний треугольник - a \nНижний треугольник - b',
          backgroundColor: Colors.grey,
          textColor: Colors.grey,
        ),
      ),
    );
  }
  void showLogicToast(BuildContext context) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 10),
        child: ProgramProcessingToast(
          title: 'LogicCreated',
          description:
          'На вход подается 2 числа или bool значения \nВерхний треугольник - a \nНижний треугольник - b',
          backgroundColor: Colors.grey,
          textColor: Colors.grey,
        ),
      ),
    );
  }
  void showPrintToast(BuildContext context) {
    showToast(
      context,
      Toast(
        lifeTime: Duration(seconds: 10),
        child: ProgramProcessingToast(
          title: 'PrintCreated',
          description:
          'Если хотите вывести значение переменной, напишите ее в {}({a})',
          backgroundColor: Colors.grey,
          textColor: Colors.grey,
        ),
      ),
    );
  }
}
