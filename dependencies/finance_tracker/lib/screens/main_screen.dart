import 'dart:io';

import 'package:flutter/material.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/models/domain/user.dart';
import 'package:finance_tracker/core/repositories/drift/accounts_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/profiles_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/user_drift_repository.dart';
import 'package:finance_tracker/screens/dashboard_screen.dart';
import 'package:finance_tracker/screens/balances_screen.dart';
import 'package:finance_tracker/screens/insights_screen.dart';
import 'package:finance_tracker/screens/transactions_screen.dart';
import 'package:finance_tracker/screens/user_edit_screen.dart';
import 'package:finance_tracker/utils/app_paths.dart';
import 'package:finance_tracker/viewmodels/main_viewmodel.dart';
import 'package:finance_tracker/widgets/main/the_drawer.dart';
import 'package:finance_tracker/widgets/shared/loading_body.dart';
import 'package:path/path.dart' as p;

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
    required this.profile,
    this.embeddedInHost = false,
  });
  final Profile profile;
  final bool embeddedInHost;

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
    final userRepository = Provider.of<UserDriftRepository>(
      context,
      listen: false,
    );

    return ChangeNotifierProvider<MainViewmodel>(
      create: (context) => MainViewmodel(
        profilesDriftRepository,
        accountsDriftRepository,
        userRepository,
        selectedProfile: profile,
      )..init(),
      builder: (context, child) => Consumer<MainViewmodel>(
        builder: (context, viewmodel, child) => LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > smallWidth;
            final isVeryWide = constraints.maxWidth > mediumWidth;
            final loc = AppLocalizations.of(context);
            User? user = Provider.of<MainViewmodel>(
              context,
              listen: false,
            ).user;
            final String securePath = AppPaths.imagesDir;
            final String userPhotoPath = p.join(
              securePath,
              p.basename(user?.photoPath ?? ""),
            );
            final Color primary = Theme.of(context).colorScheme.primary;
            final Color surface = Colors.white;
            final Color shellBackground = const Color(0xFFF7F8FC);
            return Scaffold(
              backgroundColor: shellBackground,
              appBar: AppBar(
                backgroundColor: surface,
                elevation: 0,
                scrolledUnderElevation: 0,
                surfaceTintColor: Colors.transparent,
                toolbarHeight: isWide ? 84 : 72,
                titleSpacing: isWide ? 24 : null,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      loc?.pursenal ?? 'Pursenal',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF161C2D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      viewmodel.selectedProfile.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                actions: [
                  if (isWide)
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withAlpha(18),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: primary.withAlpha(30)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_rounded,
                            size: 18,
                            color: primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${viewmodel.cashCountinProfile + viewmodel.bankCountinProfile} ${loc?.accounts ?? 'accounts'}',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: const Color(0xFF344054),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: Hero(
                        tag: "user_photo",
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          onTap: () {
                            if (user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserEditScreen(user: user),
                                ),
                              ).then((_) {
                                viewmodel.init();
                              });
                            }
                          },
                          child:
                              user != null &&
                                  userPhotoPath.isNotEmpty &&
                                  userPhotoPath != "" &&
                                  File(userPhotoPath).existsSync()
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.file(
                                    File(userPhotoPath),
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                    opacity: const AlwaysStoppedAnimation(.9),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: primary.withAlpha(20),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: primary,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: Builder(
                builder: (context) {
                  return LoadingBody(
                    loadingStatus: viewmodel.loadingStatus,
                    errorText: viewmodel.errorText,
                    resetErrorTextFn: () {
                      viewmodel.resetErrorText();
                    },
                    widget: Padding(
                      padding: EdgeInsets.fromLTRB(
                        isWide ? 20 : 12,
                        isWide ? 20 : 12,
                        isWide ? 20 : 12,
                        0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isWide) ...[
                            _DesktopRail(
                              viewmodel: viewmodel,
                              isExpanded: isVeryWide,
                            ),
                            const SizedBox(width: 20),
                          ],
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: surface,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(28),
                                  topRight: Radius.circular(28),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF101828,
                                    ).withAlpha(12),
                                    blurRadius: 30,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(28),
                                  topRight: Radius.circular(28),
                                ),
                                child: MainScreenBody(
                                  profile: viewmodel.selectedProfile,
                                  viewmodel: viewmodel,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              bottomNavigationBar: isWide
                  ? null
                  : SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFE9ECF5)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF101828).withAlpha(10),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            child: Row(
                              children: List.generate(
                                _labels.length,
                                (index) => Expanded(
                                  child: _BottomNavItem(
                                    label: _labels[index],
                                    icon: _icons[index],
                                    selected: viewmodel.currentIndex == index,
                                    onTap: () => viewmodel.setIndex(index),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              drawer: embeddedInHost ? null : TheDrawer(viewmodel: viewmodel),
            );
          },
        ),
      ),
    );
  }
}

class MainScreenBody extends StatelessWidget {
  const MainScreenBody({
    super.key,
    required this.profile,
    required this.viewmodel,
  });

  final Profile profile;
  final MainViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    // print(viewmodel.pageController.page);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewmodel.pageController.page?.round() != viewmodel.currentIndex) {
        viewmodel.pageController.jumpToPage(viewmodel.currentIndex);
      }
    });
    var pages = [
      DashboardScreen(profile: viewmodel.selectedProfile),
      BalancesScreen(profile: viewmodel.selectedProfile),
      TransactionsScreen(profile: viewmodel.selectedProfile),
      InsightsScreen(profile: viewmodel.selectedProfile),
    ];
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: PageView.builder(
              itemCount: pages.length,
              itemBuilder: (context, index) => pages[index],
              controller: viewmodel.pageController,
              onPageChanged: (index) => viewmodel.setIndex(index),
            ),
          ),
        ),
      ],
    );
  }
}

class _DesktopRail extends StatelessWidget {
  const _DesktopRail({required this.viewmodel, required this.isExpanded});

  final MainViewmodel viewmodel;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: isExpanded ? 248 : 92,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE9ECF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF101828).withAlpha(10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isExpanded ? 16 : 12,
          vertical: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(isExpanded ? 18 : 14),
              decoration: BoxDecoration(
                color: primary.withAlpha(12),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                    ),
                  ),
                  if (isExpanded) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Finance',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF161C2D),
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Overview',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: const Color(0xFF667085)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isExpanded ? 8 : 0),
              child: Text(
                isExpanded ? 'Navigation' : 'Menu',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF98A2B3),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _labels.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) => _DesktopRailItem(
                  label: _labels[index],
                  icon: _icons[index],
                  isExpanded: isExpanded,
                  selected: viewmodel.currentIndex == index,
                  onTap: () => viewmodel.setIndex(index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopRailItem extends StatelessWidget {
  const _DesktopRailItem({
    required this.label,
    required this.icon,
    required this.isExpanded,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isExpanded;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final Color foreground = selected ? primary : const Color(0xFF475467);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.symmetric(
                horizontal: isExpanded ? 14 : 0,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: selected ? primary.withAlpha(16) : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected ? primary.withAlpha(35) : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisAlignment: isExpanded
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  Icon(icon, color: foreground, size: 22),
                  if (isExpanded) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: foreground,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? primary.withAlpha(16) : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: selected ? primary : const Color(0xFF667085)),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: selected ? primary : const Color(0xFF667085),
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<String> _labels = [
  "Dashboard",
  "Balances",
  "Transactions",
  "Insights",
];
final List<IconData> _icons = [
  Icons.dashboard,
  Icons.money,
  Icons.list,
  Icons.bar_chart_rounded,
];
