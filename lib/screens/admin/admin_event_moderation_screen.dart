/*import 'package:flutter/material.dart';

class AdminEventModerationScreen extends StatefulWidget {
  final List<Map<String, dynamic>> flaggedEvents;

  const AdminEventModerationScreen({
    super.key,
    required this.flaggedEvents,
  });

  @override
  State<AdminEventModerationScreen> createState() =>
      _AdminEventModerationScreenState();
}

class _AdminEventModerationScreenState
    extends State<AdminEventModerationScreen>
    with SingleTickerProviderStateMixin {

  static const Color orange = Color(0xFFFF6A00);

  late TabController _tabController;

  //  كل الأحداث (مؤقت)
  final List<Map<String, dynamic>> allEvents = [
    {
      "title": "City Marathon",
      "date": "2025-11-15",
      "location": "Riyadh",
      "category": "Sports",
      "image": "https://images.unsplash.com/photo-1508609349937-5ec4ae374ebf"
    },
    {
      "title": "Music Festival",
      "date": "2025-12-01",
      "location": "Riyadh Front",
      "category": "Music",
      "image": "https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void removeEvent(Map<String, dynamic> event) {
    setState(() {
      allEvents.remove(event);
      widget.flaggedEvents.remove(event);
    });
  }

  Widget buildCard(Map<String, dynamic> event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // صورة
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              event["image"],
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  event["title"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 6),
                    Text(event["date"]),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16),
                    const SizedBox(width: 6),
                    Expanded(child: Text(event["location"])),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(event["category"]),
                    ),

                    OutlinedButton.icon(
                      onPressed: () => removeEvent(event),
                      icon: const Icon(Icons.delete),
                      label: const Text("Remove"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      body: SafeArea(
        child: Column(
          children: [

            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              color: orange,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Event Moderation",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Monitor and manage all events",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            //  TABS
            Material(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: orange,
                indicatorColor: orange,
                tabs: [
                  Tab(text: "All (${allEvents.length})"),
                  Tab(text: "Flagged (${widget.flaggedEvents.length})"),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [

                  //  ALL EVENTS
                  ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: allEvents.length,
                    itemBuilder: (context, index) {
                      return buildCard(allEvents[index]);
                    },
                  ),

                  //  FLAGGED
                  widget.flaggedEvents.isEmpty
                      ? const Center(child: Text("No reported events"))
                      : ListView.builder(
                          padding: const EdgeInsets.all(14),
                          itemCount: widget.flaggedEvents.length,
                          itemBuilder: (context, index) {
                            return buildCard(widget.flaggedEvents[index]);
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminEventModerationScreen extends StatefulWidget {
  const AdminEventModerationScreen({super.key});

  @override
  State<AdminEventModerationScreen> createState() =>
      _AdminEventModerationScreenState();
}

class _AdminEventModerationScreenState
    extends State<AdminEventModerationScreen>
    with SingleTickerProviderStateMixin {

  static const Color orange = Color(0xFFFF6A00);

  late TabController _tabController;

  // ALL EVENTS (temporary until we fetch from Firestore)
  List<Map<String, dynamic>> allEvents = [];

  //  EVENTS FLAGGED BY USERS 
  List<Map<String, dynamic>> flaggedEvents = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    listenToAllEvents();
    listenToReportedEvents();
  }

  // ALL EVENTS
  void listenToAllEvents() {
    FirebaseFirestore.instance.collection('events').snapshots().listen((snapshot) {
      final data = snapshot.docs.map((doc) {
        final e = doc.data();
        return {
          "id": doc.id,
          "title": e["title"] ?? "",
          "date": e["date"] ?? "",
          "location": e["location"] ?? "",
          "category": e["category"] ?? "",
          "image": e["imageUrl"] ?? "",
        };
      }).toList();

      setState(() {
        allEvents = data;
      });
    });
  }

  // Firebase stream to listen to reported events in real-time and update the flaggedEvents list
  void listenToReportedEvents() {
    FirebaseFirestore.instance
        .collection('reported_events')
        .snapshots()
        .listen((snapshot) {

      final data = snapshot.docs.map((doc) {
        final e = doc.data();
        return {
          "id": doc.id,
          "title": e["title"] ?? "",
          "date": e["date"] ?? "",
          "location": e["location"] ?? "",
          "category": e["category"] ?? "",
          "image": e["imageUrl"] ?? "",
        };
      }).toList();

      setState(() {
        flaggedEvents = data;
      });
    });
  }

  // Remove event from Firestore (either from 'events' or 'reported_events' collection)
  void removeEvent(Map<String, dynamic> event, bool isReported) async {
    final id = event["id"];

    if (isReported) {
      await FirebaseFirestore.instance
          .collection('reported_events')
          .doc(id)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(id)
          .delete();
    }
  }

  Widget buildCard(Map<String, dynamic> event, bool isReported) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              event["image"],
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  event["title"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 6),
                    Text(event["date"]),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16),
                    const SizedBox(width: 6),
                    Expanded(child: Text(event["location"])),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(event["category"]),
                    ),

                    OutlinedButton.icon(
                      onPressed: () => removeEvent(event, isReported),
                      icon: const Icon(Icons.delete),
                      label: const Text("Remove"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      body: SafeArea(
        child: Column(
          children: [

            // HEADER 
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              color: orange,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Event Moderation",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Monitor and manage all events",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Tabs
            Material(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: orange,
                indicatorColor: orange,
                tabs: [
                  Tab(text: "All (${allEvents.length})"),
                  Tab(text: "Flagged (${flaggedEvents.length})"),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [

                  // ALL
                  ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: allEvents.length,
                    itemBuilder: (context, index) {
                      return buildCard(allEvents[index], false);
                    },
                  ),

                  // FLAGGED
                  flaggedEvents.isEmpty
                      ? const Center(child: Text("No reported events"))
                      : ListView.builder(
                          padding: const EdgeInsets.all(14),
                          itemCount: flaggedEvents.length,
                          itemBuilder: (context, index) {
                            return buildCard(flaggedEvents[index], true);
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}