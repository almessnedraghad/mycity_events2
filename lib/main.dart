import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth/welcome_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

// Local notifications plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Firebase messaging instance
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Notification permission
  await messaging.requestPermission();

  // Local notification initialize
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(settings);

  // Background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      await flutterLocalNotificationsPlugin.show(
        0,
        notification.title,
        notification.body,

        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Default Channel',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );

      final title = notification.title ?? "";
      final body = notification.body ?? "";

      if (title.contains("Reminder")) {
        NotificationService.reminderDocs.insert(0, body);
      } else if (title.contains("New Event")) {
        NotificationService.newEventDocs.insert(0, body);
      } else if (title.contains("Update")) {
        NotificationService.updateDocs.insert(0, body);
      } else {
        NotificationService.upcomingDocs.insert(0, body);
      }

      print("Notification saved");
    }
  });

  // Subscribe to topic
  await FirebaseMessaging.instance.subscribeToTopic("allUsers");

  print("SUBSCRIBED TO TOPIC");

  // Print token
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM TOKEN:");
  print(token);

  runApp(const MyCityEventsApp());
}

class MyCityEventsApp extends StatelessWidget {
  const MyCityEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
