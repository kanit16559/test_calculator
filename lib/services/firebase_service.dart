
import 'package:firebase_messaging/firebase_messaging.dart';

import 'notification_service.dart';

class FirebaseService {

  final NotificationService notificationService;

  FirebaseService({
    required this.notificationService
  });

  getAPNSToken() async {
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    print('==== apnsToken: ${apnsToken}');
  }

  getToken() async {
    try{
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print('==== fcmToken: ${fcmToken}');
    }catch(error){
      print('==== error: ${error}');
    }

  }

  Future<void> requestPermission() async{
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }


  Future<void> setupInteractedMessage() async {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('========================================= onMessage =========================================');
      String? getTitle = message.notification?.title;
      String? getBody = message.notification?.body;
      notificationService.showNotification(title: getTitle, body: getBody);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published! :${message.data}');
    });

  }

}