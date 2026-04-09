import 'package:flutter/material.dart';
import 'package:flutter_planner/flutter_planner.dart';
import 'package:intl/intl.dart';

class DailyPlannerPage extends StatefulWidget {
  const DailyPlannerPage({super.key});

  @override
  State<DailyPlannerPage> createState() => _DailyPlannerPageState();
}

class _DailyPlannerPageState extends State<DailyPlannerPage> {
  bool _showIntro = true;

  void _closePlanner() {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 900;
    final dateLabel = DateFormat('EEEE, MMM d').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back to Kelivo',
          onPressed: _closePlanner,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Planner',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Inside Kelivo • $dateLabel',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: _closePlanner,
            icon: const Icon(Icons.close_rounded),
            label: const Text('Close'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          isWide ? 20 : 12,
          12,
          isWide ? 20 : 12,
          isWide ? 20 : 12,
        ),
        child: Column(
          children: [
            if (_showIntro)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: cs.secondaryContainer.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.event_note_rounded, color: cs.secondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Planner is open inside your workspace',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Use the back or close button anytime to return to chat. '
                            'Tasks and activities you open here stay in the same Kelivo session.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Hide message',
                      onPressed: () {
                        setState(() => _showIntro = false);
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLowest,
                    border: Border.all(color: cs.outlineVariant),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const PlannerIntegrationView(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
