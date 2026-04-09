import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/helpers/router_fallback.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:reminders_repository/reminders_repository.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({Key? key, this.isDialog = false}) : super(key: key);

  static Dialog dialog({
    required Activity activity,
    required ActivitiesRepository activitiesRepository,
    required RemindersRepository remindersRepository,
  }) {
    return Dialog(
      child: Container(
        height: 600,
        width: 400,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ActivitiesRepository>.value(
              value: activitiesRepository,
            ),
            RepositoryProvider<RemindersRepository>.value(
              value: remindersRepository,
            ),
          ],
          child: BlocProvider(
            create: (_) => ActivityBloc(
              remindersRepository: remindersRepository,
              activitiesRepository: activitiesRepository,
              initialActivity: activity,
            ),
            child: const ActivityPage(isDialog: true),
          ),
        ),
      ),
    );
  }

  static Route<void> route({
    required Activity activity,
    required ActivitiesRepository activitiesRepository,
    required RemindersRepository remindersRepository,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ActivitiesRepository>.value(
            value: activitiesRepository,
          ),
          RepositoryProvider<RemindersRepository>.value(
            value: remindersRepository,
          ),
        ],
        child: BlocProvider(
          create: (_) => ActivityBloc(
            remindersRepository: remindersRepository,
            activitiesRepository: activitiesRepository,
            initialActivity: activity,
          ),
          child: const ActivityPage(),
        ),
      ),
    );
  }

  final bool isDialog;

  @override
  Widget build(BuildContext context) {
    final areRemindersAllowed = context.watch<RemindersRepository>().areAllowed;

    if (areRemindersAllowed) {
      context.read<ActivityBloc>().add(const ActivityRemindersRequested());
    }

    return Scaffold(
      body: LoaderOverlay(
        child: BlocListener<ActivityBloc, ActivityState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case ActivityStatus.initial:
                break;
              case ActivityStatus.loading:
                context.loaderOverlay.show();
                break;
              case ActivityStatus.success:
                context.loaderOverlay.hide();
                if (isDialog) {
                  Navigator.pop(context);
                } else {
                  popRouterOrNavigator(context);
                }
                break;
              case ActivityStatus.failure:
                context.loaderOverlay.hide();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                  ),
                );
                break;
            }
          },
          child: ActivityLayoutBuilder(
            headerButtons: (_) => ActivityHeaderButtons(isDialog: isDialog),
            nameTextField: (_) => const ActivityNameTextField(),
            descriptionTextField: (currentSize) =>
                ActivityDescriptionTextField(currentSize: currentSize),
            datePicker: (_) => ActivityDatePicker(isDialog: isDialog),
            timePickers: (_) => const ActivityTimePickers(),
            typePicker: (_) => const ActivityTypePicker(),
            allDaySwitch: (_) => const ActivityAllDaySwitch(),
            reminders: (currentSize) =>
                ActivityReminders(currentSize: currentSize),
          ),
        ),
      ),
    );
  }
}
