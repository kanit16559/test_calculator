import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    // initialization Android
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    // await notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    // initialization IOS
    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    notificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  Future showNotification({int id = 0, String? title, String? body, String? payLoad, Priority priority = Priority.high, Importance importance = Importance.high}) async {
    return notificationsPlugin.show(
        id, title, body,
        await notificationDetails(
            priority: priority,
            importance: importance
        )
    );
  }

  notificationDetails({Priority priority = Priority.high, Importance importance = Importance.high}) {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          "channelId",
          "channelName",
          channelDescription: 'High Importance Notifications',
          // icon: '@mipmap/ic_launcher',
          priority: priority,
          importance: importance,
        ),
        iOS: const DarwinNotificationDetails(
          // threadIdentifier: 'thread_id', categoryIdentifier: "cateid"
        ));
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    print('===== onDidReceiveNotificationResponse =====');
  }

  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    print('===== onDidReceiveLocalNotification =====');
  }
}
