import 'dart:math' as math;

import 'package:finance_tracker/app/global/values.dart';
import 'package:finance_tracker/core/abstracts/accounts_repository.dart';
import 'package:finance_tracker/core/abstracts/balances_repository.dart';
import 'package:finance_tracker/core/abstracts/banks_repository.dart';
import 'package:finance_tracker/core/abstracts/budgets_repository.dart';
import 'package:finance_tracker/core/abstracts/credit_cards_repository.dart';
import 'package:finance_tracker/core/abstracts/loans_repository.dart';
import 'package:finance_tracker/core/abstracts/payment_reminders_repository.dart';
import 'package:finance_tracker/core/abstracts/people_repository.dart';
import 'package:finance_tracker/core/abstracts/projects_repository.dart';
import 'package:finance_tracker/core/abstracts/receivables_repository.dart';
import 'package:finance_tracker/core/abstracts/transactions_repository.dart';
import 'package:finance_tracker/core/abstracts/wallets_repository.dart';
import 'package:finance_tracker/core/enums/budget_interval.dart';
import 'package:finance_tracker/core/enums/payment_status.dart';
import 'package:finance_tracker/core/enums/project_status.dart';
import 'package:finance_tracker/core/enums/voucher_type.dart';
import 'package:finance_tracker/core/models/domain/account.dart';
import 'package:finance_tracker/core/models/domain/ledger.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/models/domain/project.dart';
import 'package:finance_tracker/utils/services/notification_service.dart'
    as finance_notifications;
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';

class FinanceTransactionActionService {
  FinanceTransactionActionService({
    required AccountsRepository accountsRepository,
    required TransactionsRepository transactionsRepository,
    required BalancesRepository balancesRepository,
    required ProjectsRepository projectsRepository,
    required BudgetsRepository budgetsRepository,
    required PaymentRemindersRepository paymentRemindersRepository,
    required WalletsRepository walletsRepository,
    required BanksRepository banksRepository,
    required CreditCardsRepository cCardsRepository,
    required LoansRepository loansRepository,
    required PeopleRepository peopleRepository,
    required ReceivablesRepository receivablesRepository,
    required AppViewmodel appViewmodel,
  }) : _accountsRepository = accountsRepository,
       _transactionsRepository = transactionsRepository,
       _balancesRepository = balancesRepository,
       _projectsRepository = projectsRepository,
       _budgetsRepository = budgetsRepository,
       _paymentRemindersRepository = paymentRemindersRepository,
       _walletsRepository = walletsRepository,
       _banksRepository = banksRepository,
       _cCardsRepository = cCardsRepository,
       _loansRepository = loansRepository,
       _peopleRepository = peopleRepository,
       _receivablesRepository = receivablesRepository,
       _appViewmodel = appViewmodel;

  final AccountsRepository _accountsRepository;
  final TransactionsRepository _transactionsRepository;
  final BalancesRepository _balancesRepository;
  final ProjectsRepository _projectsRepository;
  final BudgetsRepository _budgetsRepository;
  final PaymentRemindersRepository _paymentRemindersRepository;
  final WalletsRepository _walletsRepository;
  final BanksRepository _banksRepository;
  final CreditCardsRepository _cCardsRepository;
  final LoansRepository _loansRepository;
  final PeopleRepository _peopleRepository;
  final ReceivablesRepository _receivablesRepository;
  final AppViewmodel _appViewmodel;

  Future<Map<String, dynamic>> getEntryOptions() async {
    final Profile? profile = _appViewmodel.selectedProfile;
    if (profile == null) {
      return _error(
        code: 'no_active_profile',
        message: 'No active finance profile found.',
      );
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

  Future<Map<String, dynamic>> getAutomationOptions() async {
    final Profile? profile = _appViewmodel.selectedProfile;
    if (profile == null) {
      return _error(
        code: 'no_active_profile',
        message: 'No active finance profile found.',
      );
    }

    final Map<String, dynamic> entryOptions = await getEntryOptions();
    if (entryOptions['ok'] != true) {
      return entryOptions;
    }

    final List<Account> accounts = await _accountsRepository
        .getAccountsByProfile(profileId: profile.dbID);
    final budgets = await _budgetsRepository.getAll(profile.dbID);

    return <String, dynamic>{
      ...entryOptions,
      'accounts': accounts
          .map(
            (Account account) => <String, dynamic>{
              'id': account.dbID,
              'name': account.name,
              'account_type_id': account.accountType,
            },
          )
          .toList(growable: false),
      'budgets': budgets
          .map(
            (budget) => <String, dynamic>{
              'id': budget.dbID,
              'name': budget.name,
              'interval': budget.interval.name,
            },
          )
          .toList(growable: false),
      'account_types': _AccountKind.values
          .map(
            (_AccountKind kind) => <String, dynamic>{
              'key': kind.key,
              'label': kind.label,
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
    final int amountMinor = _toMinorUnits(amountValue);

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

  Future<Map<String, dynamic>> createAccount({
    required String accountType,
    required String name,
    Object? openingBalance,
    String? openDate,
    String? holderName,
    String? institution,
    String? branch,
    String? branchCode,
    String? accountNo,
    String? cardNetwork,
    String? cardNo,
    Object? statementDate,
    String? agreementNo,
    Object? interestRate,
    String? startDate,
    String? endDate,
    String? address,
    String? email,
    String? phone,
    String? tin,
    String? zip,
    Object? paidAmount,
    String? paidDate,
  }) async {
    final Profile? profile = _appViewmodel.selectedProfile;
    if (profile == null) {
      return _error(
        code: 'no_active_profile',
        message: 'No active finance profile found.',
      );
    }

    final _AccountKind? kind = _AccountKindParser.parse(accountType);
    if (kind == null) {
      return _error(
        code: 'invalid_account_type',
        message: 'Unsupported account_type "$accountType".',
      );
    }

    final String trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return _error(
        code: 'invalid_account_name',
        message: 'Account name is required.',
      );
    }

    final List<Account> existing = await _accountsRepository.getAccountsByProfile(
      profileId: profile.dbID,
    );
    final bool duplicate = existing.any(
      (Account account) => _normalize(account.name) == _normalize(trimmedName),
    );
    if (duplicate) {
      return _error(
        code: 'duplicate_account_name',
        message: 'An account named "$trimmedName" already exists.',
      );
    }

    final double openingBalanceValue = _parseAmount(openingBalance) ?? 0;
    if (openingBalanceValue < 0) {
      return _error(
        code: 'invalid_opening_balance',
        message: 'Opening balance cannot be negative.',
      );
    }

    final DateTime effectiveOpenDate = _parseDate(openDate) ?? DateTime.now();
    final int openingBalanceMinor = _toMinorUnits(openingBalanceValue);

    final int accountId = await _accountsRepository.insertAccount(
      name: trimmedName,
      accType: kind.accountTypeId,
      openBal: openingBalanceMinor,
      openDate: effectiveOpenDate,
      profile: profile.dbID,
    );

    try {
      switch (kind) {
        case _AccountKind.wallet:
          await _walletsRepository.insertWallet(account: accountId);
          break;
        case _AccountKind.bank:
          await _banksRepository.insertBank(
            account: accountId,
            branch: _cleanOptional(branch),
            accountNo: _cleanOptional(accountNo),
            branchCode: _cleanOptional(branchCode),
            holderName: _cleanOptional(holderName),
            institution: _cleanOptional(institution),
          );
          break;
        case _AccountKind.creditCard:
          await _cCardsRepository.insertCCard(
            account: accountId,
            institution: _cleanOptional(institution),
            cardNetwork: _cleanOptional(cardNetwork),
            cardNo: _cleanOptional(cardNo),
            statementDate: _parseInt(statementDate),
          );
          break;
        case _AccountKind.loan:
          await _loansRepository.insertLoan(
            account: accountId,
            institution: _cleanOptional(institution),
            accountNo: _cleanOptional(accountNo),
            agreementNo: _cleanOptional(agreementNo),
            interestRate: _parseAmount(interestRate),
            startDate: _parseDate(startDate),
            endDate: _parseDate(endDate),
          );
          break;
        case _AccountKind.advance:
          final double? paidAmountValue = _parseAmount(paidAmount);
          await _receivablesRepository.insertReceivable(
            account: accountId,
            paidAmount: paidAmountValue == null
                ? null
                : _toMinorUnits(paidAmountValue),
            paidDate: _parseDate(paidDate),
          );
          break;
        case _AccountKind.person:
          await _peopleRepository.insertPeople(
            account: accountId,
            address: _cleanOptional(address),
            email: _cleanOptional(email),
            phone: _cleanOptional(phone),
            tin: _cleanOptional(tin),
            zip: _cleanOptional(zip),
          );
          break;
      }

      await _balancesRepository.insertBalance(
        account: accountId,
        amount: openingBalanceMinor,
      );
    } catch (e) {
      return _error(
        code: 'account_creation_failed',
        message: 'Failed to create account "$trimmedName": $e',
      );
    }

    return <String, dynamic>{
      'ok': true,
      'tool': 'create_finance_account',
      'account': <String, dynamic>{
        'id': accountId,
        'name': trimmedName,
        'account_type': kind.key,
        'account_type_label': kind.label,
        'opening_balance': openingBalanceValue,
        'opening_balance_minor': openingBalanceMinor,
        'open_date': _formatDate(effectiveOpenDate),
        'currency': profile.currency.isoCode,
      },
      'message':
          'Created ${kind.label.toLowerCase()} "$trimmedName" with opening balance '
          '${openingBalanceValue.toStringAsFixed(3)} ${profile.currency.isoCode}.',
    };
  }

  Future<Map<String, dynamic>> createProject({
    required String name,
    String? description,
    String? startDate,
    String? endDate,
    String? status,
    String? budgetName,
  }) async {
    final Profile? profile = _appViewmodel.selectedProfile;
    if (profile == null) {
      return _error(
        code: 'no_active_profile',
        message: 'No active finance profile found.',
      );
    }

    final String trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return _error(
        code: 'invalid_project_name',
        message: 'Project name is required.',
      );
    }

    final List<Project> existingProjects = await _projectsRepository
        .getAllProjects(profile.dbID);
    final bool duplicate = existingProjects.any(
      (Project project) => _normalize(project.name) == _normalize(trimmedName),
    );
    if (duplicate) {
      return _error(
        code: 'duplicate_project_name',
        message: 'A project named "$trimmedName" already exists.',
      );
    }

    int? budgetId;
    String? resolvedBudgetName;
    if ((budgetName ?? '').trim().isNotEmpty) {
      final budgets = await _budgetsRepository.getAll(profile.dbID);
      final _RankedMatch<dynamic>? budgetMatch = _bestMatch<dynamic>(
        query: budgetName!,
        items: budgets,
        labelOf: (dynamic budget) => budget.name as String,
      );
      if (budgetMatch == null) {
        return _error(
          code: 'budget_not_found',
          message: 'No budget matched "$budgetName".',
          extra: <String, dynamic>{
            'available_budgets': budgets
                .map((budget) => budget.name)
                .toList(growable: false),
          },
        );
      }
      budgetId = budgetMatch.value.dbID as int;
      resolvedBudgetName = budgetMatch.value.name as String;
    }

    final ProjectStatus projectStatus =
        _ProjectStatusParser.parse(status) ?? ProjectStatus.pending;
    final DateTime? parsedStartDate = _parseDate(startDate);
    final DateTime? parsedEndDate = _parseDate(endDate);

    final int projectId = await _projectsRepository.insertProject(
      name: trimmedName,
      budget: budgetId,
      profile: profile.dbID,
      description: _cleanOptional(description),
      startDate: parsedStartDate,
      endDate: parsedEndDate,
      projectStatus: projectStatus,
    );

    return <String, dynamic>{
      'ok': true,
      'tool': 'create_finance_project',
      'project': <String, dynamic>{
        'id': projectId,
        'name': trimmedName,
        'description': _cleanOptional(description),
        'start_date': parsedStartDate == null
            ? null
            : _formatDate(parsedStartDate),
        'end_date': parsedEndDate == null ? null : _formatDate(parsedEndDate),
        'status': projectStatus.name,
        'budget': resolvedBudgetName,
      },
      'message': 'Created project "$trimmedName".',
    };
  }

  Future<Map<String, dynamic>> createBudget({
    required String name,
    String? details,
    String? interval,
    List<dynamic>? incomeItems,
    List<dynamic>? expenseItems,
    List<dynamic>? fundAccountNames,
  }) async {
    final Profile? profile = _appViewmodel.selectedProfile;
    if (profile == null) {
      return _error(
        code: 'no_active_profile',
        message: 'No active finance profile found.',
      );
    }

    final String trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return _error(
        code: 'invalid_budget_name',
        message: 'Budget name is required.',
      );
    }

    final existingBudgets = await _budgetsRepository.getAll(profile.dbID);
    final bool duplicate = existingBudgets.any(
      (budget) => _normalize(budget.name) == _normalize(trimmedName),
    );
    if (duplicate) {
      return _error(
        code: 'duplicate_budget_name',
        message: 'A budget named "$trimmedName" already exists.',
      );
    }

    final List<Ledger> fundLedgers = await _accountsRepository
        .getLedgersByCategory(
          profileId: profile.dbID,
          accTypeIDs: fundingAccountIDs,
        );
    final List<Ledger> incomeLedgers = await _accountsRepository
        .getLedgersByCategory(
          profileId: profile.dbID,
          accTypeIDs: const <int>[incomeTypeID],
        );
    final List<Ledger> expenseLedgers = await _accountsRepository
        .getLedgersByCategory(
          profileId: profile.dbID,
          accTypeIDs: const <int>[expenseTypeID],
        );

    final BudgetInterval budgetInterval =
        _BudgetIntervalParser.parse(interval) ?? BudgetInterval.monthly;
    final List<String> warnings = <String>[];

    final List<int> selectedFundIds = <int>[];
    if (fundAccountNames == null || fundAccountNames.isEmpty) {
      selectedFundIds.addAll(
        fundLedgers.map((Ledger ledger) => ledger.account.dbID),
      );
      if (selectedFundIds.isEmpty) {
        return _error(
          code: 'no_fund_accounts',
          message: 'No funding accounts are available for budget creation.',
        );
      }
      warnings.add('Used all funding accounts because none were specified.');
    } else {
      for (final dynamic rawName in fundAccountNames) {
        final _MatchOutcome<Ledger> match = _resolveLedger(
          query: rawName?.toString(),
          fallbackQuery: null,
          ledgers: fundLedgers,
          allowSingleFallback: false,
        );
        if (!match.ok || match.value == null) {
          return _error(
            code: 'fund_account_not_found',
            message: match.message ?? 'Unable to resolve budget fund accounts.',
          );
        }
        selectedFundIds.add(match.value!.account.dbID);
        warnings.addAll(match.warnings);
      }
    }

    final _BudgetItemsResolution incomeResolution = _resolveBudgetItems(
      rawItems: incomeItems,
      ledgers: incomeLedgers,
      negate: false,
    );
    if (!incomeResolution.ok) {
      return _error(
        code: 'invalid_budget_income_items',
        message: incomeResolution.message ?? 'Invalid income entries.',
      );
    }

    final _BudgetItemsResolution expenseResolution = _resolveBudgetItems(
      rawItems: expenseItems,
      ledgers: expenseLedgers,
      negate: true,
    );
    if (!expenseResolution.ok) {
      return _error(
        code: 'invalid_budget_expense_items',
        message: expenseResolution.message ?? 'Invalid expense entries.',
      );
    }

    final Map<int, int> accountAmounts = <int, int>{}
      ..addAll(incomeResolution.accountAmounts)
      ..addAll(expenseResolution.accountAmounts);
    warnings
      ..addAll(incomeResolution.warnings)
      ..addAll(expenseResolution.warnings);

    if (accountAmounts.isEmpty) {
      return _error(
        code: 'empty_budget_items',
        message: 'At least one income or expense item is required.',
      );
    }

    final int budgetId = await _budgetsRepository.insertBudget(
      trimmedName,
      _cleanOptional(details) ?? '',
      selectedFundIds.toSet().toList(growable: false),
      accountAmounts,
      budgetInterval,
      profile.dbID,
    );

    return <String, dynamic>{
      'ok': true,
      'tool': 'create_finance_budget',
      'budget': <String, dynamic>{
        'id': budgetId,
        'name': trimmedName,
        'details': _cleanOptional(details),
        'interval': budgetInterval.name,
        'fund_account_ids': selectedFundIds.toSet().toList(growable: false),
      },
      if (warnings.isNotEmpty) 'warnings': warnings,
      'message': 'Created budget "$trimmedName".',
    };
  }

  Future<Map<String, dynamic>> createPaymentReminder({
    required Object? amount,
    required String details,
    String? payableAccountName,
    String? fundAccountName,
    String? interval,
    Object? day,
    String? paymentDate,
    String? status,
  }) async {
    final Profile? profile = _appViewmodel.selectedProfile;
    if (profile == null) {
      return _error(
        code: 'no_active_profile',
        message: 'No active finance profile found.',
      );
    }

    final String trimmedDetails = details.trim();
    if (trimmedDetails.isEmpty) {
      return _error(
        code: 'invalid_reminder_details',
        message: 'Reminder details are required.',
      );
    }

    final double? amountValue = _parseAmount(amount);
    if (amountValue == null || amountValue <= 0) {
      return _error(
        code: 'invalid_amount',
        message: 'Reminder amount must be a positive number.',
      );
    }

    final int amountMinor = _toMinorUnits(amountValue);
    final List<Ledger> allLedgers = await _accountsRepository.getLedgers(
      profileId: profile.dbID,
    );
    final List<Ledger> fundLedgers = allLedgers
        .where(
          (Ledger ledger) =>
              fundingAccountIDs.contains(ledger.account.accountType),
        )
        .toList(growable: false);

    final _MatchOutcome<Ledger> accountMatch = _resolveLedger(
      query: payableAccountName,
      fallbackQuery: trimmedDetails,
      ledgers: allLedgers,
      allowSingleFallback: false,
    );
    if (!accountMatch.ok || accountMatch.value == null) {
      return _error(
        code: 'account_not_found',
        message:
            accountMatch.message ??
            'Unable to resolve the payable account for the reminder.',
      );
    }

    final _MatchOutcome<Ledger> fundMatch = _resolveLedger(
      query: fundAccountName,
      fallbackQuery: null,
      ledgers: fundLedgers,
      allowSingleFallback: true,
    );
    if (!fundMatch.ok || fundMatch.value == null) {
      return _error(
        code: 'fund_account_not_found',
        message:
            fundMatch.message ??
            'Unable to resolve the funding account for the reminder.',
      );
    }

    final BudgetInterval? reminderInterval = _BudgetIntervalParser.parse(
      interval,
      allowAnnual: false,
    );
    final DateTime? parsedPaymentDate = _parseDate(paymentDate);
    if (reminderInterval == null && parsedPaymentDate == null) {
      return _error(
        code: 'missing_schedule',
        message:
            'Provide either payment_date for a one-time reminder or interval/day for a repeating reminder.',
      );
    }

    final int reminderDay = _parseReminderDay(day, reminderInterval);
    if (reminderInterval != null && reminderDay <= 0) {
      return _error(
        code: 'invalid_reminder_day',
        message: 'A valid reminder day is required for repeating reminders.',
      );
    }

    final PaymentStatus paymentStatus =
        _PaymentStatusParser.parse(status) ?? PaymentStatus.pending;

    final int reminderId = await _paymentRemindersRepository
        .insertPaymentReminder(
          profile: profile.dbID,
          account: accountMatch.value!.account,
          fund: fundMatch.value!.account,
          interval: reminderInterval,
          day: reminderDay,
          amount: amountMinor,
          paymentDate: parsedPaymentDate,
          status: paymentStatus,
          details: trimmedDetails,
        );

    await finance_notifications.NotificationService.schedulePaymentReminder(
      id: reminderId,
      title:
          "Today's payment reminder : ${amountValue.toStringAsFixed(3)} ${profile.currency.isoCode}",
      body: 'Towards $trimmedDetails',
      isWeekly: reminderInterval == BudgetInterval.weekly,
      startDateTime: DateTime.now().copyWith(hour: 8, minute: 0, second: 0),
      monthDay: reminderInterval == BudgetInterval.monthly ? reminderDay : null,
      weekday: reminderInterval == BudgetInterval.weekly ? reminderDay : null,
      paymentDate: reminderInterval == null ? parsedPaymentDate : null,
    );

    final List<String> warnings = <String>[
      ...accountMatch.warnings,
      ...fundMatch.warnings,
    ];

    return <String, dynamic>{
      'ok': true,
      'tool': 'create_finance_payment_reminder',
      'reminder': <String, dynamic>{
        'id': reminderId,
        'details': trimmedDetails,
        'amount': amountValue,
        'amount_minor': amountMinor,
        'status': paymentStatus.name,
        'account': accountMatch.value!.account.name,
        'fund_account': fundMatch.value!.account.name,
        'interval': reminderInterval?.name,
        'day': reminderInterval == null ? null : reminderDay,
        'payment_date': parsedPaymentDate == null
            ? null
            : _formatDate(parsedPaymentDate),
      },
      if (warnings.isNotEmpty) 'warnings': warnings,
      'message': 'Created payment reminder "$trimmedDetails".',
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

  static int? _parseInt(Object? raw) {
    if (raw == null) {
      return null;
    }
    if (raw is int) {
      return raw;
    }
    if (raw is num) {
      return raw.toInt();
    }
    return int.tryParse(raw.toString().trim());
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

  static int _toMinorUnits(double value) => (value * 1000).round();

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

  static String? _cleanOptional(String? value) {
    final String trimmed = (value ?? '').trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static int _parseReminderDay(Object? raw, BudgetInterval? interval) {
    if (interval == null) {
      return 0;
    }
    if (raw is num) {
      return raw.toInt();
    }
    final String value = _normalize((raw ?? '').toString());
    if (value.isEmpty) {
      return 0;
    }
    final int? parsed = int.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
    if (interval == BudgetInterval.weekly) {
      return switch (value) {
        'monday' || 'mon' => 1,
        'tuesday' || 'tue' || 'tues' => 2,
        'wednesday' || 'wed' => 3,
        'thursday' || 'thu' || 'thurs' => 4,
        'friday' || 'fri' => 5,
        'saturday' || 'sat' => 6,
        'sunday' || 'sun' => 7,
        _ => 0,
      };
    }
    return 0;
  }

  _BudgetItemsResolution _resolveBudgetItems({
    required List<dynamic>? rawItems,
    required List<Ledger> ledgers,
    required bool negate,
  }) {
    final Map<int, int> accountAmounts = <int, int>{};
    final List<String> warnings = <String>[];
    if (rawItems == null || rawItems.isEmpty) {
      return _BudgetItemsResolution.success(
        accountAmounts: accountAmounts,
        warnings: warnings,
      );
    }

    for (final dynamic rawItem in rawItems) {
      if (rawItem is! Map) {
        return const _BudgetItemsResolution.failure(
          message: 'Budget items must be objects with name and amount.',
        );
      }
      final String itemName = (rawItem['name'] ?? '').toString().trim();
      final double? amountValue = _parseAmount(rawItem['amount']);
      if (itemName.isEmpty || amountValue == null || amountValue <= 0) {
        return _BudgetItemsResolution.failure(
          message: 'Invalid budget item "$rawItem".',
        );
      }

      final _MatchOutcome<Ledger> match = _resolveLedger(
        query: itemName,
        fallbackQuery: null,
        ledgers: ledgers,
        allowSingleFallback: false,
      );
      if (!match.ok || match.value == null) {
        return _BudgetItemsResolution.failure(
          message: match.message ?? 'Unable to resolve "$itemName".',
        );
      }

      accountAmounts[match.value!.account.dbID] =
          (negate ? -1 : 1) * _toMinorUnits(amountValue);
      warnings.addAll(match.warnings);
    }

    return _BudgetItemsResolution.success(
      accountAmounts: accountAmounts,
      warnings: warnings,
    );
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
          'Only one matching account was available, so it was used automatically.',
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

class _BudgetItemsResolution {
  const _BudgetItemsResolution._({
    required this.ok,
    this.message,
    this.accountAmounts = const <int, int>{},
    this.warnings = const <String>[],
  });

  const _BudgetItemsResolution.success({
    required Map<int, int> accountAmounts,
    List<String> warnings = const <String>[],
  }) : this._(ok: true, accountAmounts: accountAmounts, warnings: warnings);

  const _BudgetItemsResolution.failure({required String message})
    : this._(ok: false, message: message);

  final bool ok;
  final String? message;
  final Map<int, int> accountAmounts;
  final List<String> warnings;
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

enum _AccountKind {
  wallet(key: 'wallet', label: 'Wallet', accountTypeId: walletTypeID),
  bank(key: 'bank', label: 'Bank Account', accountTypeId: bankTypeID),
  creditCard(
    key: 'credit_card',
    label: 'Credit Card',
    accountTypeId: cCardTypeID,
  ),
  loan(key: 'loan', label: 'Loan', accountTypeId: loanTypeID),
  advance(key: 'advance', label: 'Receivable', accountTypeId: advanceTypeID),
  person(key: 'person', label: 'Person', accountTypeId: peopleTypeID);

  const _AccountKind({
    required this.key,
    required this.label,
    required this.accountTypeId,
  });

  final String key;
  final String label;
  final int accountTypeId;
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

extension _AccountKindParser on _AccountKind {
  static _AccountKind? parse(String raw) {
    switch (FinanceTransactionActionService._normalize(raw)) {
      case 'wallet':
      case 'cash':
        return _AccountKind.wallet;
      case 'bank':
      case 'bank account':
      case 'checking':
      case 'savings':
        return _AccountKind.bank;
      case 'credit card':
      case 'creditcard':
      case 'card':
        return _AccountKind.creditCard;
      case 'loan':
        return _AccountKind.loan;
      case 'advance':
      case 'receivable':
        return _AccountKind.advance;
      case 'person':
      case 'people':
      case 'contact':
        return _AccountKind.person;
      default:
        return null;
    }
  }
}

extension _BudgetIntervalParser on BudgetInterval {
  static BudgetInterval? parse(String? raw, {bool allowAnnual = true}) {
    final String value = FinanceTransactionActionService._normalize(raw ?? '');
    return switch (value) {
      'weekly' || 'week' => BudgetInterval.weekly,
      'monthly' || 'month' => BudgetInterval.monthly,
      'annual' || 'annually' || 'yearly' || 'year' when allowAnnual =>
        BudgetInterval.annual,
      '' => null,
      _ => null,
    };
  }
}

extension _ProjectStatusParser on ProjectStatus {
  static ProjectStatus? parse(String? raw) {
    final String value = FinanceTransactionActionService._normalize(raw ?? '');
    return switch (value) {
      'pending' => ProjectStatus.pending,
      'started' || 'start' || 'active' => ProjectStatus.started,
      'on hold' || 'hold' => ProjectStatus.onHold,
      'cancelled' || 'canceled' => ProjectStatus.cancelled,
      'completed' || 'complete' || 'done' => ProjectStatus.completed,
      'abandoned' => ProjectStatus.abandoned,
      'failed' => ProjectStatus.failed,
      _ => null,
    };
  }
}

extension _PaymentStatusParser on PaymentStatus {
  static PaymentStatus? parse(String? raw) {
    final String value = FinanceTransactionActionService._normalize(raw ?? '');
    return switch (value) {
      'pending' => PaymentStatus.pending,
      'paid' => PaymentStatus.paid,
      'cancelled' || 'canceled' => PaymentStatus.cancelled,
      'overdue' => PaymentStatus.overdue,
      _ => null,
    };
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
