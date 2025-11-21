import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotiService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialzed = false;
  bool get isInitialzed => _isInitialzed;

  // Initialize
  Future<void> initNotification() async {
    if (_isInitialzed) return;

    //timezone handling
    tz.initializeTimeZones();
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    final String currentTimeZone = timezoneInfo.identifier;
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    
    // android init settings
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // init settings
    const initSettings = InitializationSettings(
      android:  initSettingsAndroid,
    );

    // plugin
    await notificationPlugin.initialize(initSettings);

    //_isInitialzed = true;
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
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute,);

    // Schedule
    await notificationPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails(),
        // Andrioid spcific
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // exact
        //matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  
  Future<void> cancelAllNotifications() async {
    await notificationPlugin.cancelAll();
  }
}