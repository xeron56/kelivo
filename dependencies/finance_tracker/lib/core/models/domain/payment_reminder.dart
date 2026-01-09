import 'package:finance_tracker/core/enums/budget_interval.dart';
import 'package:finance_tracker/core/enums/payment_status.dart';
import 'package:finance_tracker/core/models/domain/account.dart';

class PaymentReminder {
  final int dbID;
  final Account? account;
  final Account? fund;
  final int profile;
  final BudgetInterval? interval;
  final int? day;
  final DateTime? paymentDate;
  final int amount;
  final DateTime addedDate;
  final DateTime updateDate;
  final PaymentStatus paymentStatus;
  final List<String> filePaths;
  final String details;

  PaymentReminder({
    required this.dbID,
    required this.paymentStatus,
    required this.details,
    this.account,
    this.fund,
    required this.profile,
    this.interval,
    this.day,
    this.paymentDate,
    required this.amount,
    required this.addedDate,
    required this.updateDate,
    required this.filePaths,
  });

  @override
  String toString() {
    return "$details ${amount / 1000} ${account != null ? account?.name : ""} ${fund != null ? fund?.name : ""}"
        .toLowerCase();
  }
}

