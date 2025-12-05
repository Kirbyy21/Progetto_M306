import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotiService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialzed = false;
  bool get isInitialzed => _isInitialzed;

  // Initialize
  Future<void> initNotification() async {
    if (_isInitialzed) return;

    //timezone handling
    tz.initializeTimeZones();
    /*final String currentTimeZone = DateTime.now().timeZoneName;
    tz.setLocalLocation(tz.getLocation(currentTimeZone));*/

    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    final String currentTimeZone = timezoneInfo.identifier;
    tz.setLocalLocation(tz.getLocation('Europe/Lisbon'));


    // android init settings
    const AndroidInitializationSettings initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // init settings
    const InitializationSettings initSettings = InitializationSettings(
      android:  initSettingsAndroid,
    );

    // plugin
    await notificationPlugin.initialize(initSettings);

    _isInitialzed = true;
  }

  // Notification setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'race_channel_id',
          'Race Reminder',
          channelDescription: 'Race Reminder Channel',
          importance: Importance.max,
          priority: Priority.high,
      ),
    );
  }

  // Show notifications
  Future<void> showNotifications({
    int id = 0,
    String? title,
    String? body,
  }) async {
      return notificationPlugin.show(id, title, body, notificationDetails(),);
  }


  // Schedule notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    print("Ora attuale: $now");
    print("Notifica programmata per: $scheduledDate");
    if (scheduledDate.isBefore(now)) {
      print("Oh now");
    }
  /*
    final androidPlugin = AndroidFlutterLocalNotificationsPlugin();
    final granted = await androidPlugin?.requestExactAlarmsPermission();
    if (granted != true) return;
    final allowed = await androidPlugin?.areNotificationsEnabled();
    if (allowed == false) {
      await androidPlugin?.requestNotificationsPermission();
    }*/


    final androidPlugin = AndroidFlutterLocalNotificationsPlugin();
    final granted = await androidPlugin.requestExactAlarmsPermission();
    if (granted != true) {
      print("Access not granted!");
      return;
    }
    // Schedule
    print("Schedulo notifica ID $id alle $scheduledDate");
    return notificationPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails(),
        // Android specific
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // exact
        //matchDateTimeComponents: DateTimeComponents.time,
    );
    print("Notifica schedulata ✔");
    print("TZDateTime: $scheduledDate");
    print("Milliseconds since epoch: ${scheduledDate.millisecondsSinceEpoch}");
    print("Now: ${tz.TZDateTime.now(tz.local)}");


  }

  Future<void> cancelAllNotifications() async {
    await notificationPlugin.cancelAll();
  }
}