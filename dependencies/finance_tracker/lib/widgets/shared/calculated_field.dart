import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/core/enums/currency.dart';
import 'package:finance_tracker/widgets/shared/calculator_keyboard.dart';

class CalculatedField extends StatelessWidget {
  /// Custom field to input currency amounts, with currency and formating
  const CalculatedField(
      {super.key,
      this.amount,
      required this.onChanged,
      required this.label,
      this.errorText,
      this.autoFocus = false,
      this.textStyle,
      this.isDisabled = false,
      required this.currency,
      this.helperText});

  /// The initial amount
  final double? amount;

  /// Function to update the viewmodel amount on change
  final Function(double?) onChanged;

  /// The label to be placed on top of the field
  final String label;

  /// Text to show in case of an error
  final String? errorText;

  /// Whether to focus on the field
  final bool autoFocus;

  /// Text styling for the field
  final TextStyle? textStyle;

  /// Disable the field
  final bool isDisabled;

  /// Currency from the profile
  final Currency currency;

  /// Helper text for the field
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final isMobile = Platform.isAndroid || Platform.isIOS;
    if (!isMobile) {
      return TextFormField(
        style: textStyle,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.end,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(r'^\d*\.?\d*')), // Allows only numbers and one decimal
        ],
        decoration: InputDecoration(
            helperText: helperText,
            helperMaxLines: 2,
            labelText: label,
            errorText: errorText,
            prefix: Text(currency.symbol)),
        initialValue:
            amount?.toStringAsFixed(countDecimalPlaces(currency.format)),
        onChanged: (value) {
          var doubleValue = double.tryParse(value);
          if (doubleValue != null) {
            doubleValue = roundToFormat(doubleValue, currency.format);
          }
          onChanged(doubleValue);
        },
        autofocus: autoFocus,
        enabled: !isDisabled,
      );
    }

    return TextFormField(
      style: textStyle,
      textAlign: TextAlign.end,
      decoration: InputDecoration(
          helperText: helperText,
          helperMaxLines: 2,
          labelText: label,
          errorText: errorText,
          prefix: Text(currency.symbol)),
      controller:
          TextEditingController(text: (amount ?? 0).toCurrencyString(currency)),
      onChanged: (value) {
        onChanged(double.tryParse(value));
      },
      autofocus: autoFocus,
      readOnly: isMobile,
      enabled: !isDisabled,
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          constraints: const BoxConstraints(maxWidth: smallWidth),
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: CalculatorKeyBoard(
                  onChanged: (p0) => onChanged(p0),
                  amount: amount,
                  dismissFn: () {
                    Navigator.pop(context);
                  },
                  currency: currency,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

int countDecimalPlaces(String format) {
  final parts = format.split('.');
  if (parts.length < 2) return 0; // No decimal point means 0 decimal places
  return parts[1].replaceAll(RegExp(r'[^0#]'), '').length;
}

double roundToFormat(double number, String format) {
  int decimalPlaces = countDecimalPlaces(format);
  double factor = pow(10, decimalPlaces).toDouble();
  return (number * factor).roundToDouble() / factor;
}

