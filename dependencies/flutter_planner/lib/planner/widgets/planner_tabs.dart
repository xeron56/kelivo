import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/planner/planner.dart';

class PlannerTabs extends StatelessWidget {
  const PlannerTabs({Key? key, required this.currentSize}) : super(key: key);

  final PlannerSize currentSize;

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select(
      (PlannerBloc bloc) => bloc.state.selectedTab,
    );

    final theme = Theme.of(context);

    final tabs = [
      const PlannerTasks(),
      PlannerActivities(currentSize: currentSize),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PlannerTabChip(
                      label: 'Tasks',
                      selected: selectedTab == 0,
                      onTap: () => context.read<PlannerBloc>().add(
                        const PlannerSelectedTabChanged(0),
                      ),
                    ),
                    _PlannerTabChip(
                      label: 'Activities',
                      selected: selectedTab == 1,
                      onTap: () => context.read<PlannerBloc>().add(
                        const PlannerSelectedTabChanged(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Row(
                key: ValueKey(selectedTab),
                mainAxisSize: MainAxisSize.min,
                children: selectedTab == 1
                    ? [
                        OutlinedButton.icon(
                          onPressed: () => context.read<PlannerBloc>().add(
                            const PlannerAddRoutines(),
                          ),
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('Load routines'),
                        ),
                      ]
                    : [
                        Text(
                          'Focus on what needs shipping today.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Expanded(
          child: IndexedStack(index: selectedTab, children: tabs),
        ),
      ],
    );
  }
}

class _PlannerTabChip extends StatelessWidget {
  const _PlannerTabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected
            ? theme.colorScheme.surface
            : theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(14),
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color(0x0D0F172A),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: selected
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
