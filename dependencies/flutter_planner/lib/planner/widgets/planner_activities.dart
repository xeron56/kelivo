import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:intl/intl.dart';

class PlannerActivities extends StatefulWidget {
  const PlannerActivities({
    Key? key,
    required this.currentSize,
  }) : super(key: key);

  final PlannerSize currentSize;

  @override
  State<PlannerActivities> createState() => _PlannerActivitiesState();
}

class _PlannerActivitiesState extends State<PlannerActivities> {
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activities = context.select(
      (PlannerBloc bloc) => bloc.state.activities,
    );
    final theme = Theme.of(context);
    final startHour = context.select(
      (AppBloc bloc) => bloc.state.timelineStartHour,
    );
    final endHour = context.select(
      (AppBloc bloc) => bloc.state.timelineEndHour,
    );

    final allDayActivities = List.of(activities)
      ..retainWhere(
        (activity) => activity.isAllDay,
      );

    final normalActivities = List.of(activities)
      ..removeWhere(
        (activity) => activity.isAllDay,
      );

    if (activities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.event_note_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nothing scheduled yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Plan meetings, routines, or focus blocks to give the day '
                    'structure.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(20),
      children: [
        if (allDayActivities.isNotEmpty) ...[
          _ActivitySectionHeader(
            icon: Icons.wb_sunny_outlined,
            title: 'All-day',
            subtitle: '${allDayActivities.length} planned',
          ),
          const SizedBox(height: 12),
          ...allDayActivities.map(
            (activity) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ActivityCard(
                activity: activity,
                currentSize: widget.currentSize,
                isAllDay: true,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
        _ActivitySectionHeader(
          icon: Icons.schedule_rounded,
          title: 'Timeline',
          subtitle: normalActivities.isEmpty
              ? 'Open for focused work'
              : '${normalActivities.length} scheduled',
        ),
        const SizedBox(height: 12),
        if (normalActivities.isEmpty)
          _TimelineEmptyState(
            startHour: startHour,
            endHour: endHour,
          )
        else
          DynamicTimeline(
            firstDateTime: DateTime(1970, 01, 01, startHour),
            lastDateTime: DateTime(1970, 01, 01, endHour),
            labelBuilder: DateFormat('HH:mm').format,
            intervalDuration: const Duration(hours: 1),
            resizable: false,
            intervalExtent: 80,
            items: normalActivities
                .map(
                  (activity) => TimelineItem(
                    key: ValueKey(activity),
                    startDateTime: activity.startTime,
                    endDateTime: activity.endTime,
                    child: ActivityCard(
                      activity: activity,
                      currentSize: widget.currentSize,
                      isAllDay: false,
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _ActivitySectionHeader extends StatelessWidget {
  const _ActivitySectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineEmptyState extends StatelessWidget {
  const _TimelineEmptyState({
    required this.startHour,
    required this.endHour,
  });

  final int startHour;
  final int endHour;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final startLabel = '${startHour.toString().padLeft(2, '0')}:00';
    final endLabel = '${endHour.toString().padLeft(2, '0')}:00';
    final rangeLabel = '$startLabel - $endLabel';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clear schedule',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'No timed activities between $rangeLabel. Use the free space '
              'for deep work or recovery.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
