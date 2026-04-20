import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlannerBloc>(
      create: (context) =>
          PlannerBloc(
              activitiesRepository: context.read<ActivitiesRepository>(),
              routinesRepository: context.read<RoutinesRepository>(),
              tasksRepository: context.read<TasksRepository>(),
              userID: context.read<AuthenticationBloc>().state.user!.id,
            )
            ..add(const PlannerSubscriptionRequested())
            ..add(const PlannerEventsSubRequested())
            ..add(const PlannerTasksSubRequested()),
      child: const PlannerView(),
    );
  }
}

class PlannerView extends StatelessWidget {
  const PlannerView({Key? key}) : super(key: key);

  ThemeData _plannerTheme(BuildContext context) {
    final baseTheme = Theme.of(context);
    const background = Color(0xFFF7F8FA);
    const surface = Colors.white;
    const border = Color(0xFFE6E8EE);
    const accent = Color(0xFF1F6FEB);
    const accentSoft = Color(0xFFEAF2FF);
    const textPrimary = Color(0xFF171A21);
    const textMuted = Color(0xFF6B7280);

    final colorScheme = baseTheme.colorScheme.copyWith(
      brightness: Brightness.light,
      surface: surface,
      onSurface: textPrimary,
      outline: border,
      outlineVariant: const Color(0xFFF0F2F5),
      primary: accent,
      onPrimary: Colors.white,
      primaryContainer: accentSoft,
      onPrimaryContainer: accent,
      secondaryContainer: const Color(0xFFF3F6FB),
      onSecondaryContainer: textMuted,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: colorScheme,
      cardColor: surface,
      dividerColor: border,
      snackBarTheme: baseTheme.snackBarTheme.copyWith(
        backgroundColor: textPrimary,
        contentTextStyle: baseTheme.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: baseTheme.textTheme.copyWith(
        headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: baseTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(
          color: textPrimary,
        ),
        bodySmall: baseTheme.textTheme.bodySmall?.copyWith(color: textMuted),
        labelLarge: baseTheme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: accent,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: baseTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: border),
          backgroundColor: surface,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: baseTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _plannerTheme(context),
      child: BlocListener<PlannerBloc, PlannerState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          switch (state.status) {
            case PlannerStatus.initial:
              break;
            case PlannerStatus.loading:
              break;
            case PlannerStatus.success:
              break;
            case PlannerStatus.failure:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              );
              break;
          }
        },
        child: PlannerLayoutBuilder(
          activitiesHeader: (currentSize) =>
              PlannerActivitiesHeader(currentSize: currentSize),
          tasksHeader: (_) => const PlannerTasksHeader(),
          calendar: (currentSize) => PlannerCalendar(currentSize: currentSize),
          activities: (currentSize) =>
              PlannerActivities(currentSize: currentSize),
          tasks: (_) => const PlannerTasks(),
          tabs: (currentSize) => PlannerTabs(currentSize: currentSize),
          fab: (_) => const PlannerFab(),
        ),
      ),
    );
  }
}
