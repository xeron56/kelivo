import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/viewmodels/dashboard_viewmodel.dart';
import 'package:finance_tracker/widgets/dashboard/add_transaction_button_group.dart';

class AddTransactionCard extends StatelessWidget {
  const AddTransactionCard({
    super.key,
    required this.appViewmodel,
    required this.profile,
    required this.viewmodel,
  });

  final AppViewmodel appViewmodel;
  final Profile profile;
  final DashboardViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: cardWidth),
      child:
          Container(
                padding: const EdgeInsets.all(22),
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
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F5FD),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.add_card_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.add,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Create a receipt or payment entry from one place.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF72727D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBFBFD),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE9E9EF)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _ActionHint(
                                  title: 'Receipt',
                                  subtitle: 'Log incoming money quickly.',
                                  color: appViewmodel.receiptColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _ActionHint(
                                  title: 'Payment',
                                  subtitle: 'Track outgoing money cleanly.',
                                  color: appViewmodel.paymentColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          AddTransactionButtonGroup(
                            appViewmodel: appViewmodel,
                            profile: profile,
                            viewmodel: viewmodel,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .animate(delay: 60.ms)
              .scale(begin: const Offset(1.01, 1.01), duration: 120.ms)
              .fade(curve: Curves.easeOut, duration: 180.ms),
    );
  }
}

class _ActionHint extends StatelessWidget {
  const _ActionHint({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E8EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF767681),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
