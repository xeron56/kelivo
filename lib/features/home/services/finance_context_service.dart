import 'package:finance_tracker/core/repositories/drift/accounts_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/balances_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/transactions_drift_repository.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';

class FinanceContextService {
  final TransactionsDriftRepository transactionsRepository;
  final BalancesDriftRepository balancesRepository;
  final AccountsDriftRepository accountsRepository;
  final AppViewmodel appViewmodel;

  FinanceContextService({
    required this.transactionsRepository,
    required this.balancesRepository,
    required this.accountsRepository,
    required this.appViewmodel,
  });

  Future<String> getFinanceContext() async {
    final profile = appViewmodel.selectedProfile;
    if (profile == null) return '';

    final sb = StringBuffer();
    sb.writeln('## Current Financial Context');
    sb.writeln(
      'Here is the current financial status for the user (Profile: ${profile.name}):',
    );

    try {
      // 1. Balances
      final balance = await balancesRepository.getFundClosingBalance(
        DateTime.now(),
        profile.dbID,
      );
      // Assuming balance is in cents/smallest unit, divide by 100 for display
      sb.writeln(
        '- **Total Closing Balance**: ${(balance / 100.0).toStringAsFixed(2)}',
      );

      // 2. Recent Transactions (last 10)
      final transactions = await transactionsRepository.getNTransactions(
        n: 10,
        profileId: profile.dbID,
      );

      if (transactions.isNotEmpty) {
        sb.writeln('\n### Recent Transactions (Last 10):');
        for (final t in transactions) {
          final date = t.voucherDate.toIso8601String().split('T')[0];
          final type = t.voucherType.label;
          // Assuming amount is in cents
          final amount = (t.amount / 100.0).toStringAsFixed(2);
          final memo = t.narration.isNotEmpty ? '(${t.narration})' : '';
          sb.writeln('- $date [$type] $amount $memo');
        }
      }

      // 3. Accounts Summary
      final ledgers = await accountsRepository.getLedgers(
        profileId: profile.dbID,
      );
      if (ledgers.isNotEmpty) {
        sb.writeln('\n### Accounts Summary:');
        for (final l in ledgers.take(15)) {
          sb.writeln(
            '- ${l.account.name} (${l.accountType.name}): ${(l.balance / 100.0).toStringAsFixed(2)}',
          );
        }
      }
    } catch (e) {
      sb.writeln('Error fetching some financial data: $e');
    }

    sb.writeln(
      '\nUse this context to answer user questions about their finances. If the answer is not in this context, politely explain you only have access to recent data.',
    );

    return sb.toString();
  }
}
