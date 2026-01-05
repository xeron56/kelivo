import 'package:flutter/material.dart';
import 'package:todo_apps/services/notification_services.dart';
import 'package:todo_apps/ui/home_page.dart';

class TasksHostPage extends StatefulWidget {
  const TasksHostPage({Key? key}) : super(key: key);

  @override
  State<TasksHostPage> createState() => _TasksHostPageState();
}

class _TasksHostPageState extends State<TasksHostPage> {
  final _notifyHelper = NotifyHelper();

  @override
  void initState() {
    super.initState();
    // Initialize notifications for the tasks module when opened
    try {
      _notifyHelper.initializeNotification();
      _notifyHelper.requestIOSPermissions();
      _notifyHelper.requestAndroidPermissions();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    // The package's HomePage is itself a Scaffold; return it directly
    return const HomePage();
  }
}
