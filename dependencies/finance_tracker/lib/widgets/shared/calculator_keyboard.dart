import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/core/enums/currency.dart';
import 'package:finance_tracker/viewmodels/calculator_viewmodel.dart';

class CalculatorKeyBoard extends StatelessWidget {
  /// The initial amount
  final double? amount;

  /// Viewmodel function to call on value changed
  final Function(double?) onChanged;

  /// Function to clear the input
  final Function dismissFn;

  /// Currency from profile
  final Currency currency;

  /// The virtual calculator keyboard for amounts calculation and direct inputs for mobile devices only.
  const CalculatorKeyBoard(
      {super.key,
      this.amount,
      required this.onChanged,
      required this.dismissFn,
      required this.currency});

  @override
  Widget build(BuildContext context) {
    final buttonColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final primaryColor = Theme.of(context).textTheme.headlineMedium?.color;

    return ChangeNotifierProvider<CalculatorViewmodel>(
      create: (context) => CalculatorViewmodel(
          currency: currency,
          input: amount?.toString() ?? "",
          result: amount?.toCurrencyString(currency) ?? "0"),
      builder: (context, child) => Consumer<CalculatorViewmodel>(
        builder: (context, viewmodel, child) => ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: smallWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Display the input field
              Container(
                alignment: Alignment.centerRight,
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                child: Text(
                  viewmodel.input,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              // Display the result field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      currency.symbol,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 16),
                      child: Text(
                        textAlign: TextAlign.end,
                        viewmodel.result,
                        overflow: TextOverflow.visible,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              // Calculator buttons
              Column(
                children: [
                  Row(children: [
                    buildButton("7", viewmodel,
                        buttonColor: buttonColor, textColor: textColor),
                    buildButton("8", viewmodel,
                        buttonColor: buttonColor, textColor: textColor),
                    buildButton("9", viewmodel,
                        buttonColor: buttonColor, textColor: textColor),
                    buildButton("÷", viewmodel,
                        buttonColor: buttonColor, textColor: primaryColor),
                  ]),
                  Row(children: [
                    buildButton("4", viewmodel,
                        buttonColor: buttonColor, textColor: textColor),
                    buildButton("5", viewmodel,
                        buttonColor: buttonColor, textColor: textColor),
                    buildButton("6", viewmodel,
                        buttonColor: buttonColor, textColor: textColor),
                    buildButton("×", viewmodel,
                        buttonColor: buttonColor, textColor: primaryColor),
                  ]),
                  Row(children: [
                    buildButton("1", viewmodel,
                        buttonColor: buttonColor, textColor: textColor),
                    buildButton("2", viewmodel,
                        buttonColor: buttonColor, textColor: textColor),
                    buildButton("3", viewmodel,
                        buttonColor: buttonColor, textColor: textColor),
                    buildButton("-", viewmodel,
                        buttonColor: buttonColor, textColor: primaryColor),
                  ]),
                  Row(children: [
                    buildButton(".", viewmodel,
                        buttonColor: buttonColor, textColor: textColor),
                    buildButton("0", viewmodel,
                        buttonColor: buttonColor, textColor: textColor),
                    buildButton(
                      "←",
                      viewmodel,
                      isDelete: true,
                      buttonColor: Colors.orange,
                    ),
                    buildButton("+", viewmodel,
                        buttonColor: buttonColor, textColor: primaryColor),
                  ]),
                  Row(
                    children: [
                      buildButton("C", viewmodel,
                          buttonColor: Colors.red,
                          textColor: Colors.white,
                          isSquare: false),
                      buildButton("=", viewmodel,
                          buttonColor: Colors.green,
                          textColor: Colors.white,
                          isSquare: false),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(
    String label,
    CalculatorViewmodel viewmodel, {
    Color? buttonColor,
    Color? textColor,
    bool isDelete = false,
    bool isSquare = true,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              if (label == "C") {
                viewmodel.clearInput(onChanged);
              } else if (label == "=") {
                dismissFn();
              } else if (isDelete) {
                viewmodel.deleteLast(onChanged);
              } else {
                viewmodel.appendInput(label, onChanged);
              }
            },
            style: ButtonStyle(
              elevation: WidgetStateProperty.all<double>(5.0),
              backgroundColor: WidgetStateProperty.all<Color?>(buttonColor),
              foregroundColor: WidgetStateProperty.all<Color?>(textColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(),
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

