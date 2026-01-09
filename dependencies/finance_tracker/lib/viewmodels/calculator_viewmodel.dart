import 'package:flutter/foundation.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/core/enums/currency.dart';
import 'package:finance_tracker/utils/app_logger.dart';

class CalculatorViewmodel extends ChangeNotifier {
  String _input;
  String _result;
  bool _isPeriodBlocked;
  bool _isFirstEntry;
  final Currency _currency;

  CalculatorViewmodel(
      {String input = "",
      String result = "0",
      bool isPeriodBlocked = false,
      bool isFirstEntry = true,
      required Currency currency})
      : _input = input,
        _currency = currency,
        _result = result,
        _isPeriodBlocked = isPeriodBlocked,
        _isFirstEntry = isFirstEntry;

  String get input => _input;
  String get result => _result;

  static const mathSymbols = ['+', '-', '×', '÷', "="];

  void appendInput(String value, Function(double) onChanged) {
    final isValueSymbol = mathSymbols.contains(value);
    final isExpComplete = !mathSymbols.any((m) => _input.endsWith(m));

    if (_input.isEmpty && isValueSymbol) {
      return;
    }

    if (value == ".") {
      if (_isPeriodBlocked) {
        return;
      }
      _isPeriodBlocked = true;
    }

    if (!isExpComplete && isValueSymbol) {
      _input = _input.replaceRange(_input.length - 1, null, value);
    } else if (_isFirstEntry && !isValueSymbol) {
      _input = value;
    } else {
      _input += value;
    }
    _isFirstEntry = false;

    if (isValueSymbol && _isPeriodBlocked) {
      _isPeriodBlocked = false;
    }

    notifyListeners();

    if (!isValueSymbol) {
      _calculateResult(onChanged);
    }
  }

  void clearInput(Function(double) onChanged) {
    _input = "";
    _result = "0";
    onChanged(0);
    notifyListeners();
  }

  void deleteLast(Function(double) onChanged) {
    if (_input.isNotEmpty) {
      _input = _input.substring(0, _input.length - 1);
      notifyListeners();
    }
    _calculateResult(onChanged);
  }

  void _calculateResult(Function(double) onChanged) {
    try {
      if (_input == "") {
        _result = "0";

        onChanged(0);
        return;
      }
      List<String> tokens = [];
      double numBuffer = 0;
      bool bufferingNumber = false;
      bool decimalMode = false;
      double decimalFactor = 0.1;

      for (int i = 0; i < input.length; i++) {
        if (input[i].contains(RegExp(r'[0-9]'))) {
          if (decimalMode) {
            numBuffer += int.parse(input[i]) * decimalFactor;
            decimalFactor *= 0.1;
          } else {
            numBuffer = numBuffer * 10 + int.parse(input[i]);
          }
          bufferingNumber = true;
        } else if (input[i] == '.') {
          decimalMode = true;
        } else {
          if (bufferingNumber) {
            tokens.add(numBuffer.toString());
            numBuffer = 0;
            bufferingNumber = false;
            decimalMode = false;
            decimalFactor = 0.1;
          }
          tokens.add(input[i]);
        }
      }

      if (bufferingNumber) {
        tokens.add(numBuffer.toString());
      }

      // Perform operations in order
      while (tokens.contains('×') || tokens.contains('÷')) {
        for (int i = 0; i < tokens.length; i++) {
          if (tokens[i] == '×' || tokens[i] == '÷') {
            double left = double.parse(tokens[i - 1]);
            double right = double.parse(tokens[i + 1]);
            double computed = tokens[i] == '×' ? left * right : left / right;
            tokens.replaceRange(i - 1, i + 2, [computed.toString()]);
            break;
          }
        }
      }

      while (tokens.contains('+') || tokens.contains('-')) {
        for (int i = 0; i < tokens.length; i++) {
          if (tokens[i] == '+' || tokens[i] == '-') {
            double left = double.parse(tokens[i - 1]);
            double right = double.parse(tokens[i + 1]);
            double computed = tokens[i] == '+' ? left + right : left - right;
            tokens.replaceRange(i - 1, i + 2, [computed.toString()]);
            break;
          }
        }
      }

      onChanged(double.parse(tokens.first));

      _result = double.parse(tokens.first)
          .toCurrencyString(_currency); // Two decimal places
    } catch (e, stackTrace) {
      _result = "Error";
      AppLogger.instance.error("$e, $stackTrace");
    }
    notifyListeners();
  }
}

