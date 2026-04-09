import 'dart:io';

import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:isar/isar.dart';
import 'package:isar_activities_api/isar_activities_api.dart';
import 'package:isar_authentication_api/isar_authentication_api.dart';
import 'package:isar_routines_api/isar_routines_api.dart';
import 'package:isar_tasks_api/isar_tasks_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reminders_api/reminders_api.dart';
import 'package:reminders_repository/reminders_repository.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

const _plannerIsarName = 'kelivo_planner';
const _plannerHydratedDirName = 'kelivo_planner_hydrated';

class FlutterPlannerApp extends StatelessWidget {
  const FlutterPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _PlannerDependenciesLoader(
      builder: (context, dependencies) {
        return App(
          authenticationRepository: dependencies.authenticationRepository,
          activitiesRepository: dependencies.activitiesRepository,
          routinesRepository: dependencies.routinesRepository,
          tasksRepository: dependencies.tasksRepository,
          remindersRepository: dependencies.remindersRepository,
        );
      },
    );
  }
}

class PlannerIntegrationView extends StatelessWidget {
  const PlannerIntegrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return _PlannerDependenciesLoader(
      builder: (context, dependencies) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthenticationRepository>.value(
              value: dependencies.authenticationRepository,
            ),
            RepositoryProvider<ActivitiesRepository>.value(
              value: dependencies.activitiesRepository,
            ),
            RepositoryProvider<RoutinesRepository>.value(
              value: dependencies.routinesRepository,
            ),
            RepositoryProvider<TasksRepository>.value(
              value: dependencies.tasksRepository,
            ),
            RepositoryProvider<RemindersRepository>.value(
              value: dependencies.remindersRepository,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                lazy: false,
                create: (_) => AuthenticationBloc(
                  authenticationRepository:
                      dependencies.authenticationRepository,
                )..add(const AuthenticationSubscriptionRequested()),
              ),
              BlocProvider(
                create: (_) => AppBloc(
                  tasksRepository: dependencies.tasksRepository,
                  remindersRepository: dependencies.remindersRepository,
                ),
              ),
            ],
            child: const PlannerPage(),
          ),
        );
      },
    );
  }
}

class _PlannerDependenciesLoader extends StatelessWidget {
  const _PlannerDependenciesLoader({required this.builder});

  final Widget Function(BuildContext context, _PlannerDependencies dependencies)
  builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_PlannerDependencies>(
      future: _PlannerBootstrap.ensureInitialized(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Failed to load planner: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final dependencies = snapshot.data;
        if (dependencies == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return builder(context, dependencies);
      },
    );
  }
}

class _PlannerBootstrap {
  static Future<_PlannerDependencies>? _future;
  static bool _didInitHydratedStorage = false;

  static Future<_PlannerDependencies> ensureInitialized() {
    return _future ??= _initialize();
  }

  static Future<_PlannerDependencies> _initialize() async {
    await _ensureHydratedStorage();

    final appSupportDirectory = await getApplicationSupportDirectory();
    final plannerDirectory = Directory(
      '${appSupportDirectory.path}/$_plannerIsarName',
    );
    if (!plannerDirectory.existsSync()) {
      plannerDirectory.createSync(recursive: true);
    }

    final isar =
        Isar.getInstance(_plannerIsarName) ??
        await Isar.open(
          [IsarActivitySchema, IsarRoutineSchema, IsarTaskSchema],
          directory: plannerDirectory.path,
          name: _plannerIsarName,
          inspector: false,
        );

    const authenticationApi = IsarAuthenticationApi();

    return _PlannerDependencies(
      authenticationRepository: const AuthenticationRepository(
        authenticationApi: authenticationApi,
      ),
      activitiesRepository: ActivitiesRepository(
        activitiesApi: IsarActivitiesApi(isar: isar),
      ),
      routinesRepository: RoutinesRepository(
        routinesApi: IsarRoutinesApi(isar: isar),
      ),
      tasksRepository: TasksRepository(tasksApi: IsarTasksApi(isar: isar)),
      remindersRepository: const RemindersRepository(
        remindersApi: _DisabledRemindersApi(),
      ),
    );
  }

  static Future<void> _ensureHydratedStorage() async {
    if (_didInitHydratedStorage) return;

    final storageDirectory = kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            '${(await getTemporaryDirectory()).path}/$_plannerHydratedDirName',
          );

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: storageDirectory,
    );
    _didInitHydratedStorage = true;
  }
}

class _PlannerDependencies {
  const _PlannerDependencies({
    required this.authenticationRepository,
    required this.activitiesRepository,
    required this.routinesRepository,
    required this.tasksRepository,
    required this.remindersRepository,
  });

  final AuthenticationRepository authenticationRepository;
  final ActivitiesRepository activitiesRepository;
  final RoutinesRepository routinesRepository;
  final TasksRepository tasksRepository;
  final RemindersRepository remindersRepository;
}

class _DisabledRemindersApi extends RemindersApi {
  const _DisabledRemindersApi();

  @override
  bool get isAllowed => false;

  @override
  Future<List<bool>> checkReminders({required List<int> ids}) async {
    return List<bool>.filled(ids.length, false);
  }

  @override
  Future<void> deleteReminder({required int id}) async {}

  @override
  Future<void> saveReminder({required Reminder reminder}) async {}
}
