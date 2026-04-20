import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/app/global/values.dart';
import 'package:finance_tracker/core/enums/loading_status.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/repositories/drift/account_types_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/accounts_drift_repository.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/screens/account_entry_screen.dart';
import 'package:finance_tracker/screens/account_screen.dart';
import 'package:finance_tracker/viewmodels/accounts_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/acc_type_icon.dart';
import 'package:finance_tracker/widgets/shared/loading_body.dart';
import 'package:finance_tracker/widgets/shared/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({
    super.key,
    required this.profile,
    this.accType,
  });

  final Profile profile;
  final int? accType;

  @override
  Widget build(BuildContext context) {
    final accountTypesDriftRepository =
        Provider.of<AccountTypesDriftRepository>(context, listen: false);
    final accountsDriftRepository =
        Provider.of<AccountsDriftRepository>(context, listen: false);

    return ChangeNotifierProvider<AccountsViewmodel>(
      create: (context) => AccountsViewmodel(
        accountsDriftRepository,
        accountTypesDriftRepository,
        profile: profile,
      )..init(),
      builder: (context, child) => Consumer<AccountsViewmodel>(
        builder: (context, viewmodel, child) => Scaffold(
          backgroundColor: const Color(0xFFF8F8FB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(AppLocalizations.of(context)!.accounts),
          ),
          body: LoadingBody(
            loadingStatus: viewmodel.loadingStatus,
            errorText: viewmodel.errorText,
            resetErrorTextFn: viewmodel.resetErrorText,
            widget: AccountsList(viewmodel: viewmodel),
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'addAccount',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text(
                      AppLocalizations.of(
                        context,
                      )!
                          .select(AppLocalizations.of(context)!.accountType),
                    ),
                    children: [
                      ...viewmodel.accTypes.map(
                        (a) => ListTile(
                          title: Text(
                            a.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccountEntryScreen(
                                  profile: profile,
                                  accountType: a,
                                ),
                              ),
                            ).then((_) => viewmodel.init());
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.accounts),
          ),
        ),
      ),
    );
  }
}

class AccountsList extends StatelessWidget {
  const AccountsList({
    super.key,
    required this.viewmodel,
  });

  final AccountsViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final incomeAccounts =
        viewmodel.accTypeID == incomeTypeID ? viewmodel.fLedgers.length : null;
    final expenseAccounts =
        viewmodel.accTypeID == expenseTypeID ? viewmodel.fLedgers.length : null;
    final totalBalance = viewmodel.fLedgers.fold<int>(
      0,
      (sum, ledger) => sum + ledger.balance,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0xFFE7E7EF)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x120E1320),
                          blurRadius: 24,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 24,
                      runSpacing: 20,
                      children: [
                        SizedBox(
                          width: isWide ? 480 : double.infinity,
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
                                      getAccTypeIcon(viewmodel.accTypeID),
                                      size: 18,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      viewmodel.accType?.name ?? l10n.accounts,
                                      style: theme.textTheme.labelLarge,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.myXAccounts(
                                  viewmodel.accType?.name ?? '',
                                ),
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Browse accounts faster, switch between income and expense ledgers, and jump straight into account details.',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: const Color(0xFF666A78),
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: [
                            _SummaryChip(
                              label: 'Visible accounts',
                              value: '${viewmodel.fLedgers.length}',
                              icon: Icons.account_balance_wallet_outlined,
                            ),
                            _SummaryChip(
                              label: 'Current total',
                              value: totalBalance.toCurrencyString(
                                viewmodel.profile.currency,
                              ),
                              icon: Icons.auto_graph_rounded,
                            ),
                            _SummaryChip(
                              label: 'Mode',
                              value: viewmodel.accType?.name ?? l10n.accounts,
                              icon: Icons.tune_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fade(duration: 180.ms).slideY(begin: .04),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFFE7E7EF)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            if (isWide)
                              Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: _AccountTypeSelector(
                                      viewmodel: viewmodel,
                                      incomeAccounts: incomeAccounts,
                                      expenseAccounts: expenseAccounts,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 5,
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
                                ],
                              )
                            else ...[
                              _AccountTypeSelector(
                                viewmodel: viewmodel,
                                incomeAccounts: incomeAccounts,
                                expenseAccounts: expenseAccounts,
                              ),
                              const SizedBox(height: 12),
                              Container(
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
                            ],
                            const SizedBox(height: 18),
                            Expanded(
                              child: Builder(
                                builder: (_) {
                                  if (viewmodel.searchLoadingStatus !=
                                      LoadingStatus.completed) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  if (viewmodel.fLedgers.isEmpty) {
                                    return Center(
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 440,
                                        ),
                                        padding: const EdgeInsets.all(28),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFBFBFD),
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFE7E7EF),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF0F2FA),
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              child: Icon(
                                                Icons.account_balance_wallet_outlined,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'No accounts match this view',
                                              style: theme
                                                  .textTheme.titleLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Try switching the account type or refining the search to surface the right ledger.',
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color:
                                                    const Color(0xFF666A78),
                                                height: 1.45,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return ListView.separated(
                                    padding: const EdgeInsets.only(bottom: 80),
                                    itemCount: viewmodel.fLedgers.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final ledger = viewmodel.fLedgers[index];
                                      return _AccountLedgerCard(
                                        ledgerName: ledger.account.name,
                                        balance: ledger.balance.toCurrencyString(
                                          viewmodel.profile.currency,
                                        ),
                                        accountType: viewmodel.accType?.name ??
                                            l10n.accounts,
                                        icon: getAccTypeIcon(
                                          ledger.account.accountType,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AccountScreen(
                                                profile: viewmodel.profile,
                                                account: ledger.account,
                                              ),
                                            ),
                                          ).then((_) => viewmodel.init());
                                        },
                                      );
                                    },
                                  )
                                      .animate(delay: 100.ms)
                                      .fade(duration: 160.ms)
                                      .slideY(begin: .03);
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
      },
    );
  }
}

class _AccountTypeSelector extends StatelessWidget {
  const _AccountTypeSelector({
    required this.viewmodel,
    required this.incomeAccounts,
    required this.expenseAccounts,
  });

  final AccountsViewmodel viewmodel;
  final int? incomeAccounts;
  final int? expenseAccounts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TypeButton(
              icon: getAccTypeIcon(incomeTypeID),
              label: l10n.incomes,
              subtitle:
                  incomeAccounts == null ? 'View income ledgers' : '$incomeAccounts accounts',
              selected: viewmodel.accTypeID == incomeTypeID,
              onTap: () {
                viewmodel.accTypeID = incomeTypeID;
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TypeButton(
              icon: getAccTypeIcon(expenseTypeID),
              label: l10n.expenses,
              subtitle: expenseAccounts == null
                  ? 'View expense ledgers'
                  : '$expenseAccounts accounts',
              selected: viewmodel.accTypeID == expenseTypeID,
              onTap: () {
                viewmodel.accTypeID = expenseTypeID;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: selected ? theme.colorScheme.primary : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.18)
                      : const Color(0xFFF3F4FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: selected ? Colors.white : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: selected ? Colors.white : null,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: selected
                            ? Colors.white.withValues(alpha: 0.82)
                            : const Color(0xFF737789),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFD),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8EAF2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2FA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF777B89),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountLedgerCard extends StatelessWidget {
  const _AccountLedgerCard({
    required this.ledgerName,
    required this.balance,
    required this.accountType,
    required this.icon,
    required this.onTap,
  });

  final String ledgerName;
  final String balance;
  final String accountType;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: const Color(0xFFFCFCFE),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE7E7EF)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ledgerName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        accountType,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6F7382),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Current balance',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF7A7E8C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      balance,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
