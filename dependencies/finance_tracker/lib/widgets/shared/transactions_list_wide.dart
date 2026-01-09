import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:finance_tracker/app/global/values.dart';
import 'package:finance_tracker/core/enums/voucher_type.dart';
import 'package:finance_tracker/core/models/domain/account.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/models/domain/transaction.dart';
import 'package:finance_tracker/screens/transaction_screen.dart';
import 'package:finance_tracker/widgets/shared/transaction_tile.dart';

class TransactionsListWide extends StatelessWidget {
  /// Transactions list for wide screen

  const TransactionsListWide({
    super.key,
    required this.scrollController,
    required this.fTransactions,
    required this.profile,
    required this.initFn,
    this.account,
  });

  /// Scroll controller for the screen
  final ScrollController? scrollController;

  /// Filtered dates for transactions
  final List<Transaction> fTransactions;

  /// App Profile
  final Profile profile;

  /// Viewmodel init function
  final Function initFn;

  /// Whether an specific account is selected for transactions
  final Account? account;

  @override
  Widget build(BuildContext context) {
    final bool hasAccount = account != null;
    final bool isColorful = !hasAccount ||
        (hasAccount && fundingAccountIDs.contains(account!.accountType));
    return ListView.builder(
      cacheExtent: 20,
      controller: scrollController,
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: fTransactions.length,
      itemBuilder: (context, index) {
        final t = fTransactions[index];
        final int amount = t.amount;

        final bool isTransfer =
            fundingAccountIDs.contains(t.drAccount.accountType) &&
                fundingAccountIDs.contains(t.crAccount.accountType) &&
                !hasAccount;

        final Account acc = hasAccount
            ? [t.crAccount, t.drAccount]
                .firstWhere((a) => a.dbID != account!.dbID)
            : (t.voucherType == VoucherType.payment
                ? t.drAccount
                : t.crAccount);

        final bool isNegative = !isTransfer &&
            ((t.voucherType == VoucherType.payment &&
                    (!hasAccount || account!.dbID == t.crAccount.dbID)) ||
                (t.voucherType == VoucherType.receipt &&
                    t.crAccount.dbID != acc.dbID &&
                    fundingAccountIDs.contains(t.crAccount.accountType)));

        final String accountName = acc.name;
        final String? fundName = hasAccount
            ? null
            : (t.voucherType == VoucherType.receipt
                ? t.drAccount.name
                : t.crAccount.name);

        return TransactionTile(
          isColorful: isColorful,
          currency: profile.currency,
          vchDate: t.voucherDate,
          isNegative: isNegative,
          accountName: accountName,
          isTransfer: isTransfer,
          amount: amount,
          onClick: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => TransactionScreen(
                      transaction: t,
                      profile: profile,
                    ),
                  ),
                )
                .then((_) => initFn());
          },
          vchType: t.voucherType,
          transactionID: t.dbID,
          narr: t.narration,
          fundName: fundName,
        ).animate().fade(duration: 250.ms);
      },
    );
  }
}

