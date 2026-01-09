// // Helper class for getting total transactions for a given day from DB.

class DailyTotalTransaction {
  final DateTime dateTime;
  int paymentsTotal;
  int receiptsTotal;

  DailyTotalTransaction(
      {required this.dateTime, this.paymentsTotal = 0, this.receiptsTotal = 0});

  addPayment(int p) {
    paymentsTotal += p;
  }

  addReceipt(int i) {
    receiptsTotal += i;
  }
}
