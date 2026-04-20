import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:table_calendar/table_calendar.dart';

class PlannerCalendar extends StatelessWidget {
  const PlannerCalendar({Key? key, required this.currentSize})
    : super(key: key);

  final PlannerSize currentSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatButtonVisible = currentSize != PlannerSize.large;

    final calendarFormat = currentSize == PlannerSize.large
        ? CalendarFormat.month
        : CalendarFormat.week;

    final selectedDay = context.select(
      (PlannerBloc bloc) => bloc.state.selectedDay,
    );

    final focusedDay = context.select(
      (PlannerBloc bloc) => bloc.state.focusedDay,
    );

    final events = context.select((PlannerBloc bloc) => bloc.state.events);
    final borderColor = theme.colorScheme.outline;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Schedule', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Choose a date to focus tasks and activities.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 14),
            TableCalendar<Object?>(
              rowHeight: currentSize == PlannerSize.large ? 50 : 42,
              daysOfWeekHeight: 24,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(
                formatButtonVisible: formatButtonVisible,
                leftChevronMargin: EdgeInsets.zero,
                rightChevronMargin: EdgeInsets.zero,
                leftChevronPadding: const EdgeInsets.all(8),
                rightChevronPadding: const EdgeInsets.all(8),
                titleTextStyle: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                formatButtonTextStyle: theme.textTheme.labelMedium!.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
                formatButtonDecoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: theme.textTheme.labelMedium!.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w700,
                ),
                weekendStyle: theme.textTheme.labelMedium!.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
              calendarFormat: calendarFormat,
              calendarStyle: CalendarStyle(
                defaultTextStyle: theme.textTheme.bodyMedium!,
                weekendTextStyle: theme.textTheme.bodyMedium!,
                outsideTextStyle: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onSecondaryContainer.withValues(
                    alpha: 0.55,
                  ),
                ),
                todayTextStyle: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
                todayDecoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
                selectedDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 3,
                markerDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                markerMargin: const EdgeInsets.symmetric(horizontal: 1.5),
                markerSize: 5,
                outsideDaysVisible: currentSize == PlannerSize.large,
                cellMargin: const EdgeInsets.all(4),
              ),
              firstDay: DateTime.now().subtract(const Duration(days: 365 * 2)),
              lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
              focusedDay: focusedDay,
              eventLoader: (day) => _filterEvents(day: day, events: events),
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
              onDaySelected: (selectedDay, focusedDay) =>
                  context.read<PlannerBloc>()
                    ..add(PlannerSelectedDayChanged(selectedDay))
                    ..add(PlannerFocusedDayChanged(focusedDay)),
              onPageChanged: (focusedDay) => context.read<PlannerBloc>().add(
                PlannerFocusedDayChanged(focusedDay),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Object> _filterEvents({
    required DateTime day,
    required List<Activity> events,
  }) {
    final _events = List.of(events)..retainWhere((event) => event.date == day);

    return _events;
  }
}
