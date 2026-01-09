import 'package:flutter/foundation.dart';
import 'package:finance_tracker/app/global/default_accounts.dart';
import 'package:finance_tracker/core/enums/loading_status.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/abstracts/accounts_repository.dart';
import 'package:finance_tracker/core/abstracts/balances_repository.dart';
import 'package:finance_tracker/core/abstracts/wallets_repository.dart';
import 'package:finance_tracker/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountsImportViewmodel extends ChangeNotifier {
  final AccountsRepository _accountsRepository;
  final WalletsRepository _walletsRepository;
  final BalancesRepository _balancesRepository;

  AccountsImportViewmodel(this._accountsRepository, this._walletsRepository,
      this._balancesRepository,
      {required Profile profile})
      : _profile = profile;
  SharedPreferences? _prefs;
  Future<void> init() async {
    try {
      loadingStatus = LoadingStatus.loading;
      _prefs = await SharedPreferences.getInstance();
      notifyListeners();
      _setDefaults();
      loadingStatus = LoadingStatus.completed;
      notifyListeners();
    } catch (e) {
      AppLogger.instance.error(' ${e.toString()}');
      errorText = 'Error: Failed to initialise';
      loadingStatus = LoadingStatus.error;
    }
  }

  final Profile _profile;

  LoadingStatus loadingStatus = LoadingStatus.idle;

  String errorText = "";

  Set<String> selectedExpense = {};
  Set<String> selectedIncome = {};
  Set<String> selectedCash = {};

  int _cashOpenBalance = 0;

  int get cashOpenBalance => _cashOpenBalance;

  set cashOpenBalance(int value) {
    _cashOpenBalance = value;
    notifyListeners();
  }

  _setDefaults() {
    defaultExpense.forEach((k, v) {
      if (v) {
        selectedExpense.add(k);
      }
    });

    defaultIncome.forEach((k, v) {
      if (v) {
        selectedIncome.add(k);
      }
    });
    defaultCash.forEach((k, v) {
      if (v) {
        selectedCash.add(k);
      }
    });
    notifyListeners();
  }

  addToImport({String? e, String? i, String? c}) {
    if (e != null) {
      if (selectedExpense.contains(e)) {
        selectedExpense.remove(e);
      } else {
        selectedExpense.add(e);
      }
    }
    if (i != null) {
      if (selectedIncome.contains(i)) {
        selectedIncome.remove(i);
      } else {
        selectedIncome.add(i);
      }
    }
    notifyListeners();
  }

  bool _validate() {
    bool isValid = true;

    notifyListeners();
    return isValid;
  }

  Future<bool> save() async {
    DateTime now = DateTime.now();
    DateTime accountOpenDate = DateTime(
      2000,
    );
    if (_validate()) {
      loadingStatus = LoadingStatus.submitting;
      notifyListeners();
      try {
        int ac = await _accountsRepository.insertAccount(
            name: selectedCash.first,
            openBal: cashOpenBalance,
            openDate: now.copyWith(month: 1, day: 1),
            accType: 0,
            profile: _profile.dbID);
        await _balancesRepository.insertBalance(
            account: ac, amount: cashOpenBalance);
        await _walletsRepository.insertWallet(account: ac);

        await _accountsRepository.insertAccountsBulk(
            selectedExpense.toList(), 5, _profile.dbID, accountOpenDate);
        await _accountsRepository.insertAccountsBulk(
            selectedIncome.toList(), 4, _profile.dbID, accountOpenDate);
      } catch (e) {
        errorText = "Failed saving accounts";
        loadingStatus = LoadingStatus.error;
        return false;
      }
    }
    loadingStatus = LoadingStatus.submitted;
    notifyListeners();
    return true;
  }

  void resetErrorText() {
    errorText = "";
    notifyListeners();
  }

  Future<void> setLastUpdatedTimeStamp() async {
    try {
      final timeStamp = DateTime.now();
      _prefs?.setInt('lastUpdated', timeStamp.millisecondsSinceEpoch);
    } catch (e) {
      AppLogger.instance
          .error("Error setting Last updated timestamp ${e.toString()}");
    }
  }
}

