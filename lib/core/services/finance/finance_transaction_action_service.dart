import 'dart:math' as math;

import 'package:finance_tracker/app/global/values.dart';
import 'package:finance_tracker/core/abstracts/accounts_repository.dart';
import 'package:finance_tracker/core/abstracts/balances_repository.dart';
import 'package:finance_tracker/core/abstracts/projects_repository.dart';
import 'package:finance_tracker/core/abstracts/transactions_repository.dart';
import 'package:finance_tracker/core/enums/voucher_type.dart';
import 'package:finance_tracker/core/models/domain/ledger.dart';
import 'package:finance_tracker/core/models/domain/project.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';

class FinanceTransactionActionService {
  FinanceTransactionActionService({
    required AccountsRepository accountsRepository,
    required TransactionsRepository transactionsRepository,
    required BalancesRepository balancesRepository,
    required ProjectsRepository projectsRepository,
    required AppViewmodel appViewmodel,
  }) : _accountsRepository = accountsRepository,
       _transactionsRepository = transactionsRepository,
       _balancesRepository = balancesRepository,
       _projectsRepository = projectsRepository,
       _appViewmodel = appViewmodel;

  final AccountsRepository _accountsRepository;
  final TransactionsRepository _transactionsRepository;
  final BalancesRepository _balancesRepository;
  final ProjectsRepository _projectsRepository;
  final AppViewmodel _appViewmodel;

  Future<Map<String, dynamic>> getEntryOptions() async {
    final Profile? profile = _appViewmodel.selectedProfile;
    if (profile == null) {
      return <String, dynamic>{
        'ok': false,
        'error': 'no_active_profile',
        'message': 'No active finance profile found.',
      };
    }

    final List<Ledger> fundingLedgers = await _accountsRepository
        .getLedgersByCategory(
          profileId: profile.dbID,
          accTypeIDs: fundingAccountIDs,
        );
    final List<Ledger> expenseLedgers = await _accountsRepository
        .getLedgersByCategory(
          profileId: profile.dbID,
          accTypeIDs: const <int>[expenseTypeID],
        );
    final List<Ledger> incomeLedgers = await _accountsRepository
        .getLedgersByCategory(
          profileId: profile.dbID,
          accTypeIDs: const <int>[incomeTypeID],
        );
    final List<Project> projects = await _projectsRepository.getAllProjects(
      profile.dbID,
    );

    return <String, dynamic>{
      'ok': true,
      'profile': <String, dynamic>{
        'id': profile.dbID,
        'name': profile.name,
        'currency': profile.currency.isoCode,
      },
      'fund_accounts': fundingLedgers
          .map(
            (Ledger ledger) => <String, dynamic>{
              'id': ledger.account.dbID,
              'name': ledger.account.name,
              'account_type': ledger.accountType.name,
              'balance_minor': ledger.balance,
            },
          )
          .toList(growable: false),
      'expense_categories': expenseLedgers
          .map(
            (Ledger ledger) => <String, dynamic>{
              'id': ledger.account.dbID,
              'name': ledger.account.name,
              'account_type': ledger.accountType.name,
            },
          )
          .toList(growable: false),
      'income_categories': incomeLedgers
          .map(
            (Ledger ledger) => <String, dynamic>{
              'id': ledger.account.dbID,
              'name': ledger.account.name,
              'account_type': ledger.accountType.name,
            },
          )
          .toList(growable: false),
      'projects': projects
          .map(
            (Project project) => <String, dynamic>{
              'id': project.dbID,
              'name': project.name,
              'status': project.status.name,
            },
          )
          .toList(growable: false),
    };
  }

  Future<Map<String, dynamic>> createTransaction({
    required String transactionType,
    required Object? amount,
    String? categoryName,
    String? fundAccountName,
    String? narration,
    String? transactionDate,
    String? referenceNo,
    String? projectName,
  }) async {
    final Profile? profile = _appViewmodel.selectedProfile;
    if (profile == null) {
      return _error(
        code: 'no_active_profile',
        message: 'No active finance profile found.',
      );
    }

    final _TransactionMode? mode = _TransactionModeParser.parse(
      transactionType,
    );
    if (mode == null) {
      return _error(
        code: 'invalid_transaction_type',
        message:
            'transaction_type must be "expense" or "income". Received "$transactionType".',
      );
    }

    final double? amountValue = _parseAmount(amount);
    if (amountValue == null || amountValue <= 0) {
      return _error(
        code: 'invalid_amount',
        message: 'Amount must be a positive number.',
      );
    }
    final int amountMinor = (amountValue * 1000).round();

    final DateTime effectiveDate =
        _parseDate(transactionDate) ?? DateTime.now();

    final List<Ledger> fundingLedgers = await _accountsRepository
        .getLedgersByCategory(
          profileId: profile.dbID,
          accTypeIDs: fundingAccountIDs,
        );
    if (fundingLedgers.isEmpty) {
      return _error(
        code: 'no_fund_accounts',
        message: 'No funding accounts are available in the active profile.',
      );
    }

    final List<Ledger> categoryLedgers = await _accountsRepository
        .getLedgersByCategory(
          profileId: profile.dbID,
          accTypeIDs: <int>[mode.categoryAccountTypeId],
        );
    if (categoryLedgers.isEmpty) {
      return _error(
        code: 'no_category_accounts',
        message:
            'No ${mode.name} category accounts are available in the active profile.',
      );
    }

    final _MatchOutcome<Ledger> fundMatch = _resolveLedger(
      query: fundAccountName,
      fallbackQuery: narration,
      ledgers: fundingLedgers,
      allowSingleFallback: true,
    );
    if (!fundMatch.ok || fundMatch.value == null) {
      return _error(
        code: 'fund_account_not_found',
        message:
            fundMatch.message ??
            'Unable to resolve a funding account for this transaction.',
        extra: <String, dynamic>{
          'available_fund_accounts': fundingLedgers
              .map((Ledger ledger) => ledger.account.name)
              .toList(growable: false),
        },
      );
    }

    final _MatchOutcome<Ledger> categoryMatch = _resolveLedger(
      query: categoryName,
      fallbackQuery: narration,
      ledgers: categoryLedgers,
      allowSingleFallback: false,
    );
    if (!categoryMatch.ok || categoryMatch.value == null) {
      return _error(
        code: 'category_not_found',
        message:
            categoryMatch.message ??
            'Unable to resolve a category account for this transaction.',
        extra: <String, dynamic>{
          'available_categories': categoryLedgers
              .map((Ledger ledger) => ledger.account.name)
              .toList(growable: false),
          'expected_category_type': mode.name,
        },
      );
    }

    Project? resolvedProject;
    if ((projectName ?? '').trim().isNotEmpty) {
      final List<Project> projects = await _projectsRepository.getAllProjects(
        profile.dbID,
      );
      final _MatchOutcome<Project> projectMatch = _resolveProject(
        query: projectName!,
        projects: projects,
      );
      if (!projectMatch.ok || projectMatch.value == null) {
        return _error(
          code: 'project_not_found',
          message:
              projectMatch.message ??
              'Unable to resolve the requested project.',
          extra: <String, dynamic>{
            'available_projects': projects
                .map((Project project) => project.name)
                .toList(growable: false),
          },
        );
      }
      resolvedProject = projectMatch.value;
    }

    final Ledger fundLedger = fundMatch.value!;
    final Ledger categoryLedger = categoryMatch.value!;
    final String safeNarration = (narration ?? '').trim().isNotEmpty
        ? narration!.trim()
        : _defaultNarration(mode, categoryLedger.account.name);

    final int transactionId = await _transactionsRepository.insertTransaction(
      vchDate: effectiveDate,
      narr: safeNarration,
      refNo: (referenceNo ?? '').trim(),
      dr: mode == _TransactionMode.expense
          ? categoryLedger.account.dbID
          : fundLedger.account.dbID,
      cr: mode == _TransactionMode.expense
          ? fundLedger.account.dbID
          : categoryLedger.account.dbID,
      amount: amountMinor,
      vchType: mode.voucherType,
      profile: profile.dbID,
      project: resolvedProject?.dbID,
    );

    await _balancesRepository.updateBalanceByAccount(
      account: fundLedger.account.dbID,
    );
    await _balancesRepository.updateBalanceByAccount(
      account: categoryLedger.account.dbID,
    );

    final List<String> warnings = <String>[
      ...fundMatch.warnings,
      ...categoryMatch.warnings,
    ];

    return <String, dynamic>{
      'ok': true,
      'tool': 'create_finance_transaction',
      'transaction': <String, dynamic>{
        'id': transactionId,
        'type': mode.name,
        'voucher_type': mode.voucherType.name,
        'date': _formatDate(effectiveDate),
        'amount': amountValue,
        'amount_minor': amountMinor,
        'currency': profile.currency.isoCode,
        'fund_account': fundLedger.account.name,
        'category_account': categoryLedger.account.name,
        'narration': safeNarration,
        'reference_no': (referenceNo ?? '').trim(),
        'project': resolvedProject?.name,
      },
      if (warnings.isNotEmpty) 'warnings': warnings,
      'message':
          'Created ${mode.name} transaction for ${amountValue.toStringAsFixed(3)} '
          '${profile.currency.isoCode} using ${fundLedger.account.name}.',
    };
  }

  Map<String, dynamic> _error({
    required String code,
    required String message,
    Map<String, dynamic>? extra,
  }) {
    return <String, dynamic>{
      'ok': false,
      'error': code,
      'message': message,
      ...?extra,
    };
  }

  static double? _parseAmount(Object? raw) {
    if (raw == null) {
      return null;
    }
    if (raw is num) {
      return raw.toDouble();
    }
    final String cleaned = raw
        .toString()
        .replaceAll(',', '')
        .replaceAll(RegExp(r'[^0-9.\-]'), '')
        .trim();
    return double.tryParse(cleaned);
  }

  static DateTime? _parseDate(String? raw) {
    final String value = (raw ?? '').trim();
    if (value.isEmpty) {
      return null;
    }
    final DateTime? parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return null;
    }
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  static String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  static String _defaultNarration(
    _TransactionMode mode,
    String categoryAccount,
  ) {
    final String prefix = mode == _TransactionMode.expense
        ? 'Spent on'
        : 'Earned from';
    return '$prefix $categoryAccount';
  }

  static _MatchOutcome<Ledger> _resolveLedger({
    required String? query,
    required String? fallbackQuery,
    required List<Ledger> ledgers,
    required bool allowSingleFallback,
  }) {
    final String primary = (query ?? '').trim();
    final _RankedMatch<Ledger>? primaryMatch = _bestLedgerMatch(
      query: primary,
      ledgers: ledgers,
    );
    if (primaryMatch != null) {
      return _MatchOutcome<Ledger>.success(
        value: primaryMatch.value,
        warnings: primaryMatch.warning == null
            ? const <String>[]
            : <String>[primaryMatch.warning!],
      );
    }

    final String fallback = (fallbackQuery ?? '').trim();
    final _RankedMatch<Ledger>? fallbackMatch = _bestLedgerMatch(
      query: fallback,
      ledgers: ledgers,
    );
    if (fallbackMatch != null) {
      return _MatchOutcome<Ledger>.success(
        value: fallbackMatch.value,
        warnings: <String>[
          'Matched ${fallbackMatch.value.account.name} from narration context.',
        ],
      );
    }

    if (primary.isEmpty && allowSingleFallback && ledgers.length == 1) {
      return _MatchOutcome<Ledger>.success(
        value: ledgers.first,
        warnings: <String>[
          'Only one funding account was available, so it was used automatically.',
        ],
      );
    }

    return _MatchOutcome<Ledger>.failure(
      message: primary.isEmpty
          ? 'No matching account name was provided.'
          : 'No account matched "$primary".',
    );
  }

  static _MatchOutcome<Project> _resolveProject({
    required String query,
    required List<Project> projects,
  }) {
    if (projects.isEmpty) {
      return _MatchOutcome<Project>.failure(
        message: 'No projects are available in the active profile.',
      );
    }
    final _RankedMatch<Project>? match = _bestMatch<Project>(
      query: query,
      items: projects,
      labelOf: (Project project) => project.name,
    );
    if (match == null) {
      return _MatchOutcome<Project>.failure(
        message: 'No project matched "$query".',
      );
    }
    return _MatchOutcome<Project>.success(
      value: match.value,
      warnings: match.warning == null
          ? const <String>[]
          : <String>[match.warning!],
    );
  }

  static _RankedMatch<Ledger>? _bestLedgerMatch({
    required String query,
    required List<Ledger> ledgers,
  }) {
    return _bestMatch<Ledger>(
      query: query,
      items: ledgers,
      labelOf: (Ledger ledger) => ledger.account.name,
    );
  }

  static _RankedMatch<T>? _bestMatch<T>({
    required String query,
    required List<T> items,
    required String Function(T item) labelOf,
  }) {
    final String normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) {
      return null;
    }

    _RankedMatch<T>? best;
    _RankedMatch<T>? runnerUp;
    for (final T item in items) {
      final String label = labelOf(item);
      final String normalizedLabel = _normalize(label);
      final int score = _matchScore(
        query: normalizedQuery,
        target: normalizedLabel,
      );
      if (score <= 0) {
        continue;
      }
      final _RankedMatch<T> candidate = _RankedMatch<T>(
        value: item,
        score: score,
        warning: null,
      );
      if (best == null || candidate.score > best.score) {
        runnerUp = best;
        best = candidate;
      } else if (runnerUp == null || candidate.score > runnerUp.score) {
        runnerUp = candidate;
      }
    }

    if (best == null) {
      return null;
    }

    if (runnerUp != null && best.score == runnerUp.score) {
      return null;
    }

    final String label = labelOf(best.value);
    final String normalizedLabel = _normalize(label);
    final bool exact = normalizedLabel == normalizedQuery;
    if (!exact) {
      return _RankedMatch<T>(
        value: best.value,
        score: best.score,
        warning: 'Matched "$label" for "$query".',
      );
    }
    return best;
  }

  static int _matchScore({required String query, required String target}) {
    if (query == target) {
      return 1000;
    }
    if (target.startsWith(query)) {
      return 700;
    }
    if (target.contains(query)) {
      return 500;
    }

    final List<String> queryTokens = query.split(' ');
    final List<String> targetTokens = target.split(' ');
    int tokenScore = 0;
    for (final String token in queryTokens) {
      if (token.isEmpty) {
        continue;
      }
      if (targetTokens.contains(token)) {
        tokenScore += 100;
      } else if (target.contains(token)) {
        tokenScore += 60;
      }
    }

    final int lengthPenalty = (target.length - query.length).abs();
    return math.max(0, tokenScore - lengthPenalty);
  }

  static String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}

enum _TransactionMode {
  expense(
    name: 'expense',
    voucherType: VoucherType.payment,
    categoryAccountTypeId: expenseTypeID,
  ),
  income(
    name: 'income',
    voucherType: VoucherType.receipt,
    categoryAccountTypeId: incomeTypeID,
  );

  const _TransactionMode({
    required this.name,
    required this.voucherType,
    required this.categoryAccountTypeId,
  });

  final String name;
  final VoucherType voucherType;
  final int categoryAccountTypeId;
}

extension _TransactionModeParser on _TransactionMode {
  static _TransactionMode? parse(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'expense':
      case 'payment':
      case 'spent':
        return _TransactionMode.expense;
      case 'income':
      case 'receipt':
      case 'earned':
        return _TransactionMode.income;
      default:
        return null;
    }
  }
}

class _MatchOutcome<T> {
  const _MatchOutcome._({
    required this.ok,
    this.value,
    this.message,
    this.warnings = const <String>[],
  });

  const _MatchOutcome.success({
    required T value,
    List<String> warnings = const <String>[],
  }) : this._(ok: true, value: value, warnings: warnings);

  const _MatchOutcome.failure({required String message})
    : this._(ok: false, message: message);

  final bool ok;
  final T? value;
  final String? message;
  final List<String> warnings;
}

class _RankedMatch<T> {
  const _RankedMatch({
    required this.value,
    required this.score,
    required this.warning,
  });

  final T value;
  final int score;
  final String? warning;
}
