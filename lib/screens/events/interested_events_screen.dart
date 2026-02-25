import 'package:flutter/material.dart';
import 'event_details_screen.dart';

class InterestedEventsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> interestedEvents;

  const InterestedEventsScreen({
    super.key,
    required this.interestedEvents,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFF6A00);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Interests"),
      ),
      body: interestedEvents.isEmpty
          ? const Center(child: Text("No interested events yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: interestedEvents.length,
              itemBuilder: (context, index) {
                final event = interestedEvents[index];

                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      event["image"],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(event["title"]),
                  subtitle: Text("${event["date"]} • ${event["location"]}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailsScreen(event: event),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}