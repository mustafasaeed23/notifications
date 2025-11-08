import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifications/main.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // request permission to notifications
    FirebaseMessaging.instance.requestPermission();
    // recive notifications in app
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
            ),
          ),
        );
      }
    });
  }

  // test
  void sendTestNotification() {
    flutterLocalNotificationsPlugin.show(
      0,
      "إشعار تجريبي",
      "تم الضغط على الزر بنجاح",
      NotificationDetails(
        android: AndroidNotificationDetails(
          color: Colors.amberAccent,
          colorized: true,
          playSound: true,
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: "@mipmap/ic_launcher",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Wait for notifications",
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(color: Colors.black),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendTestNotification,
              child: const Text("Send Test Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
