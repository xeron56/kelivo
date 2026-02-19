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

    // SECTION 1: SYSTEM PERSONA & INSTRUCTIONS
    sb.writeln('## FINANCIAL ASSISTANT MODE ACTIVE');
    sb.writeln(
      'You are a helpful, data-driven financial assistant for ${profile.name}.',
    );
    sb.writeln(
      'Your goal is to answer questions using the provided "Real-Time Financial Data" below.',
    );
    sb.writeln('RULES:');
    sb.writeln(
      '1. ALWAYS cite specific amounts and dates from the data to back up your answers.',
    );
    sb.writeln(
      '2. If the user asks "What is my balance?", use the "Total Net Worth / Closing Balance".',
    );
    sb.writeln(
      '3. If the user asks about recent spending, summarize the "Recent Activity".',
    );
    sb.writeln(
      '4. If data is missing (e.g., spending from last year), explain that you only have access to the recent transactions listed below.',
    );
    sb.writeln('5. Be concise and professional. Do not make up data.');

    sb.writeln('\n## REAL-TIME FINANCIAL DATA');
    sb.writeln('------------------------------');

    try {
      // 1. Balances
      final balance = await balancesRepository.getFundClosingBalance(
        DateTime.now(),
        profile.dbID,
      );
      // Assuming balance is in cents/smallest unit
      sb.writeln(
        '- **Total Net Worth / Closing Balance**: ${(balance / 100.0).toStringAsFixed(2)} ${profile.currency.name}',
      );

      // 2. Recent Transactions (last 15)
      final transactions = await transactionsRepository.getNTransactions(
        n: 15,
        profileId: profile.dbID,
      );

      if (transactions.isNotEmpty) {
        sb.writeln('\n### Recent Activity (Last 15 Transactions):');
        sb.writeln('| Date | Type | Amount | Description |');
        sb.writeln('|---|---|---|---|');
        for (final t in transactions) {
          final date = t.voucherDate.toIso8601String().split('T')[0];
          final type = t.voucherType.label;
          // Heuristic: Receipt = Income, Payment = Expense
          final isIncome = t.voucherType.name.toLowerCase() == 'receipt';
          final sign = isIncome ? '+' : '-';
          final amount = (t.amount / 100.0).toStringAsFixed(2);
          final memo = t.narration.replaceAll('\n', ' ').trim();
          sb.writeln('| $date | $type | $sign$amount | $memo |');
        }
      }

      // 3. Accounts Summary
      final ledgers = await accountsRepository.getLedgers(
        profileId: profile.dbID,
      );
      if (ledgers.isNotEmpty) {
        sb.writeln('\n### Account Balances:');
        for (final l in ledgers) {
          // Skip zero balance if list is long, or show all? Let's show non-zero to save context
          if (l.balance != 0) {
            sb.writeln(
              '- **${l.account.name}** (${l.accountType.name}): ${(l.balance / 100.0).toStringAsFixed(2)}',
            );
          }
        }
      }
    } catch (e) {
      sb.writeln('Error accessing financial DB: $e');
    }

    sb.writeln('------------------------------');
    sb.writeln('End of Financial Context. Await user query.');

    return sb.toString();
  }
}
