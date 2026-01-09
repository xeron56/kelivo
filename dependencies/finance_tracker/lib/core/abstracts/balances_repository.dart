abstract class BalancesRepository {
  Future<int> insertBalance({required int account, required int amount});
  Future<bool> updateBalanceByAccount({required int account});
  Future<int> getClosingBalance(
      {required int account, required DateTime closingDate});
  Future<int> delete(int id);
  Future<int> getFundClosingBalance(DateTime closingDate, int profileID);
}
