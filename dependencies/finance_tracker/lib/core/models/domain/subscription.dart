import 'package:finance_tracker/core/enums/budget_interval.dart';
import 'package:finance_tracker/core/models/domain/account.dart';

class Subscription {
  final int dbID;
  final Account account;
  final int profile;
  final BudgetInterval interval;
  final int day;
  final int amount;
  final DateTime addedDate;
  final DateTime updateDate;

  Subscription({
    required this.dbID,
    required this.account,
    required this.profile,
    required this.interval,
    required this.day,
    required this.amount,
    required this.addedDate,
    required this.updateDate,
  });
}

