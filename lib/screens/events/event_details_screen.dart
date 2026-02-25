import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class EventDetailsScreen extends StatelessWidget {
  // نستقبل بيانات الحدث من صفحة الليست
  final Map<String, dynamic> event;

  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  static const Color primaryColor = Color(0xFFFF6A00);
  //الرابط يوديك وي بوك
  Future<void> openWeBook() async {
    final Uri url = Uri.parse("https://webook.com");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
  }
}
  @override
  Widget build(BuildContext context) {
    final String title = event["title"] ?? "";
    final String category = event["category"] ?? "";
    final String date = event["date"] ?? "";
    final String time = event["time"] ?? "";
    final String location = event["location"] ?? "";
    final String organizer = event["organizer"] ?? "ُEvent Organizer";
    final String about = event["about"] ??
        "No description yet. Later we will load it from Firebase.";
    final String imagePath = event["image"] ?? "assets/event_placeholder.jpg";

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
                    child: Image.asset(
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
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
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