

import 'package:flutter/material.dart';
import 'mission.dart';
import 'upload.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Cấu hình các cài đặt cho plugin
  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  );

  MyApp({Key? key}) : super(key: key) {
    initializeNotifications();
  }

  void initializeNotifications() async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Notification Title',
      'Notification Body',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Demo'),
            bottom: const TabBar(
              tabs: [
                Tab(
                    icon: Icon(Icons.star),
                    text:
                        "Mission"), // Replace Icons.mission with your preferred icon
                Tab(
                    icon: Icon(Icons.star),
                    text:
                        "Upload"), // Replace Icons.empty with your preferred icon
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Mission(mission: {}), // Your Mission screen
              Upload() // Your empty screen
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showNotification();
            },
            child: const Icon(Icons.notifications),
          ),
        ),
      ),
    );
  }
}
