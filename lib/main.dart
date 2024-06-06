import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test_calculator/screens/views/home/home_view.dart';
import 'package:test_calculator/services/notification_service.dart';

import 'core/app_injection.dart';
import 'core/router/router.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('========================================= onBackgroundMessage =========================================...');
  String? getTitle = message.notification?.title;
  String? getBody = message.notification?.body;
  AppInjections.internal.getItInstance<NotificationService>().showNotification(
    title: getTitle,
    body: getBody,
    priority: Priority.max,
    importance: Importance.max
  );
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInjections.internal.initInjections();
  await NotificationService().initNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      // initialRoute: "/home_view",
      home: const HomeView()
    );
  }
}
