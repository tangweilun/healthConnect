import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class PushNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          // Uri.parse(
          //     'POST https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAnvuojbI:APA91bGKdFBKGiH3IjDO0WopVp8Tt8HJI4sA5lda0rLf9WFsUoB2VWKMV_AJT08jIh0U7N71pOC75tNEnckiQ1de53395L9ZVLYN9x5CpHYijSBMWDumKHMhm8_JKdLf8GoOzfBtLxBg'
          },
          body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'body': body,
                'title': title,
              },
              "notification": <String, dynamic>{
                "title": title,
                "body": body,
                "android_channel_id": "dbfood"
              },
              "to": token,
            },
          ));
    } catch (e) {
      if (kDebugMode) {
        print('error push notification');
      }
    }
  }

  static void initInfo() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('assets/images/healthConnect_logo');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          "..................................onMessage.....................................");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body!,
        htmlFormatBigText: true,
        contentTitle: message.notification!.title!,
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'dbfood',
        'dbfood',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title!,
        message.notification!.body!,
        platformChannelSpecifics,
      );
    });
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {}
}
