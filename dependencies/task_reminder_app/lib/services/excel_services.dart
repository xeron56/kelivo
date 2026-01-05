import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:todo_apps/models/task.dart';

Future<void> exportTasksToExcel(List<Task> tasks) async {
  List<String> colors = ["primaryColor", "red", "yellow", "black"];
  List<String> isComplete = ["Pending", "Completed"];

  // Column headers
  List<String> headers = [
    "Id",
    "Title",
    "Note",
    "Date",
    "StartTime",
    "EndTime",
    "Remind",
    "Repeat",
    "Color",
    "isCompleted",
    "createdAt",
    "updatedAt"
  ];

  List<List<dynamic>> rows = [];
  rows.add(headers);

  // Populate rows
  for (Task task in tasks) {
    List<dynamic> row = [];
    row.add(task.id);
    row.add(task.title);
    row.add(task.note);
    row.add(task.date);
    row.add(task.startTime);
    row.add(task.endTime);
    row.add(task.remind);
    row.add(task.repeat);
    row.add(colors[task.color ?? 0]);
    row.add(isComplete[task.isCompleted ?? 0]);
    row.add(task.createdAt);
    row.add(task.updatedAt);
    rows.add(row);
  }

  String csv = const ListToCsvConverter().convert(rows);

  // Save the CSV file (Excel can open CSV files)
  final directory = await getTemporaryDirectory();
  final path = directory.path;
  final file = File('$path/tasks.csv');
  await file.writeAsString(csv);

  var rand = Random();
  int randomNumber = rand.nextInt(50);

  final params = SaveFileDialogParams(
    sourceFilePath: file.path,
    localOnly: true,
    fileName: "Tasks$randomNumber.csv",
  );

  await FlutterFileDialog.saveFile(params: params);
}
