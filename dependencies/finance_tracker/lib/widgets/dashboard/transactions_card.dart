import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/app/global/values.dart';
import 'package:finance_tracker/core/enums/voucher_type.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/screens/transaction_screen.dart';
import 'package:finance_tracker/viewmodels/dashboard_viewmodel.dart';
import 'package:finance_tracker/viewmodels/main_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/transaction_tile.dart';

class TransactionsCard extends StatelessWidget {
  const TransactionsCard({super.key, required this.viewmodel});

  final DashboardViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: cardWidth * 2 + 32,
        minWidth: 300,
      ),
      child:
          Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFE7E7EC)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 28,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(
                                      context,
                                    )?.recentTransactions ??
                                    'Recent Transactions',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Your latest activity, ordered so the most relevant items stay visible.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF70707B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${viewmodel.recentTransactions.length} items',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBFBFD),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE9E9EF)),
                      ),
                      child: Column(
                        children: [
                          for (
                            var index = 0;
                            index < viewmodel.recentTransactions.length;
                            index++
                          ) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: TransactionTile(
                                isColorful: true,
                                isNegative:
                                    viewmodel
                                        .recentTransactions[index]
                                        .voucherType ==
                                    VoucherType.payment,
                                vchDate: viewmodel
                                    .recentTransactions[index]
                                    .voucherDate,
                                accountName:
                                    viewmodel
                                            .recentTransactions[index]
                                            .voucherType ==
                                        VoucherType.payment
                                    ? viewmodel
                                          .recentTransactions[index]
                                          .drAccount
                                          .name
                                    : viewmodel
                                          .recentTransactions[index]
                                          .crAccount
                                          .name,
                                amount:
                                    viewmodel.recentTransactions[index].amount,
                                isTransfer:
                                    fundingAccountIDs.contains(
                                      viewmodel
                                          .recentTransactions[index]
                                          .drAccount
                                          .accountType,
                                    ) &&
                                    fundingAccountIDs.contains(
                                      viewmodel
                                          .recentTransactions[index]
                                          .crAccount
                                          .accountType,
                                    ),
                                onClick: () {
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionScreen(
                                                transaction: viewmodel
                                                    .recentTransactions[index],
                                                profile:
                                                    viewmodel.selectedProfile,
                                              ),
                                        ),
                                      )
                                      .then((_) {
                                        viewmodel.init();
                                      });
                                },
                                vchType: viewmodel
                                    .recentTransactions[index]
                                    .voucherType,
                                transactionID:
                                    viewmodel.recentTransactions[index].dbID,
                                narr: viewmodel
                                    .recentTransactions[index]
                                    .narration,
                                currency: viewmodel.selectedProfile.currency,
                              ),
                            ),
                            if (index !=
                                viewmodel.recentTransactions.length - 1)
                              const Divider(
                                height: 1,
                                indent: 16,
                                endIndent: 16,
                                color: Color(0xFFE6E6EC),
                              ),
                          ],
                        ],
                      ),
                    ),
                    if (viewmodel.recentTransactions.length >=
                        viewmodel.recentCount) ...[
                      const SizedBox(height: 18),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () {
                            Provider.of<MainViewmodel>(
                              context,
                              listen: false,
                            ).setIndex(2);
                          },
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                          label: Text(
                            AppLocalizations.of(context)?.more ?? 'More',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              )
              .animate(delay: 150.ms)
              .scale(begin: const Offset(1.01, 1.01), duration: 120.ms)
              .fade(curve: Curves.easeOut, duration: 180.ms),
    );
  }
}
