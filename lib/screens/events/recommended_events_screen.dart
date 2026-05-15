/*import 'package:flutter/material.dart';
import 'event_details_screen.dart';

class RecommendedEventsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> allEvents;
  final List<Map<String, dynamic>> interestedEvents;

  const RecommendedEventsScreen({
    super.key,
    required this.allEvents,
    required this.interestedEvents,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFF6A00);

    List<Map<String, dynamic>> recommendedEvents = [];

    //  اذا مافي اهتمامات
    if (interestedEvents.isEmpty) {
      // نعرض ايفنت عشوائية
      recommendedEvents = List.from(allEvents)..shuffle();
      recommendedEvents = recommendedEvents.take(5).toList();
    } else {
      //  اذا فيه اهتمامات

      // نجيب الكاتيجوريز
      final interestCategories =
          interestedEvents.map((e) => e["category"]).toSet();

      // نجيب العناوين عشان نمنع التكرار
      final interestedTitles =
          interestedEvents.map((e) => e["title"]).toSet();

      // نفلترة الايفنتات
      recommendedEvents = allEvents.where((event) {
        return interestCategories.contains(event["category"]) &&
               !interestedTitles.contains(event["title"]);
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Recommended Events"),
      ),
      body: recommendedEvents.isEmpty
          ? const Center(
              child: Text("No events available"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recommendedEvents.length,
              itemBuilder: (context, index) {
                final event = recommendedEvents[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        event["image"],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      event["title"],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "${event["date"]} • ${event["location"]}",
                    ),
                    trailing: interestedEvents.isEmpty
                        ? const Icon(Icons.explore, color: Colors.orange)
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EventDetailsScreen(event: event),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}--------------------------------------------------------------------------*/
/*import 'package:flutter/material.dart';
import 'event_details_screen.dart';

class RecommendedEventsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> allEvents;
  final List<Map<String, dynamic>> interestedEvents;

  const RecommendedEventsScreen({
    super.key,
    required this.allEvents,
    required this.interestedEvents,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFF6A00);

    List<Map<String, dynamic>> recommendedEvents = [];

    // ================== RECOMMENDATION LOGIC ==================

    // اذا المستخدم ماعنده اهتمامات
    if (interestedEvents.isEmpty) {

      // نعرض ايفنتات عشوائية
      recommendedEvents = List.from(allEvents)..shuffle();

      // ناخذ اول 5 فقط
      recommendedEvents = recommendedEvents.take(5).toList();

    } else {

      // نجيب الكاتيجوريز من الايفنتات المفضلة
      final interestCategories =
          interestedEvents.map((e) => e["category"]).toSet();

      // نجيب عناوين الايفنتات عشان نمنع التكرار
      final interestedTitles =
          interestedEvents.map((e) => e["title"]).toSet();

      // نفلتر الايفنتات
      recommendedEvents = allEvents.where((event) {

        return interestCategories.contains(event["category"]) &&
            !interestedTitles.contains(event["title"]);

      }).toList();

      // اذا الفلترة ما رجعت نتائج
      // نعرض ايفنتات عشوائية كبديل
      if (recommendedEvents.isEmpty && allEvents.isNotEmpty) {

        recommendedEvents = List.from(allEvents)..shuffle();

        recommendedEvents =
            recommendedEvents.take(5).toList();
      }
    }

    // ================== UI ==================

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Recommended Events"),
      ),

      body: recommendedEvents.isEmpty

          // اذا مافي ايفنتات اساساً
          ? const Center(
              child: Text("No events available"),
            )

          // عرض التوصيات
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recommendedEvents.length,

              itemBuilder: (context, index) {

                final event = recommendedEvents[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  margin: const EdgeInsets.only(bottom: 12),

                  child: ListTile(

                    // صورة الايفنت
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),

                      child: Image.asset(
                        event["image"],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // عنوان الايفنت
                    title: Text(
                      event["title"],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // التاريخ والموقع
                    subtitle: Text(
                      "${event["date"]} • ${event["location"]}",
                    ),

                    // ايقونة استكشاف اذا ماعنده اهتمامات
                    trailing: interestedEvents.isEmpty
                        ? const Icon(
                            Icons.explore,
                            color: Colors.orange,
                          )
                        : null,

                    // فتح صفحة التفاصيل
                    onTap: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              EventDetailsScreen(event: event),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'event_details_screen.dart';

class RecommendedEventsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> allEvents;
  final List<Map<String, dynamic>> interestedEvents;

  const RecommendedEventsScreen({
    super.key,
    required this.allEvents,
    required this.interestedEvents,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFF6A00);

    List<Map<String, dynamic>> recommendedEvents = [];

    if (interestedEvents.isEmpty) {
      recommendedEvents = List.from(allEvents)..shuffle();
      recommendedEvents = recommendedEvents.take(5).toList();
    } else {
      final interestCategories =
          interestedEvents.map((e) => e["category"]).toSet();

      final interestedTitles =
          interestedEvents.map((e) => e["title"]).toSet();

      recommendedEvents = allEvents.where((event) {
        return interestCategories.contains(event["category"]) &&
            !interestedTitles.contains(event["title"]);
      }).toList();

      if (recommendedEvents.isEmpty && allEvents.isNotEmpty) {
        recommendedEvents = List.from(allEvents)..shuffle();
        recommendedEvents = recommendedEvents.take(5).toList();
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Recommended Events"),
      ),
      body: recommendedEvents.isEmpty
          ? const Center(child: Text("No events available"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recommendedEvents.length,
              itemBuilder: (context, index) {
                final event = recommendedEvents[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network( 
                        event["image"],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported),
                      ),
                    ),
                    title: Text(
                      event["title"],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("${event["date"]} • ${event["location"]}"),
                    trailing: interestedEvents.isEmpty
                        ? const Icon(Icons.explore, color: Colors.orange)
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventDetailsScreen(event: event),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}