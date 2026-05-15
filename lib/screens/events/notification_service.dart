import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../services/notification_service.dart';

int notificationCount = 0;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const Color primaryColor = Color(0xFFFF6A00);

  int? openIndex;

  //  صارت dynamic عشان نستقبل الإشعارات
  List<String> reminderDocs = NotificationService.reminderDocs;
  List<String> newEventDocs = NotificationService.newEventDocs;
  List<String> updateDocs = NotificationService.updateDocs;
  List<String> upcomingDocs = NotificationService.upcomingDocs;

  /* @override
  void initState() {
    super.initState();
    //  Listen for incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "";
      final body = message.notification?.body ?? "";
      //  Update the appropriate list based on the title
      setState(() {
        if (title.contains("Reminder")) {
          reminderDocs.insert(0, body);
        } else if (title.contains("New Event")) {
          newEventDocs.insert(0, body);
        } else if (title.contains("Update")) {
          updateDocs.insert(0, body);
        } else {
          upcomingDocs.insert(0, body);
        }
      });

      notificationCount++; // Increment the global notification count
    });
  }*/

  Widget buildSection({
    required int index,
    required IconData icon,
    required String title,
    required List<String> docs,
  }) {
    bool isOpen = openIndex == index;
    //  This widget builds each notification section with a header and expandable content
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: primaryColor),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            trailing: Icon(
              isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
            onTap: () {
              setState(() {
                openIndex = isOpen ? null : index;
              });
            },
          ),

          if (isOpen)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: docs.isEmpty
                  ? const Text(
                      "No notifications yet",
                      style: TextStyle(color: Colors.black54),
                    )
                  : Column(
                      children: docs.map((text) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              text,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Notifications"),
      ),

      body: ListView(
        children: [
          const SizedBox(height: 10),
          //  Each section corresponds to a different type of notification and can be expanded to show details
          buildSection(
            index: 0,
            icon: Icons.notifications_active,
            title: "Event Reminder",
            docs: reminderDocs,
          ),

          buildSection(
            index: 1,
            icon: Icons.location_on,
            title: "New Event in Your Area",
            docs: newEventDocs,
          ),

          buildSection(
            index: 2,
            icon: Icons.update,
            title: "Event Update",
            docs: updateDocs,
          ),

          buildSection(
            index: 3,
            icon: Icons.event,
            title: "Upcoming Event",
            docs: upcomingDocs,
          ),
        ],
      ),
    );
  }
}
