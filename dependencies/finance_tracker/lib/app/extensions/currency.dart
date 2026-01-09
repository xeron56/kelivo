import 'package:intl/intl.dart';
import 'package:finance_tracker/core/enums/currency.dart';

extension CurrencyExtensions on int {
  /// Converts an integer (stored as thousandths of a unit) to a double.
  double toCurrency() {
    return (double.parse((this / 1000).toStringAsFixed(3)));
  }

  /// Converts an integer to a formatted currency string.
  String toCurrencyString(Currency currency) {
    final numberFormat = NumberFormat(currency.format, 'en_US');

    return numberFormat.format(toCurrency());
  }

  String toCurrencyStringWSymbol(Currency currency) {
    final numberFormat = NumberFormat(currency.format, 'en_US');

    return "${currency.symbol} ${numberFormat.format(toCurrency())}";
  }
}

extension CurrencyParsing on double {
  /// Converts a double (currency) to an integer (in thousandths).
  int toIntCurrency() {
    return (this * 1000).round();
  }

  String toCurrencyString(Currency currency) {
    final numberFormat = NumberFormat(currency.format, 'en_US');

    return numberFormat.format(this);
  }
}

extension StringCurrencyParsing on String {
  /// Parses a string to an integer (in thousandths).
  /// Returns `null` if parsing fails.
  int? toIntCurrency() {
    final parsed = double.tryParse(this);
    return parsed != null ? (parsed * 1000).round() : null;
  }
}

