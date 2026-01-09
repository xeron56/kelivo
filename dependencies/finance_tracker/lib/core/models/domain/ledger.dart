import 'package:finance_tracker/core/models/domain/account.dart';
import 'package:finance_tracker/core/models/domain/account_type.dart';

class Ledger {
  final Account account;
  final AccountType accountType;
  final int balance;

  Ledger({
    required this.account,
    required this.accountType,
    required this.balance,
  });

  @override
  bool operator ==(covariant Ledger other) {
    if (identical(this, other)) return true;

    return other.account == account &&
        other.accountType == accountType &&
        other.balance == balance;
  }

  @override
  int get hashCode =>
      account.hashCode ^ accountType.hashCode ^ balance.hashCode;

  @override
  String toString() => '$account ${accountType.name} $balance'.toLowerCase();
}

