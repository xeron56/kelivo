import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/helpers/router_fallback.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:go_router/go_router.dart';
import 'package:reminders_repository/reminders_repository.dart';

class PlannerActivitiesHeader extends StatelessWidget {
  const PlannerActivitiesHeader({Key? key, required this.currentSize})
    : super(key: key);

  final PlannerSize currentSize;

  void _onAdd({
    required PlannerSize currentSize,
    required BuildContext context,
    required DateTime selectedDay,
  }) {
    final newActivity = Activity(
      userID: context.read<AuthenticationBloc>().state.user!.id,
      date: selectedDay,
      startTime: DateTime(1970, 1, 1, 7),
      endTime: DateTime(1970, 1, 1, 8),
    );
    if (currentSize == PlannerSize.large) {
      final activitiesRepository = context.read<ActivitiesRepository>();
      final remindersRepository = context.read<RemindersRepository>();

      showDialog<Object>(
        context: context,
        builder: (context) => ActivityPage.dialog(
          activity: newActivity,
          activitiesRepository: activitiesRepository,
          remindersRepository: remindersRepository,
        ),
      );
    } else if (hasGoRouter(context)) {
      context.goNamed(
        AppRoutes.activity,
        pathParameters: {'page': 'planner'},
        extra: newActivity,
      );
    } else {
      Navigator.of(context).push(
        ActivityPage.route(
          activity: newActivity,
          activitiesRepository: context.read<ActivitiesRepository>(),
          remindersRepository: context.read<RemindersRepository>(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = context.select(
      (PlannerBloc bloc) => bloc.state.selectedDay,
    );
    final theme = Theme.of(context);
    final dateLabel = MaterialLocalizations.of(
      context,
    ).formatMediumDate(selectedDay);

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 14,
      runSpacing: 14,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: currentSize == PlannerSize.large ? 420 : double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Activities',
                style: theme.textTheme.headlineSmall,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Plan the day with time-blocked work and routines.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: () =>
                  context.read<PlannerBloc>().add(const PlannerAddRoutines()),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Load routines'),
            ),
            ElevatedButton.icon(
              onPressed: () => _onAdd(
                currentSize: currentSize,
                context: context,
                selectedDay: selectedDay,
              ),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('New activity'),
            ),
          ],
        ),
        if (currentSize == PlannerSize.large)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              dateLabel,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}
