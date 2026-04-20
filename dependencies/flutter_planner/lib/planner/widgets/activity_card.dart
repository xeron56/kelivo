import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/helpers/router_fallback.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:reminders_repository/reminders_repository.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    Key? key,
    required this.activity,
    required this.currentSize,
    required this.isAllDay,
  }) : super(key: key);

  final Activity activity;
  final PlannerSize currentSize;
  final bool isAllDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = isAllDay
        ? theme.colorScheme.tertiary
        : theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface;
    final title = activity.name.trim().isEmpty
        ? 'Untitled activity'
        : activity.name;
    final description = activity.description.trim();
    final timeLabel = isAllDay
        ? 'All day'
        : '${DateFormat('HH:mm').format(activity.startTime)} - '
            '${DateFormat('HH:mm').format(activity.endTime)}';
    final duration = activity.endTime.difference(activity.startTime);
    final durationInHours = duration.inHours;
    final durationInMinutes = duration.inMinutes.remainder(60);
    final durationLabel = isAllDay
        ? null
        : [
            if (durationInHours > 0) '${durationInHours}h',
            if (durationInMinutes > 0) '${durationInMinutes}m',
          ].join(' ');

    return GestureDetector(
      onTap: () => currentSize == PlannerSize.large
          ? showDialog<Object>(
              context: context,
              builder: (context) => ActivityPage.dialog(
                activity: activity,
                activitiesRepository: context.read<ActivitiesRepository>(),
                remindersRepository: context.read<RemindersRepository>(),
              ),
            )
          : hasGoRouter(context)
          ? context.goNamed(
              AppRoutes.activity,
              pathParameters: {'page': 'planner'},
              extra: activity,
            )
          : Navigator.of(context).push(
              ActivityPage.route(
                activity: activity,
                activitiesRepository: context.read<ActivitiesRepository>(),
                remindersRepository: context.read<RemindersRepository>(),
              ),
            ),
      child: Container(
        padding: const EdgeInsets.all(14),
        width: double.infinity,
        constraints: BoxConstraints(minHeight: isAllDay ? 92 : 88),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.75),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 10,
              height: isAllDay ? 64 : 72,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                width: 10,
                height: 22,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _InfoChip(
                        icon: isAllDay
                            ? Icons.wb_sunny_outlined
                            : Icons.schedule_rounded,
                        label: timeLabel,
                        backgroundColor: accentColor.withValues(alpha: 0.1),
                        foregroundColor: accentColor,
                      ),
                      if (durationLabel != null && durationLabel.isNotEmpty)
                        _InfoChip(
                          icon: Icons.timelapse_rounded,
                          label: durationLabel,
                          backgroundColor:
                              theme.colorScheme.secondary.withValues(
                            alpha: 0.08,
                          ),
                          foregroundColor: theme.colorScheme.secondary,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      height: 1.2,
                    ),
                    maxLines: isAllDay ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: isAllDay ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
