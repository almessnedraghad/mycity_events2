import 'package:flutter/material.dart';
import 'event_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InterestedEventsScreen extends StatefulWidget {
  List<Map<String, dynamic>> interestedEvents = [];

  InterestedEventsScreen({super.key});

  @override
  State<InterestedEventsScreen> createState() => _InterestedEventsScreenState();
}

class _InterestedEventsScreenState extends State<InterestedEventsScreen> {
  List<Map<String, dynamic>> interestedEvents = [];

  void listenToInterestedEvents() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((userDoc) async {
          final ids = List<String>.from(
            userDoc.data()?["interestedEvents"] ?? [],
          );

          /*final eventsSnapshot = await FirebaseFirestore.instance
              .collection('events')
              .get();*/
          final eventsSnapshot = await FirebaseFirestore.instance
              .collection('events')
              .where("status", isEqualTo: "active")
              .get();

          final events = eventsSnapshot.docs
              .where((doc) => ids.contains(doc.id))
              .map((doc) {
                final data = doc.data();

                return {
                  "id": doc.id,
                  "title": data["title"],
                  "date": data["date"],
                  "location": data["location"],
                  "image": data["imageUrl"],
                  "category": data["category"],
                };
              })
              .toList();

          /*if (mounted) {
            setState(() {
              interestedEvents = events;
            });
          }*/
          if (!mounted) return;

          setState(() {
            interestedEvents = List<Map<String, dynamic>>.from(events);
          });

          print(interestedEvents);
        });
  }

  /*@override
  void initState() {
    super.initState();
    listenToInterestedEvents();
    // interestedEvents = widget.interestedEvents;
    //loadInterestedEvents();
  }*/
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      listenToInterestedEvents();
    });
  }

  Future<void> loadInterestedEvents() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final ids = List<String>.from(userDoc.data()?["interestedEvents"] ?? []);

    /*final eventsSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .get();*/
    final eventsSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where("status", isEqualTo: "active")
        .get();

    final events = eventsSnapshot.docs.where((doc) => ids.contains(doc.id)).map(
      (doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          "title": data["title"],
          "date": data["date"],
          "location": data["location"],
          "image": data["imageUrl"],
          "category":
              data["category"], ////////////////////////////////////////////
        };
      },
    ).toList();

    setState(() {
      interestedEvents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFF6A00);

    print("EVENTS COUNT: ${interestedEvents.length}");

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
                    child: Image.network(
                      event["image"],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),

                  title: Text(event["title"]),
                  subtitle: Text("${event["date"]} • ${event["location"]}"),

                  //  زر الحذف
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () async {
                      //UPDATE
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return;

                      final event = interestedEvents[index];

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({
                            "interestedEvents": FieldValue.arrayRemove([
                              event["id"],
                            ]),
                          });

                      setState(() {
                        interestedEvents.removeAt(index);
                      });
                    },
                  ),

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
