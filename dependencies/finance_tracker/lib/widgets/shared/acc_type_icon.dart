import 'package:flutter/material.dart';
import 'package:finance_tracker/app/global/values.dart';

/// Get the icon for a given account type.
IconData getAccTypeIcon(int accType) {
  switch (accType) {
    case walletTypeID:
      return Icons.account_balance_wallet;
    case bankTypeID:
      return Icons.account_balance;
    case cCardTypeID:
      return Icons.credit_card;
    case loanTypeID:
      return Icons.request_page;
    case expenseTypeID:
      return Icons.trending_down;
    case incomeTypeID:
      return Icons.trending_up;
    case peopleTypeID:
      return Icons.groups;
    case advanceTypeID:
      return Icons.handshake;
    default:
      return Icons.savings;
  }
}

