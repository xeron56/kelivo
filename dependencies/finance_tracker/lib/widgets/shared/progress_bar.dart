import 'package:flutter/material.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/core/enums/currency.dart';

class ProgressBar extends StatelessWidget {
  /// The percentage progress in double value
  final double progress; // Value between 0 and 1

  /// Maximum possible value
  final double max;

  /// Currency from profile
  final Currency currency;

  /// A simple progress bar widget
  const ProgressBar({
    super.key,
    required this.progress,
    required this.max,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final double percent = ((progress / max) * 100);

    final goodGradient = LinearGradient(colors: [
      Colors.greenAccent.shade700,
      Colors.green.shade700,
    ], begin: const Alignment(0, 0), end: const Alignment(0, 1));

    final warningGradient = LinearGradient(colors: [
      Colors.orangeAccent.shade400,
      Colors.deepOrange,
    ], begin: const Alignment(0, 0), end: const Alignment(0, 1));
    final badGradient = LinearGradient(colors: [
      Colors.red.shade400,
      Colors.redAccent.shade700,
    ], begin: const Alignment(0, 0), end: const Alignment(0, 1));

    final bgGradient = LinearGradient(colors: [
      Colors.grey.shade600.withAlpha(200),
      Colors.grey.shade500.withAlpha(200),
    ], begin: const Alignment(0, 0), end: const Alignment(0, 1));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Background bar
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: bgGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Progress bar
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      height: 20,
                      width: constraints.maxWidth * percent / 100,
                      decoration: BoxDecoration(
                        gradient: percent < 60
                            ? goodGradient
                            : percent < 99
                                ? warningGradient
                                : badGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  },
                ),
                // Percentage text
                Center(
                  child: Text(
                    "${progress.toCurrencyString(currency)} / ${max.toCurrencyString(currency)} (${(percent).toStringAsFixed(1)}%)",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

