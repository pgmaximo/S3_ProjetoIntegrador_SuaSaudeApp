import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initializeNotifications();
  }

  void _initializeNotifications() {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> showRepeatingNotification({
    required int id,
    required String title,
    required String body,
    required DateTime startTime,
    required Duration interval,
    required DateTime endTime,
  }) async {
    tz.TZDateTime tzStartTime = tz.TZDateTime.from(startTime, tz.local);
    tz.TZDateTime tzEndTime = tz.TZDateTime.from(endTime, tz.local);

    while (tzStartTime.isBefore(tzEndTime)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzStartTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id',
            'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableLights: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      tzStartTime = tzStartTime.add(interval);
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    // Handle the notification received on iOS when the app is in foreground
  }

  void onDidReceiveNotificationResponse(NotificationResponse response) {
    // Handle notification tapped logic here
  }
}
