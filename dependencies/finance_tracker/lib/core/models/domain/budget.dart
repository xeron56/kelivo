import 'package:flutter/foundation.dart';
import 'package:finance_tracker/core/enums/budget_interval.dart';
import 'package:finance_tracker/core/models/domain/account.dart';

class Budget {
  final int dbID;
  final String name;
  final BudgetInterval interval;
  final String details;
  final int startDay;
  final List<Account> funds;
  final Map<Account, int> incomes;
  final Map<Account, int> expenses;
  final DateTime startDate;
  final DateTime addedDate;
  final DateTime updateDate;

  Budget({
    required this.dbID,
    required this.name,
    required this.interval,
    required this.details,
    required this.startDay,
    required this.startDate,
    required this.funds,
    required this.incomes,
    required this.expenses,
    required this.addedDate,
    required this.updateDate,
  });

  @override
  bool operator ==(covariant Budget other) {
    if (identical(this, other)) return true;

    return other.dbID == dbID &&
        other.name == name &&
        other.interval == interval &&
        other.details == details &&
        other.startDay == startDay &&
        listEquals(other.funds, funds) &&
        mapEquals(other.incomes, incomes) &&
        mapEquals(other.expenses, expenses) &&
        other.startDate == startDate &&
        other.addedDate == addedDate &&
        other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return dbID.hashCode ^
        name.hashCode ^
        interval.hashCode ^
        details.hashCode ^
        startDay.hashCode ^
        funds.hashCode ^
        incomes.hashCode ^
        expenses.hashCode ^
        startDate.hashCode ^
        addedDate.hashCode ^
        updateDate.hashCode;
  }

  @override
  String toString() {
    return '$name ${interval.label} $details $funds $incomes $expenses'
        .toLowerCase();
  }
}

