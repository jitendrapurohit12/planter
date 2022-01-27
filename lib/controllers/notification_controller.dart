import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationNotifier {
  final channelId = 'planter_channel';
  final channelName = 'High importance notifications for Planter App';
  final channelDescription = 'This channel is used for important notifications for Planter App.';

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const androidSettings = AndroidInitializationSettings('ic_notification');
  static const iosSettings =
      IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  static const initializationSettings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);

  Future init() async {
    final channel = AndroidNotificationChannel(
      channelId,
      channelName,
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, sound: true);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        sendNotification(message.notification.title, message.notification.body);
      }
    });
  }

  static Future onDidReceiveLocalNotification(int id, String title, String body, String payload) {
    return Future.delayed(1.seconds);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  Future sendNotification(String title, String body) async {
    final details = AndroidNotificationDetails(channelId, channelName);
    final platformChannelSpecifics = NotificationDetails(android: details);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().second,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
