import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/app/global/date_formats.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/viewmodels/insights_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/dot_indicator.dart';

class DailyTransactionsBarChartCard extends StatelessWidget {
  const DailyTransactionsBarChartCard({
    super.key,
    required this.viewmodel,
  });

  final InsightsViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    final noOfTransactions = viewmodel.dailyTotalTransactions.length;
    final appViewmodel = Provider.of<AppViewmodel>(context);
    final totalReceipts = viewmodel.dailyTotalTransactions.fold<int>(
      0,
      (sum, item) => sum + item.receiptsTotal,
    );
    final totalPayments = viewmodel.dailyTotalTransactions.fold<int>(
      0,
      (sum, item) => sum + item.paymentsTotal,
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: cardWidth),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: const BorderSide(color: Color(0xFFE7E7EC)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                          AppLocalizations.of(context)!.dailyTransactions,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Track daily inflow and outflow across the selected range.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF6B6B80),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _SmallStatChip(
                    label: 'Days',
                    value: '$noOfTransactions',
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                height: 280,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8FC),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE7E7EC)),
                ),
                child: ClipRect(
                  clipper: HorizontalClipper(leftClip: -2, rightClip: -2),
                  child: PageView(
                    onPageChanged: viewmodel.setDailyCardPage,
                    controller: viewmodel.dailyCardpageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.center,
                            gridData: FlGridData(
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (_) => const FlLine(
                                color: Color(0xFFE7E7EC),
                                strokeWidth: 1,
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(),
                              rightTitles: const AxisTitles(),
                              topTitles: const AxisTitles(),
                              bottomTitles: noOfTransactions < 45
                                  ? AxisTitles(
                                      sideTitles: SideTitles(
                                        interval: noOfTransactions < 20 ? 1 : 2,
                                        reservedSize: 28,
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          );
                                        },
                                      ),
                                    )
                                  : const AxisTitles(),
                            ),
                            barGroups:
                                viewmodel.dailyTotalTransactions.map((entry) {
                              final width = noOfTransactions > 100
                                  ? 2.5
                                  : noOfTransactions > 30
                                      ? 4.5
                                      : 7.0;
                              return BarChartGroupData(
                                x: entry.dateTime.day,
                                groupVertically: true,
                                barRods: [
                                  BarChartRodData(
                                    width: width,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4),
                                    ),
                                    toY: entry.receiptsTotal
                                        .toCurrency()
                                        .roundToDouble(),
                                    gradient: LinearGradient(
                                      colors: [
                                        appViewmodel.receiptColor,
                                        appViewmodel.receiptColor.withAlpha(170),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  BarChartRodData(
                                    width: width,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(4),
                                      bottomRight: Radius.circular(4),
                                    ),
                                    toY: -entry.paymentsTotal
                                        .toCurrency()
                                        .roundToDouble(),
                                    gradient: LinearGradient(
                                      colors: [
                                        appViewmodel.paymentColor.withAlpha(170),
                                        appViewmodel.paymentColor,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: noOfTransactions,
                        itemBuilder: (context, index) {
                          final item = viewmodel.dailyTotalTransactions[index];
                          final date = item.dateTime;
                          final payment = item.paymentsTotal;
                          final receipt = item.receiptsTotal;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE7E7EC)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    dateOnlyString.format(date),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    receipt > 0
                                        ? '+ ${receipt.toCurrencyString(viewmodel.selectedProfile.currency)}'
                                        : receipt.toCurrencyString(
                                            viewmodel.selectedProfile.currency,
                                          ),
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: appViewmodel.receiptColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    payment > 0
                                        ? '- ${payment.toCurrencyString(viewmodel.selectedProfile.currency)}'
                                        : payment.toCurrencyString(
                                            viewmodel.selectedProfile.currency,
                                          ),
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: appViewmodel.paymentColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _AmountBadge(
                          label: 'Receipts',
                          value: totalReceipts.toCurrencyStringWSymbol(
                            viewmodel.selectedProfile.currency,
                          ),
                          color: appViewmodel.receiptColor,
                        ),
                        _AmountBadge(
                          label: 'Payments',
                          value: totalPayments.toCurrencyStringWSymbol(
                            viewmodel.selectedProfile.currency,
                          ),
                          color: appViewmodel.paymentColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DotsIndicator(
                          isActive: viewmodel.dailyCardPage == 0,
                          onTap: () async {
                            await viewmodel.animateToDailyCardPage(0);
                          },
                        ),
                        DotsIndicator(
                          isActive: viewmodel.dailyCardPage == 1,
                          onTap: () async {
                            await viewmodel.animateToDailyCardPage(1);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: 50.ms)
        .scale(begin: const Offset(1.02, 1.02), duration: 120.ms)
        .fade(curve: Curves.easeInOut, duration: 120.ms);
  }
}

class _SmallStatChip extends StatelessWidget {
  const _SmallStatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: const Color(0xFF747488),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountBadge extends StatelessWidget {
  const _AmountBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7E7EC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF747488),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HorizontalClipper extends CustomClipper<Rect> {
  final double leftClip;
  final double rightClip;

  HorizontalClipper({this.leftClip = 0, this.rightClip = 0});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(leftClip, 0, size.width - rightClip, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}
