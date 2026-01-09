import 'package:flutter/foundation.dart';
import 'package:finance_tracker/core/enums/voucher_type.dart';
import 'package:finance_tracker/core/models/domain/account.dart';
import 'package:finance_tracker/core/models/domain/project.dart';

class Transaction {
  final int dbID;
  final DateTime voucherDate;
  final String narration;
  final String refNo;
  final VoucherType voucherType;
  final Account drAccount;
  final Account crAccount;
  final int amount;
  final Project? project;
  final DateTime addedDate;
  final DateTime updateDate;
  final List<String> filePaths;

  Transaction({
    required this.dbID,
    required this.voucherDate,
    required this.narration,
    required this.refNo,
    required this.voucherType,
    required this.drAccount,
    required this.crAccount,
    required this.amount,
    this.project,
    required this.addedDate,
    required this.updateDate,
    required this.filePaths,
  });

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) return true;

    return other.dbID == dbID &&
        other.voucherDate == voucherDate &&
        other.narration == narration &&
        other.refNo == refNo &&
        other.voucherType == voucherType &&
        other.drAccount == drAccount &&
        other.crAccount == crAccount &&
        other.amount == amount &&
        other.project == project &&
        other.addedDate == addedDate &&
        other.updateDate == updateDate &&
        listEquals(other.filePaths, filePaths);
  }

  @override
  int get hashCode {
    return dbID.hashCode ^
        voucherDate.hashCode ^
        narration.hashCode ^
        refNo.hashCode ^
        voucherType.hashCode ^
        drAccount.hashCode ^
        crAccount.hashCode ^
        amount.hashCode ^
        project.hashCode ^
        addedDate.hashCode ^
        updateDate.hashCode ^
        filePaths.hashCode;
  }

  @override
  String toString() {
    return '$dbID $narration $refNo ${voucherType.label} $drAccount $crAccount ${amount / 1000} $project'
        .toLowerCase();
  }
}

