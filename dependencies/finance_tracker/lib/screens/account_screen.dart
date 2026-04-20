import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/core/enums/app_date_format.dart';
import 'package:finance_tracker/core/enums/loading_status.dart';
import 'package:finance_tracker/core/enums/voucher_type.dart';
import 'package:finance_tracker/core/models/domain/account.dart';
import 'package:finance_tracker/core/models/domain/bank.dart';
import 'package:finance_tracker/core/models/domain/credit_card.dart';
import 'package:finance_tracker/core/models/domain/loan.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/models/domain/wallet.dart';
import 'package:finance_tracker/core/repositories/drift/accounts_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/balances_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/transactions_drift_repository.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/screens/account_entry_screen.dart';
import 'package:finance_tracker/viewmodels/account_viewmodel.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/acc_type_icon.dart';
import 'package:finance_tracker/widgets/shared/empty_list.dart';
import 'package:finance_tracker/widgets/shared/export_button.dart';
import 'package:finance_tracker/widgets/shared/loading_body.dart';
import 'package:finance_tracker/widgets/shared/search_field.dart';
import 'package:finance_tracker/widgets/shared/the_date_picker.dart';
import 'package:finance_tracker/widgets/shared/the_divider.dart';
import 'package:finance_tracker/widgets/shared/transaction_options_dialog.dart';
import 'package:finance_tracker/widgets/shared/transactions_list.dart';
import 'package:finance_tracker/widgets/shared/transactions_list_wide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({
    super.key,
    required this.profile,
    required this.account,
    this.wallet,
    this.bank,
    this.cCard,
    this.loan,
  });

  final Profile profile;
  final Account account;
  final Wallet? wallet;
  final Bank? bank;
  final CreditCard? cCard;
  final Loan? loan;

  @override
  Widget build(BuildContext context) {
    final balancesDriftRepository = Provider.of<BalancesDriftRepository>(
      context,
      listen: false,
    );
    final accountsDriftRepository = Provider.of<AccountsDriftRepository>(
      context,
      listen: false,
    );
    final transactionsDriftRepository =
        Provider.of<TransactionsDriftRepository>(context, listen: false);
    final appViewmodel = Provider.of<AppViewmodel>(context);

    return ChangeNotifierProvider<AccountViewmodel>(
      create: (context) => AccountViewmodel(
        transactionsDriftRepository,
        balancesDriftRepository,
        accountsDriftRepository,
        profile: profile,
        account: account,
      )..init(),
      builder: (context, child) => Consumer<AccountViewmodel>(
        builder: (context, viewmodel, child) => Scaffold(
          backgroundColor: const Color(0xFFF8F8FB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(viewmodel.account.name),
            actions: [
              IconButton(
                tooltip: AppLocalizations.of(context)!.edit,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountEntryScreen(
                        profile: profile,
                        account: account,
                      ),
                    ),
                  ).then((_) => viewmodel.init());
                },
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: AppLocalizations.of(context)!.add,
                onPressed: () async {
                  await showDialog(
                    context: context,
                    useRootNavigator: false,
                    builder: (context) => TransactionOptionsDialog(
                      currency: profile.currency,
                      ledgers: viewmodel.allLedgers,
                      profile: profile,
                      appViewmodel: appViewmodel,
                      vType: account.accountType == 5
                          ? VoucherType.payment
                          : VoucherType.receipt,
                      oAcc: account,
                      reloadFn: () async {
                        await viewmodel.init();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline_rounded),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: LoadingBody(
            loadingStatus: viewmodel.loadingStatus,
            errorText: viewmodel.errorText,
            resetErrorTextFn: viewmodel.resetErrorText,
            widget: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 980;
                final datePattern = appViewmodel.dateFormat.pattern ??
                    AppDateFormat.date1.pattern;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1320),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isWide)
                            SizedBox(
                              width: 320,
                              child: _FilterPanel(
                                viewmodel: viewmodel,
                                datePattern: datePattern,
                              ),
                            ),
                          if (isWide) const SizedBox(width: 20),
                          Expanded(
                            child: TransactionsSection(
                              viewmodel: viewmodel,
                              isWide: isWide,
                              constraints: constraints,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          endDrawer: Drawer(
            backgroundColor: const Color(0xFFFDFDFF),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                bottomLeft: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _FilterPanel(
                  viewmodel: viewmodel,
                  datePattern:
                      appViewmodel.dateFormat.pattern ??
                          AppDateFormat.date1.pattern,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.viewmodel,
    required this.datePattern,
  });

  final AccountViewmodel viewmodel;
  final String datePattern;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE7E7EF)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.filters,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Refine the account activity by date, voucher type, and the related account involved in each transaction.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B7080),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            _FilterSection(
              title: l10n.dates,
              child: Column(
                children: [
                  TheDatePicker(
                    initialDate: viewmodel.startDate,
                    onChanged: (d) {
                      viewmodel.addToFilter(sDate: d);
                    },
                    label: l10n.startDate,
                    needTime: false,
                    datePattern: datePattern,
                  ),
                  const SizedBox(height: 12),
                  TheDatePicker(
                    initialDate: viewmodel.endDate,
                    onChanged: (d) {
                      viewmodel.addToFilter(eDate: d);
                    },
                    label: l10n.endDate,
                    needTime: false,
                    datePattern: datePattern,
                  ),
                ],
              ),
            ).animate().fade(duration: 160.ms).slideX(begin: -.03),
            if (viewmodel.transactions.isNotEmpty) ...[
              const SizedBox(height: 14),
              _FilterSection(
                title: l10n.transactionTypes,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...viewmodel.voucherTypes.map(
                      (voucherType) => FilterChip(
                        showCheckmark: false,
                        selected: !viewmodel.voucherTypeFilters
                            .contains(voucherType),
                        label: Text(voucherType.label),
                        onSelected: (_) {
                          viewmodel.addToFilter(voucherType: voucherType);
                        },
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 40.ms).fade(duration: 160.ms).slideX(begin: -.03),
              const SizedBox(height: 14),
              _FilterSection(
                title: l10n.funds,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...viewmodel.otherAccounts.map(
                      (otherAccount) => FilterChip(
                        showCheckmark: false,
                        selected: !viewmodel.otherAccountFilters
                            .contains(otherAccount.dbID),
                        label: Text(otherAccount.name),
                        onSelected: (_) {
                          viewmodel.addToFilter(oAcc: otherAccount);
                        },
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 80.ms).fade(duration: 160.ms).slideX(begin: -.03),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFD),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE7E7EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Expanded(child: Padding(
                padding: EdgeInsets.only(left: 12),
                child: TheDivider(),
              )),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class TransactionsSection extends StatelessWidget {
  const TransactionsSection({
    super.key,
    required this.viewmodel,
    required this.isWide,
    required this.constraints,
  });

  final AccountViewmodel viewmodel;
  final bool isWide;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final appViewmodel = Provider.of<AppViewmodel>(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: appViewmodel.isPhone ? smallWidth : double.maxFinite,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE7E7EF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C141A24),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: viewmodel.headerHeight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: isWide ? 420 : double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4FA),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        getAccTypeIcon(
                                          viewmodel.account.accountType,
                                        ),
                                        size: 18,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Account overview',
                                        style: theme.textTheme.labelLarge,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  viewmodel.account.name,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    height: 1.08,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  l10n.fromToDate(
                                    appViewmodel.dateFormat
                                        .format(viewmodel.startDate),
                                    appViewmodel.dateFormat
                                        .format(viewmodel.endDate),
                                  ),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF6B7080),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _BalancePill(
                                label: l10n.openingBalance,
                                value: viewmodel.openBal.toCurrencyString(
                                  viewmodel.profile.currency,
                                ),
                              ),
                              _BalancePill(
                                label: l10n.closingBalance,
                                value: viewmodel.closeBal.toCurrencyString(
                                  viewmodel.profile.currency,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F7FB),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: ExportButton(
                                  pdfExportFn: () async {
                                    await viewmodel.exportPDF();
                                  },
                                  xlsxExportFn: () async {
                                    await viewmodel.exportXLSX();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F7FB),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: SearchField(
                                searchFn: (term) {
                                  viewmodel.searchTerm = term;
                                },
                              ),
                            ),
                          ),
                          if (!isWide) ...[
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F7FB),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Builder(
                                builder: (innerContext) => IconButton(
                                  onPressed: () {
                                    Scaffold.of(innerContext).openEndDrawer();
                                  },
                                  icon: const Icon(Icons.tune_rounded),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDFDFF),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE8EAF2)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                          child: Row(
                            children: [
                              Text(
                                'Transaction history',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${viewmodel.fTransactions.length} items',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF6F7382),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                child: _InlineBalanceCard(
                                  label: l10n.openingBalance,
                                  value: viewmodel.openBal.toCurrencyString(
                                    viewmodel.profile.currency,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _InlineBalanceCard(
                                  label: l10n.closingBalance,
                                  value: viewmodel.closeBal.toCurrencyString(
                                    viewmodel.profile.currency,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Builder(
                            builder: (_) {
                              if (viewmodel.searchLoadingStatus !=
                                  LoadingStatus.completed) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (viewmodel.fTransactions.isEmpty) {
                                return EmptyList(
                                  items: l10n.transactions,
                                  addFn: () async {
                                    await showDialog(
                                      context: context,
                                      useRootNavigator: false,
                                      builder: (context) =>
                                          TransactionOptionsDialog(
                                        currency: viewmodel.profile.currency,
                                        ledgers: viewmodel.allLedgers,
                                        profile: viewmodel.profile,
                                        appViewmodel: appViewmodel,
                                        vType:
                                            viewmodel.account.accountType == 5
                                                ? VoucherType.payment
                                                : VoucherType.receipt,
                                        oAcc: viewmodel.account,
                                        reloadFn: () async {
                                          await viewmodel.init();
                                        },
                                      ),
                                    );
                                  },
                                  isListFiltered: true,
                                );
                              }

                              if (!appViewmodel.isPhone) {
                                return TransactionsListWide(
                                  scrollController: viewmodel.scrollController,
                                  fTransactions: viewmodel.fTransactions,
                                  profile: viewmodel.profile,
                                  account: viewmodel.account,
                                  initFn: () {
                                    viewmodel.init();
                                  },
                                );
                              }

                              return TransactionsList(
                                scrollController: viewmodel.scrollController,
                                fDates: viewmodel.fDates,
                                fTransactions: viewmodel.fTransactions,
                                profile: viewmodel.profile,
                                account: viewmodel.account,
                                initFn: () {
                                  viewmodel.init();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalancePill extends StatelessWidget {
  const _BalancePill({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EAF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF737789),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineBalanceCard extends StatelessWidget {
  const _InlineBalanceCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E7EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF737789),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
