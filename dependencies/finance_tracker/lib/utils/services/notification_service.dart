import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:finance_tracker/utils/app_logger.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {
    AppLogger.instance.info("Notification received");
  }

  static Future<void> init(Function(String?) onNotificationTap) async {
    try {
      const AndroidInitializationSettings androidInitializationSettings =
          AndroidInitializationSettings("ic_notification");
      const DarwinInitializationSettings iOSInitializationSettings =
          DarwinInitializationSettings();

      const LinuxInitializationSettings linuxInitializationSettings =
          LinuxInitializationSettings(defaultActionName: 'Open notification');

      const InitializationSettings initializationSettings =
          InitializationSettings(
              android: androidInitializationSettings,
              iOS: iOSInitializationSettings,
              linux: linuxInitializationSettings);
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          AppLogger.instance.info("Notification clicked: ${response.payload}");
          onNotificationTap(response.payload);
        },
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } catch (e) {
      AppLogger.instance
          .error("Failed to initialise notification service. ${e.toString()}");
    }
  }

  static Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
    if (Platform.isLinux) {
      return [];
    }
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    return pendingNotificationRequests;
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      AppLogger.instance
          .error("Failed to cancel all notifications. ${e.toString()}");
    }
  }

  static Future<void> cancelReminder({int id = 0}) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      AppLogger.instance
          .error("Failed to cancel notification. ${e.toString()}");
    }
  }

  static Future<void> scheduleDailyReminder(int id, String title, String body,
      TimeOfDay time, String screenRoute) async {
    try {
      if (!Platform.isLinux) {
        String channelID = 'pursenal_daily_reminder_channel';

        if (kDebugMode) {
          channelID += "_debug";
        }

        final now = DateTime.now();
        var scheduledTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );

        // Ensure the notification is scheduled for the next occurrence
        if (scheduledTime.isBefore(now)) {
          scheduledTime = scheduledTime.add(const Duration(days: 1));
        }

        await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledTime, tz.local),
          NotificationDetails(
            android: AndroidNotificationDetails(
              channelID,
              'Daily Reminder',
              importance: Importance.high,
              priority: Priority.high,
              icon: 'ic_notification',
            ),
            iOS: const DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,

          matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
          payload: screenRoute,
        );

        AppLogger.instance.info(
            "Daily reminder scheduled at ${scheduledTime.hour}:${scheduledTime.minute}");
      }
    } catch (e) {
      AppLogger.instance
          .error("Failed to schedule daily reminder. ${e.toString()}");
    }
  }

  static Future<void> schedulePaymentReminder({
    required int id,
    required String title,
    required String body,
    required DateTime startDateTime,
    required bool isWeekly,
    int? weekday, // 1-7 (Mon-Sun)
    int? monthDay, // 1-31
    DateTime? paymentDate,
  }) async {
    try {
      if (Platform.isLinux) {
        return;
      }

      String channelID = 'pursenal_payment_reminder_$id';

      // final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduled;
      if (!isWeekly && paymentDate != null) {
        // ✅ Schedule one-time specific date
        scheduled = tz.TZDateTime.from(paymentDate, tz.local);
      } else if (isWeekly && weekday != null) {
        scheduled = _nextInstanceOfWeekday(startDateTime, weekday);
      } else if (!isWeekly && monthDay != null) {
        scheduled = _nextInstanceOfMonthDay(startDateTime, monthDay);
      } else {
        AppLogger.instance.error("No valid schedule time provided");
        return;
      }
      AppLogger.instance.info("Scheduling for: ${scheduled.toString()}");

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelID,
            'Payment Reminder',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        matchDateTimeComponents: (!isWeekly && paymentDate != null)
            ? null // Don't repeat
            : isWeekly
                ? DateTimeComponents.dayOfWeekAndTime
                : DateTimeComponents.dayOfMonthAndTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      AppLogger.instance.error(' ${e.toString()}');
    }
  }

  static tz.TZDateTime _nextInstanceOfWeekday(DateTime time, int weekday) {
    tz.TZDateTime scheduledDate = tz.TZDateTime.local(
      time.year,
      time.month,
      time.day,
      time.hour,
      time.minute,
    );

    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }
    AppLogger.instance.info("Next weekday schedule: $scheduledDate");
    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfMonthDay(DateTime time, int day) {
    final now = tz.TZDateTime.now(tz.local);
    final year = now.year;
    final month = now.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    final validDay = day <= daysInMonth ? day : daysInMonth;

    var scheduled = tz.TZDateTime.local(
      year,
      month,
      validDay,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      final nextMonth = DateTime(year, month + 1);
      final daysInNextMonth =
          DateTime(nextMonth.year, nextMonth.month + 1, 0).day;
      final validNextDay = day <= daysInNextMonth ? day : daysInNextMonth;

      scheduled = tz.TZDateTime.local(
        nextMonth.year,
        nextMonth.month,
        validNextDay,
        time.hour,
        time.minute,
      );
    }

    return scheduled;
  }
}

Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }
}

