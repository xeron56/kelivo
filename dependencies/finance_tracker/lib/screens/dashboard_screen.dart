import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/repositories/drift/account_types_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/accounts_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/balances_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/profiles_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/transactions_drift_repository.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/screens/accounts_screen.dart';
import 'package:finance_tracker/screens/budgets_screen.dart';
import 'package:finance_tracker/screens/payment_reminders_screen.dart';
import 'package:finance_tracker/screens/projects_screen.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/viewmodels/dashboard_viewmodel.dart';
import 'package:finance_tracker/widgets/dashboard/add_new_account_card.dart';
import 'package:finance_tracker/widgets/dashboard/add_transaction_card.dart';
import 'package:finance_tracker/widgets/dashboard/my_balance_card.dart';
import 'package:finance_tracker/widgets/dashboard/transactions_card.dart';
import 'package:finance_tracker/widgets/shared/loading_body.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final profilesDriftRepository = Provider.of<ProfilesDriftRepository>(
      context,
      listen: false,
    );
    final accountsDriftRepository = Provider.of<AccountsDriftRepository>(
      context,
      listen: false,
    );
    final transactionsDriftRepository =
        Provider.of<TransactionsDriftRepository>(context, listen: false);
    final balancesDriftRepository = Provider.of<BalancesDriftRepository>(
      context,
      listen: false,
    );
    final accountTypesDriftRepository =
        Provider.of<AccountTypesDriftRepository>(context, listen: false);
    final appViewmodel = Provider.of<AppViewmodel>(context);

    return ChangeNotifierProvider<DashboardViewmodel>(
      create: (context) => DashboardViewmodel(
        profilesDriftRepository,
        accountsDriftRepository,
        transactionsDriftRepository,
        balancesDriftRepository,
        accountTypesDriftRepository,
        profile: profile,
      )..init(),
      child: Consumer<DashboardViewmodel>(
        builder: (context, viewmodel, child) => LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 1120;
            final isMedium = constraints.maxWidth >= 760;
            final contentWidth = constraints.maxWidth > 1320
                ? 1320.0
                : constraints.maxWidth;

            return Scaffold(
              backgroundColor: const Color(0xFFF8F8FA),
              body: LoadingBody(
                loadingStatus: viewmodel.loadingStatus,
                errorText: viewmodel.errorText,
                resetErrorTextFn: () => viewmodel.resetErrorText(),
                widget: SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: contentWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _DashboardHero(
                              profile: profile,
                              viewmodel: viewmodel,
                            ),
                            const SizedBox(height: 24),
                            if (isWide)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: MyBalanceCard(
                                      profile: profile,
                                      viewmodel: viewmodel,
                                      isWide: true,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      children: [
                                        if (viewmodel.canAddTransaction)
                                          AddTransactionCard(
                                            appViewmodel: appViewmodel,
                                            profile: profile,
                                            viewmodel: viewmodel,
                                          ),
                                        if (viewmodel.canAddTransaction &&
                                            viewmodel.fAccountTypes.isNotEmpty)
                                          const SizedBox(height: 20),
                                        if (viewmodel.fAccountTypes.isNotEmpty)
                                          AddNewAccountCard(
                                            viewmodel: viewmodel,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            else ...[
                              MyBalanceCard(
                                profile: profile,
                                viewmodel: viewmodel,
                                isWide: false,
                              ),
                              if (viewmodel.canAddTransaction) ...[
                                const SizedBox(height: 20),
                                AddTransactionCard(
                                  appViewmodel: appViewmodel,
                                  profile: profile,
                                  viewmodel: viewmodel,
                                ),
                              ],
                            ],
                            const SizedBox(height: 24),
                            _SectionShell(
                              title: 'Quick actions',
                              subtitle:
                                  'Jump into the areas you use most during the day.',
                              child: _QuickActionsGrid(
                                isMedium: isMedium,
                                onBudgetTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BudgetsScreen(
                                        profile: viewmodel.selectedProfile,
                                      ),
                                    ),
                                  );
                                },
                                onProjectsTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProjectsScreen(
                                        profile: viewmodel.selectedProfile,
                                      ),
                                    ),
                                  );
                                },
                                onRemindersTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PaymentRemindersScreen(
                                            profile: profile,
                                          ),
                                    ),
                                  );
                                },
                                onAccountsTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AccountsScreen(
                                        profile: viewmodel.selectedProfile,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (!isWide &&
                                viewmodel.fAccountTypes.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              AddNewAccountCard(viewmodel: viewmodel),
                            ],
                            if (viewmodel.recentTransactions.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              TransactionsCard(viewmodel: viewmodel),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({required this.profile, required this.viewmodel});

  final Profile profile;
  final DashboardViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE7E7EC)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: colorScheme.primary,
                  size: 28,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.myDashboard,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Track balances, recent activity, and next actions for ${profile.name}.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6E6E7A),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _HeroMetricChip(
                icon: Icons.receipt_long_outlined,
                label: 'Recent transactions',
                value: '${viewmodel.recentTransactions.length}',
              ),
              _HeroMetricChip(
                icon: Icons.account_tree_outlined,
                label: 'Accounts ready',
                value: '${viewmodel.allLedgers.length}',
              ),
              _HeroMetricChip(
                icon: Icons.add_chart_outlined,
                label: 'Actions available',
                value: '${viewmodel.canAddTransaction ? 2 : 1}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetricChip extends StatelessWidget {
  const _HeroMetricChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFD),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9E9EF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF72727D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE7E7EC)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF70707B),
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({
    required this.isMedium,
    required this.onBudgetTap,
    required this.onProjectsTap,
    required this.onRemindersTap,
    required this.onAccountsTap,
  });

  final bool isMedium;
  final VoidCallback onBudgetTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onRemindersTap;
  final VoidCallback onAccountsTap;

  @override
  Widget build(BuildContext context) {
    final actions = [
      (
        title: AppLocalizations.of(context)!.budgets,
        subtitle: 'Review monthly targets and spending limits.',
        icon: Icons.calculate_outlined,
        onTap: onBudgetTap,
      ),
      (
        title: AppLocalizations.of(context)!.projects,
        subtitle: 'Organize work, goals, and tagged expenses.',
        icon: Icons.assignment_outlined,
        onTap: onProjectsTap,
      ),
      (
        title: AppLocalizations.of(context)!.reminders,
        subtitle: 'Stay ahead of scheduled bills and due dates.',
        icon: Icons.event_available_outlined,
        onTap: onRemindersTap,
      ),
      (
        title: AppLocalizations.of(context)!.accounts,
        subtitle: 'Inspect accounts, balances, and funding sources.',
        icon: Icons.account_balance_wallet_outlined,
        onTap: onAccountsTap,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = isMedium ? 4 : 2;
        final spacing = 14.0;
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: actions
              .map(
                (action) => SizedBox(
                  width: itemWidth.clamp(140.0, 320.0),
                  child: _QuickActionTile(
                    title: action.title,
                    subtitle: action.subtitle,
                    icon: action.icon,
                    onTap: action.onTap,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: const Color(0xFFF9FAFD),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE7EAF3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF757582),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
