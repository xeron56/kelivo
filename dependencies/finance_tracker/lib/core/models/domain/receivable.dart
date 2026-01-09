import 'package:finance_tracker/core/models/domain/account.dart';

class Receivable {
  final int dbID;
  final Account account;
  final int? totalAmount;
  final DateTime? paidDate;

  Receivable({
    required this.dbID,
    required this.account,
    this.totalAmount,
    this.paidDate,
  });
}

