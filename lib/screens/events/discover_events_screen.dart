import 'package:flutter/material.dart';
import 'event_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class DiscoverEventsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> interestedEvents;
  final VoidCallback onOpenInterests;
  final List<Map<String, dynamic>> flaggedEvents;// مؤقت عشان صفحة المودريشن بعدين نجيبها من الفايرستور
  final Function(List<Map<String, dynamic>>)? onEventsLoaded;/////////////
  
  const DiscoverEventsScreen({
    super.key,
    required this.interestedEvents,
    required this.onOpenInterests,
    required this.flaggedEvents,
    this.onEventsLoaded,////////////////////////////

  });

  @override
  State<DiscoverEventsScreen> createState() => _DiscoverEventsScreenState();
}

class _DiscoverEventsScreenState extends State<DiscoverEventsScreen> {
  // Main orange color used in the app
  final Color primaryColor = const Color(0xFFFF6A00);

  // ---------------- FILTER STATE (Front-end only) ----------------
  bool showFilters = false;

  String? selectedCategory; // null = All
  String? selectedLocation; // null = All
  DateTime? selectedDate; // null = All (day match)
  
   List<Map<String, dynamic>> eventList = [];
   List<String> interestedIds = [];//UPDATE: we need to track interested event IDs to manage favorites properly
   StreamSubscription? eventsSub;
   StreamSubscription? interestsSub;

@override
void initState() {
  super.initState();
  listenToEvents();
   listenToInterests();//UPDATE
}

/////////////////////////////////////////////////////////////UPDATE
void listenToInterests() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  interestsSub = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .listen((doc) {

    final data = doc.data();

    setState(() {
      interestedIds = List<String>.from(
        data?["interestedEvents"] ?? []
      );
    });

  });
}
//////////////////////////////////////////////////////////////////////////




void listenToEvents() {

  eventsSub = FirebaseFirestore.instance
      .collection('events')
      .snapshots()
      .listen((snapshot) {
    final events = snapshot.docs.map((doc) {
      final data = doc.data();

      return {
        "id": doc.id,
        "title": data["title"] ?? "",
        "status": data["status"] ?? "active",
        "date": data["date"] ?? "",
        "time": data["time"] ?? "",
        "location": data["location"] ?? "",
        "category": data["category"] ?? "",
        "image": data["imageUrl"] ?? "",
        "about": data["description"] ?? "",
        "organizer": data["organizerId"] ?? "",
      };
    }).where((e) => e["status"] == "active").toList();

    setState(() {
      eventList = events;
    });
    widget.onEventsLoaded?.call(events); /////////////////////////

  });

}
@override
void dispose() {
  eventsSub?.cancel();
  interestsSub?.cancel();
  super.dispose();
}

  // ---------------- Helpers for dropdown options ----------------
  List<String> get categories {
    final set = <String>{};
    for (final e in eventList) {
      final c = (e["category"] ?? "").toString().trim();
      if (c.isNotEmpty) set.add(c);
    }
    final list = set.toList()..sort();
    return list;
  }

  List<String> get locations {
    // Full location is long; we still filter by exact string.
    // (If you want city-only later, we can extract "Riyadh" from the end.)
    final set = <String>{};
    for (final e in eventList) {
      final l = (e["location"] ?? "").toString().trim();
      if (l.isNotEmpty) set.add(l);
    }
    final list = set.toList()..sort();
    return list;
  }

  // Parse "YYYY-MM-DD" safely
  DateTime? _parseEventDate(String? date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date);
    } catch (_) {
      return null;
    }
  }

  // ---------------- FRONT-END FILTERING ----------------
  List<Map<String, dynamic>> get filteredEvents {
    return eventList.where((event) {
      // Category filter
      final matchCategory = selectedCategory == null
          ? true
          : (event["category"] == selectedCategory);

      // Location filter
      final matchLocation = selectedLocation == null
          ? true
          : (event["location"] == selectedLocation);

      // Date filter (same day)
      bool matchDate = true;
      if (selectedDate != null) {
        final eventDate = _parseEventDate(event["date"]?.toString());
        if (eventDate == null) {
          matchDate = false;
        } else {
          matchDate =
              eventDate.year == selectedDate!.year &&
              eventDate.month == selectedDate!.month &&
              eventDate.day == selectedDate!.day;
        }
      }

      return matchCategory && matchLocation && matchDate;
    }).toList();
  }

  // Toggle favorite icon
  Future<void> toggleFavorite(Map<String, dynamic> event) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final eventId = event["id"];
  final isLiked = interestedIds.contains(eventId);

  if (isLiked) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({
      "interestedEvents": FieldValue.arrayRemove([eventId]),
    });

    setState(() {
      interestedIds.remove(eventId);
      widget.interestedEvents.removeWhere((e) => e["id"] == eventId);
    });
  } else {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      "interestedEvents": FieldValue.arrayUnion([eventId]),
    }, SetOptions(merge: true));

    setState(() {
      interestedIds.add(eventId);

      final alreadyAdded =
          widget.interestedEvents.any((e) => e["id"] == eventId);

      if (!alreadyAdded) {
        widget.interestedEvents.add(event);
      }
    });
  }
}
 /* void toggleFavorite(int indexInFiltered) {
    // IMPORTANT: your list is filtered now, so index is for filteredEvents.
    // We must find the same event in the original eventList.
    final filtered = filteredEvents;
    final event = filtered[indexInFiltered];

    final originalIndex = eventList.indexOf(event);

    if (originalIndex == -1) return;

    setState(() {
      eventList[originalIndex]["isFavorite"] =
          !(eventList[originalIndex]["isFavorite"] as bool);

      if (eventList[originalIndex]["isFavorite"]) {
        widget.interestedEvents.add(eventList[originalIndex]);
        widget.onOpenInterests();
      } else {
        widget.interestedEvents.remove(eventList[originalIndex]);
      }
    });
  }*/

  // Open details page
  void openDetails(Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event)),
    );
  }

  // Clear filters
  void clearFilters() {
    setState(() {
      selectedCategory = null;
      selectedLocation = null;
      selectedDate = null;
    });
  }

  // UI input style (matches your soft gray fields)
  InputDecoration _fieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF2F2F2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listToShow = filteredEvents;

    return Scaffold(
      backgroundColor: Colors.white,

      // Top bar
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Discover Events"),
      ),

      body: Column(
        children: [
          // -------- Filters button + panel --------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => setState(() => showFilters = !showFilters),
                  icon: Icon(Icons.tune, color: primaryColor),
                  label: Text("Filters", style: TextStyle(color: primaryColor)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  "${listToShow.length} events",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),

          if (showFilters)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  const Text("Category", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: _fieldDecoration(),
                    hint: const Text("All Categories"),
                    items: categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedCategory = v),
                  ),

                  const SizedBox(height: 14),

                  // Location
                  const Text("Location", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedLocation,
                    decoration: _fieldDecoration(),
                    hint: const Text("All Locations"),
                    items: locations
                        .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedLocation = v),
                  ),

                  const SizedBox(height: 14),

                  // Date
                  const Text("Date", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                        initialDate: selectedDate ?? DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: _fieldDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate == null
                                ? "All Dates"
                                : "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}",
                          ),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: clearFilters,
                      child: const Text("Clear filters"),
                    ),
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),

          // -------- Events list --------
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listToShow.length,
              itemBuilder: (context, index) {
                final event = listToShow[index];
                bool isLiked = interestedIds.contains(event["id"] ?? "");

                return InkWell(
                  onTap: () => openDetails(event), // open details
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
                              Image.network(
                                event["image"],
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),

                              // Favorite icon
                              Positioned(
                              top: 10,
                              right: 10,
                              child: Row(
                                children: [
                                  //  Favorite
                                  GestureDetector(
                                    onTap: () {
                                      toggleFavorite(event);
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                             isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isLiked
                                            ? primaryColor
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  //  Report
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          String? selectedReason;

                                          return AlertDialog(
                                            title: const Text("Report Event"),
                                            content: StatefulBuilder(
                                              builder: (context, setStateDialog) {
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    RadioListTile(
                                                      title: const Text("Spam"),
                                                      value: "Spam",
                                                      groupValue: selectedReason,
                                                      onChanged: (value) {
                                                        setStateDialog(() => selectedReason = value.toString());
                                                      },
                                                    ),
                                                    RadioListTile(
                                                      title: const Text("Inappropriate"),
                                                      value: "Inappropriate",
                                                      groupValue: selectedReason,
                                                      onChanged: (value) {
                                                        setStateDialog(() => selectedReason = value.toString());
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);

                                                  await FirebaseFirestore.instance.collection('reported_events').add({
                                                        "title": event["title"],
                                                        "date": event["date"],
                                                        "time": event["time"],
                                                        "location": event["location"],
                                                        "category": event["category"],
                                                        "imageUrl": event["image"],
                                                        "description": event["about"],
                                                        "organizerId": event["organizer"],
                                                        "reportedAt": FieldValue.serverTimestamp(),
                                                      });

                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text("Event reported")),
                                                  );
                                                },
                                                child: const Text("Submit"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.flag, color: Colors.orange),
                                    ),
                                  ),
                                ],
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
                                  Expanded(child: Text(event["location"])),
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
          ),
        ],
      ),
    );
  }
}
