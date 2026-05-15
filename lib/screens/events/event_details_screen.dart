import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/services/reminder_service.dart';
import 'dart:async';
class EventDetailsScreen extends StatefulWidget {
  // نستقبل بيانات الحدث من صفحة الليست
  final Map<String, dynamic> event;

  const EventDetailsScreen({
    super.key,
    required this.event,
  });


  @override
      State<EventDetailsScreen> createState() => _EventDetailsScreenState();
      }

      class _EventDetailsScreenState extends State<EventDetailsScreen> {
        bool isFavorite = false;
        StreamSubscription? favSub;
        
        static const Color primaryColor = Color(0xFFFF6A00);
        
      @override
        void initState() {
        super.initState();
        listenToFavorite();
        increaseViews();
      }

       //  نتحقق إذا كان الحدث موجود في اهتمامات المستخدم عشان نعرض الايقونة المناسبة
       void listenToFavorite() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  favSub = FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid)
      .snapshots()
      .listen((doc) {

    final data = doc.data();
 
    List<String> interests = List<String>.from(
    data?["interestedEvents"] ?? []
);

    setState(() {
      isFavorite = interests.contains(widget.event["id"]);
    });

  });
}
Future<void> increaseViews() async {
  final eventId = widget.event["id"];

  await FirebaseFirestore.instance
      .collection("events")
      .doc(eventId)
      .update({
    "views": FieldValue.increment(1),
  });
}
Future<void> toggleFavorite() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final eventId = widget.event["id"];

  // مرجع الحدث
  final eventRef = FirebaseFirestore.instance
      .collection("events")
      .doc(eventId);

  if (isFavorite) {
    // REMOVE
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update({
      "interestedEvents": FieldValue.arrayRemove([eventId])
    });

    // نقص الانترست
    await eventRef.update({
      "interestedCount": FieldValue.increment(-1),
    });

  } else {
    // ADD
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update({
      "interestedEvents": FieldValue.arrayUnion([eventId])
    });

    // زيد الانترست
    await eventRef.update({
      "interestedCount": FieldValue.increment(1),
    });

    ReminderService.addReminder(
      title: widget.event["title"],
      date: widget.event["date"],
      time: widget.event["time"],
    );
  }
}
        //  لما المستخدم يضغط على الايقونة، نضيف او نشيل الحدث من اهتمامات المستخدم في الفايرستور
        /*Future<void> toggleFavorite() async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) return;

                  final eventId = widget.event["id"];

                  if (!isFavorite) {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(user.uid)
                        .update({
                      "interestedEvents": FieldValue.arrayRemove([eventId])
                    });
                  } else {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(user.uid)
                        .update({
                      "interestedEvents": FieldValue.arrayUnion([eventId])
                    });
                  }

                   
                    if (isFavorite) {
                        ReminderService.addReminder(
                          title: widget.event["title"],
                          date: widget.event["date"],
                          time: widget.event["time"],
                        );
                      }
                  }
                  @override
                  void dispose() {
                    favSub?.cancel(); 
                    super.dispose();
                  }*/

 // static const Color primaryColor = Color(0xFFFF6A00);
  //الرابط يوديك وي بوك
  Future<void> openWeBook() async {
    final Uri url = Uri.parse("https://webook.com");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
  }
}
  @override
  Widget build(BuildContext context) {
    final String title = widget.event["title"] ?? "";
    final String category = widget.event["category"] ?? "";
    final String date = widget.event["date"] ?? "";
    final String time = widget.event["time"] ?? "";
    final String location = widget.event["location"] ?? "";
    final String organizer = widget.event["organizer"] ?? "Event Organizer";
    final String about = widget.event["about"] ??
        "No description yet. Later we will load it from Firebase.";
    final String imagePath = widget.event["image"] ?? "assets/event_placeholder.jpg";
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            //  Top image + back + favorite
            Stack(
              children: [
                SizedBox(
                  height: 260,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(18),
                    ),
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        "assets/event_placeholder.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Back button
                Positioned(
                  top: 12,
                  left: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                // Favorite icon 
                Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black,
                            ),
                      onPressed: toggleFavorite,
                    ),
                  ),
                ),
              ],
            ),

            //  Details card
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Category chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Date & time
                      _InfoRow(
                        icon: Icons.calendar_today,
                        title: "Date & Time",
                        value: "$date at $time",
                      ),
                      const SizedBox(height: 12),

                      // Location
                      _InfoRow(
                        icon: Icons.location_on,
                        title: "Location",
                        value: location,
                      ),
                      const SizedBox(height: 12),

                      // Organizer
                      _InfoRow(
                        icon: Icons.person,
                        title: "Organizer",
                        value: organizer,
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "About This Event",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        about,
                        style: const TextStyle(color: Colors.black87, height: 1.4),
                      ),

                      const SizedBox(height: 18),

                      // Link (
                      /*Row(
                        children: const [
                          Icon(Icons.link, color: primaryColor, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Book tickets on official website",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),*/

                      const SizedBox(height: 22),

                      // Bottom button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D0D2B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: openWeBook,
                          child: const Text(
                            "Book Tickets",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget صغير مرتب لعرض سطر معلومات (ايقونة + عنوان + قيمة)
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}