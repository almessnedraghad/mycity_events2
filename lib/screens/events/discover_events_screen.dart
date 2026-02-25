import 'package:flutter/material.dart';
import 'event_details_screen.dart';

class DiscoverEventsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> interestedEvents;
  final VoidCallback onOpenInterests;

  const DiscoverEventsScreen({
    super.key,
    required this.interestedEvents,
    required this.onOpenInterests,
});

  @override
  State<DiscoverEventsScreen> createState() =>
      _DiscoverEventsScreenState();
}

class _DiscoverEventsScreenState extends State<DiscoverEventsScreen> {
  // Main orange color used in the app
  final Color primaryColor = const Color(0xFFFF6A00);

  // Temporary event list (later will come from Firebase)
final List<Map<String, dynamic>> eventList = [
  {
    "title": "City Marathon",
    "date": "2026-11-15",
    "time": "06:00",
    "location": "King Abdullah Financial District, Riyadh",
    "category": "Sports",
    "image": "assets/halapartners_SFA_RM_23.jpg",
    "about":
        "Join the annual City Marathon in Riyadh. Choose between 5K, 10K, or full marathon. Open for all fitness levels.",
    "organizer": "Riyadh Sports Committee",
    "isFavorite": false,
  },
  {
    "title": "Art Exhibition",
    "date": "2026-10-02",
    "time": "18:00",
    "location": "Diriyah, Riyadh",
    "category": "Art",
    "image": "assets/event_placeholder.jpg.jpg",
    "about":
        "Explore modern and traditional artworks by local artists. Enjoy live painting sessions and creative workshops.",
    "organizer": "Diriyah Art Society",
    "isFavorite": false,
  },
];

  // Toggle favorite icon
  /*void toggleFavorite(int index) {
    setState(() {
      eventList[index]["isFavorite"] = !(eventList[index]["isFavorite"] as bool);
    });
  }*/
  void toggleFavorite(int index) {
  setState(() {
    eventList[index]["isFavorite"] = !(eventList[index]["isFavorite"] as bool);

    if (eventList[index]["isFavorite"]) {
      widget.interestedEvents.add(eventList[index]);

      //  بعد ما تضيفه، روّح للانترست
      widget.onOpenInterests();
    } else {
      widget.interestedEvents.remove(eventList[index]);
    }
  });
}

  // Open details page
  void openDetails(Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailsScreen(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Top bar
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Discover Events"),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: eventList.length,
        itemBuilder: (context, index) {
          final event = eventList[index];

          return InkWell(
            onTap: () => openDetails(event), //  يفتح صفحة التفاصيل
            borderRadius: BorderRadius.circular(16),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          event["image"],
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),

                        // Favorite icon
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              // عشان لا يفتح التفاصيل لما نضغط القلب
                              toggleFavorite(index);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                event["isFavorite"]
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: event["isFavorite"]
                                    ? primaryColor
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Event details
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event["title"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 6),
                            Text("${event["date"]} at ${event["time"]}"),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(event["location"]),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Category label
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            event["category"],
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}