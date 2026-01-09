import 'package:finance_tracker/app/global/values.dart';

class DBUtils {
  static bool isAssetOrExpense(int accType) {
    return [
      walletTypeID,
      bankTypeID,
      expenseTypeID,
      advanceTypeID,
      peopleTypeID
    ].contains(accType);
  }

  static bool isLiabilityOrIncome(int accType) {
    return [cCardTypeID, loanTypeID, incomeTypeID].contains(accType);
  }
}

