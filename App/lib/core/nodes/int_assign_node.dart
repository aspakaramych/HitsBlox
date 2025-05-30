import 'package:app/core/abstracts/command.dart';
import 'package:app/core/abstracts/expression.dart';
import 'package:app/core/abstracts/node.dart';
import 'package:app/core/literals/get_array_value.dart';
import 'package:app/core/literals/int_literal.dart';
import 'package:app/core/literals/variable_literal.dart';
import 'package:app/core/models/binary_operations.dart';
import 'package:app/core/models/commands/assign_variable_command.dart';
import 'package:app/core/nodes/assign_node.dart';
import 'package:app/core/pins/Pin.dart';
import 'package:app/core/registry/VariableRegistry.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

class Token {
  final String
  type;
  final String value;

  Token(this.type, this.value);

  @override
  String toString() => 'Token($type, $value)';
}

class IntAssignNode extends Node implements AssignNode {
  final List<Command> commands = [];

  @override
  String rawExpression = '';
  final TextEditingController controller = TextEditingController();

  @override
  final String id;

  @override
  String get title => "Присвоить (int)";

  IntAssignNode(String this.id, Offset position) : super(position);

  @override
  void setAssignmentsFromText(String text, VariableRegistry registry) {
    rawExpression = text;
    commands.clear();

    var lines = text.split(';');
    for (var line in lines) {
      var trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      var match = RegExp(r'^\s*(\w+)\s*=\s*(.*)$').firstMatch(trimmedLine);

      if (match == null) {
        int? pVal;
        for (var p in inputs) {
          if (p.id.contains('value_in')) {
            pVal = p.getValue();
            if (pVal is int) {
              commands.add(
                AssignVariableCommand<int>(trimmedLine, IntLiteral(pVal)),
              );
              break;
            }
          }
        }
        if (pVal == null) {
          print(
            "Предупреждение: Невозможно интерпретировать строку '$trimmedLine' как присваивание или входное значение.",
          );
        }
        continue;
      }

      var variableName = match.group(1)!;
      var exprStr = match.group(2)!;
      Expression expression = _parseExpressionWithShuntingYard(
        exprStr,
        registry,
      );
      commands.add(AssignVariableCommand<int>(variableName, expression));

      for (var p in outputs) {
        p.setValue(variableName);
      }
    }
  }
  Expression _parseExpressionWithShuntingYard(
    String expressionText,
    VariableRegistry registry,
  ) {
    List<Token> tokenize(String text) {
      final List<Token> tokens = [];
      final RegExp numRegex = RegExp(r'^\d+');
      final RegExp varRegex = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*');
      final RegExp operatorRegex = RegExp(r'^(\+|\-|\*|\/)');
      final RegExp parenRegex = RegExp(r'^(\(|\))');
      final RegExp arrayAccessRegex = RegExp(
        r'^([a-zA-Z_][a-zA-Z0-9_]*)\s*\[\s*(.*?)\s*\]',
      );

      String remainingText = text.trim();

      while (remainingText.isNotEmpty) {
        if (remainingText.startsWith(' ')) {
          remainingText = remainingText.trimLeft();
          continue;
        }

        Match? match;

        match = arrayAccessRegex.firstMatch(remainingText);
        if (match != null) {
          tokens.add(
            Token('ARRAY_ACCESS', match.group(0)!),
          );
          remainingText = remainingText.substring(match.end).trimLeft();
          continue;
        }

        match = numRegex.firstMatch(remainingText);
        if (match != null) {
          tokens.add(Token('NUMBER', match.group(0)!));
          remainingText = remainingText.substring(match.end).trimLeft();
          continue;
        }

        match = varRegex.firstMatch(remainingText);
        if (match != null) {
          tokens.add(Token('VARIABLE', match.group(0)!));
          remainingText = remainingText.substring(match.end).trimLeft();
          continue;
        }

        match = operatorRegex.firstMatch(remainingText);
        if (match != null) {
          tokens.add(Token('OPERATOR', match.group(0)!));
          remainingText = remainingText.substring(match.end).trimLeft();
          continue;
        }

        match = parenRegex.firstMatch(remainingText);
        if (match != null) {
          tokens.add(
            Token(match.group(0) == '(' ? 'LPAREN' : 'RPAREN', match.group(0)!),
          );
          remainingText = remainingText.substring(match.end).trimLeft();
          continue;
        }

        throw FormatException(
          'Неизвестный токен: "${remainingText.split(' ').first}" в выражении "$expressionText"',
        );
      }
      return tokens;
    }

    final Map<String, int> precedence = {'+': 1, '-': 1, '*': 2, '/': 2};

    List<Token> outputQueue = [];
    List<Token> operatorStack = [];

    List<Token> tokens = tokenize(expressionText);

    for (Token token in tokens) {
      if (token.type == 'NUMBER' ||
          token.type == 'VARIABLE' ||
          token.type == 'ARRAY_ACCESS') {
        outputQueue.add(token);
      } else if (token.type == 'OPERATOR') {
        while (operatorStack.isNotEmpty &&
            operatorStack.last.type == 'OPERATOR' &&
            precedence[operatorStack.last.value]! >= precedence[token.value]!) {
          outputQueue.add(operatorStack.removeLast());
        }
        operatorStack.add(token);
      } else if (token.type == 'LPAREN') {
        operatorStack.add(token);
      } else if (token.type == 'RPAREN') {
        while (operatorStack.isNotEmpty &&
            operatorStack.last.type != 'LPAREN') {
          outputQueue.add(operatorStack.removeLast());
        }
        if (operatorStack.isEmpty || operatorStack.last.type != 'LPAREN') {
          throw FormatException(
            'Несогласованные скобки: отсутствует открывающая скобка',
          );
        }
        operatorStack.removeLast();
      }
    }

    while (operatorStack.isNotEmpty) {
      final op = operatorStack.removeLast();
      if (op.type == 'LPAREN' || op.type == 'RPAREN') {
        throw FormatException('Несогласованные скобки в конце парсинга');
      }
      outputQueue.add(op);
    }

    List<Expression> expressionStack = [];

    for (Token token in outputQueue) {
      if (token.type == 'NUMBER') {
        expressionStack.add(IntLiteral(int.parse(token.value)));
      } else if (token.type == 'VARIABLE') {
        expressionStack.add(VariableLiteral(token.value));
      } else if (token.type == 'ARRAY_ACCESS') {
        expressionStack.add(GetArrayValue.parse(token.value, registry));
      } else if (token.type == 'OPERATOR') {
        if (expressionStack.length < 2) {
          throw FormatException(
            'Недостаточно операндов для оператора ${token.value}',
          );
        }
        final right = expressionStack.removeLast();
        final left = expressionStack.removeLast();
        expressionStack.add(BinaryOperations(left, right, token.value));
      } else {
        throw FormatException('Неожиданный токен в ОПН: ${token.value}');
      }
    }

    if (expressionStack.length != 1) {
      throw FormatException('Ошибка парсинга: оставшиеся выражения в стеке');
    }

    return expressionStack.single;
  }

  @override
  void setText(String text) => rawExpression = text;

  @override
  Future<void> execute(VariableRegistry registry) async {
    clearOutputs();
    setAssignmentsFromText(rawExpression, registry);
    for (var cmd in commands) {
      await cmd.execute(registry);
    }
  }

  bool areAllInputsReady() {
    final execIn =
        inputs.firstWhereOrNull((p) => p.id.contains('exec_in')) as Pin?;
    return execIn != null;
  }

  void clearOutputs() {
    for (var p in outputs) {
      p.setValue(null);
    }
  }
}
