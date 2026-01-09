import 'package:finance_tracker/core/models/domain/account.dart';

class Wallet {
  final int dbID;
  final Account account;

  Wallet({
    required this.dbID,
    required this.account,
  });
}

