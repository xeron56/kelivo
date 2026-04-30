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
    final isCompact = currentSize == PlannerSize.small;

    final tabs = [
      const PlannerTasks(),
      PlannerActivities(currentSize: currentSize),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(isCompact ? 14 : 18),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Padding(
                padding: EdgeInsets.all(isCompact ? 3 : 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PlannerTabChip(
                      label: 'Tasks',
                      selected: selectedTab == 0,
                      isCompact: isCompact,
                      onTap: () => context.read<PlannerBloc>().add(
                        const PlannerSelectedTabChanged(0),
                      ),
                    ),
                    _PlannerTabChip(
                      label: 'Activities',
                      selected: selectedTab == 1,
                      isCompact: isCompact,
                      onTap: () => context.read<PlannerBloc>().add(
                        const PlannerSelectedTabChanged(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: selectedTab == 1
                    ? Align(
                        key: const ValueKey(1),
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: () => context.read<PlannerBloc>().add(
                            const PlannerAddRoutines(),
                          ),
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: Text(isCompact ? 'Routines' : 'Load routines'),
                          style: OutlinedButton.styleFrom(
                            padding: isCompact
                                ? const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  )
                                : null,
                            textStyle: isCompact
                                ? theme.textTheme.labelMedium
                                : null,
                          ),
                        ),
                      )
                    : isCompact
                        ? const SizedBox.shrink()
                        : Text(
                            key: const ValueKey(0),
                            'Focus on what needs shipping today.',
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
              ),
            ),
          ],
        ),
        SizedBox(height: isCompact ? 12 : 18),
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
    this.isCompact = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = isCompact ? 11.0 : 14.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected
            ? theme.colorScheme.surface
            : theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(radius),
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
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: Padding(
            padding: isCompact
                ? const EdgeInsets.symmetric(horizontal: 12, vertical: 7)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              label,
              style: (isCompact
                      ? theme.textTheme.labelLarge
                      : theme.textTheme.titleMedium)
                  ?.copyWith(
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
