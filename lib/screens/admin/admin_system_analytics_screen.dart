/*import 'package:flutter/material.dart';

class AdminSystemAnalyticsScreen extends StatelessWidget {
const AdminSystemAnalyticsScreen({super.key});

static const Color orange = Color(0xFFFF6A00);

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFF4F4F4),
  body: SafeArea(
    child: Column(
      children: [

        // ===== HEADER =====
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 18),
          color: orange,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "System Analytics",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Overview of myCity Event platform",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            children: [

              // ===== STATS =====
              Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      title: "Total Users",
                      value: "1,247",
                      subtitle: "+12% this month",
                      icon: Icons.people,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: "Total Events",
                      value: "342",
                      subtitle: "+8% this month",
                      icon: Icons.calendar_today,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      title: "Active Events",
                      value: "89",
                      subtitle: "Happening now",
                      icon: Icons.show_chart,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: "Engagement",
                      value: "87%",
                      subtitle: "+5% this month",
                      icon: Icons.trending_up,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ===== USER BREAKDOWN =====
              _CardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "User Breakdown",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 16),
                    _ProgressRow("Regular Users", 935, 0.8, Colors.orange),
                    _ProgressRow("Organizers", 289, 0.3, Colors.orange),
                    _ProgressRow("Admins", 23, 0.1, Colors.green),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== POPULAR CATEGORIES =====
              _CardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Popular Categories",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 16),
                    _CategoryRow("Music", "98 events"),
                    _CategoryRow("Sports", "76 events"),
                    _CategoryRow("Food", "64 events"),
                  ],
                ),
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

// ===== UI COMPONENTS =====

class _StatCard extends StatelessWidget {
final String title, value, subtitle;
final IconData icon;
final Color color;

const _StatCard({
required this.title,
required this.value,
required this.subtitle,
required this.icon,
required this.color,
});

@override
Widget build(BuildContext context) {
return Container(
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(16),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Icon(icon, color: color),
const SizedBox(height: 10),
Text(title, style: const TextStyle(color: Colors.grey)),
const SizedBox(height: 6),
Text(value,
style: const TextStyle(
fontSize: 22, fontWeight: FontWeight.w800)),
const SizedBox(height: 4),
Text(subtitle,
style: const TextStyle(color: Colors.green, fontSize: 12)),
],
),
);
}
}

class _ProgressRow extends StatelessWidget {
final String label;
final int value;
final double progress;
final Color color;

const _ProgressRow(this.label, this.value, this.progress, this.color);

@override
Widget build(BuildContext context) {
return Padding(
padding: const EdgeInsets.only(bottom: 12),
child: Row(
children: [
SizedBox(width: 120, child: Text(label)),
Expanded(
child: LinearProgressIndicator(
value: progress,
color: color,
backgroundColor: Colors.grey.shade300,
),
),
const SizedBox(width: 10),
Text(value.toString()),
],
),
);
}
}

class _CategoryRow extends StatelessWidget {
final String name;
final String count;

const _CategoryRow(this.name, this.count);

@override
Widget build(BuildContext context) {
return Padding(
padding: const EdgeInsets.only(bottom: 10),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(name),
Text(count, style: const TextStyle(color: Colors.grey)),
],
),
);
}
}

class _CardContainer extends StatelessWidget {
final Widget child;

const _CardContainer({required this.child});

@override
Widget build(BuildContext context) {
return Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(16),
),
child: child,
);
}
}
-------------------------------------------------*/
/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSystemAnalyticsScreen extends StatefulWidget {
  const AdminSystemAnalyticsScreen({super.key});

  @override
  State<AdminSystemAnalyticsScreen> createState() =>
      _AdminSystemAnalyticsScreenState();
}

class _AdminSystemAnalyticsScreenState
    extends State<AdminSystemAnalyticsScreen> {
  static const Color orange = Color(0xFFFF6A00);

  int totalUsers = 0;
  int totalEvents = 0;
  int activeEvents = 0;

  Map<String, int> categoryCount = {};

  @override
  void initState() {
    super.initState();
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    final eventsSnapshot =
        await FirebaseFirestore.instance.collection('events').get();

    int active = 0;
    Map<String, int> categories = {};

    for (var doc in eventsSnapshot.docs) {
      final data = doc.data();

      // active events
      if (data["date"] != null) {
        final date = DateTime.tryParse(data["date"]);
        if (date != null && date.isAfter(DateTime.now())) {
          active++;
        }
      }

      // category count
      String category = data["category"] ?? "Other";
      categories[category] = (categories[category] ?? 0) + 1;
    }

    setState(() {
      totalUsers = usersSnapshot.docs.length;
      totalEvents = eventsSnapshot.docs.length;
      activeEvents = active;
      categoryCount = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 18),
              color: orange,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "System Analytics",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Overview of myCity Event platform",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                children: [
                  // ===== STATS =====
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: "Total Users",
                          value: totalUsers.toString(),
                          subtitle: "",
                          icon: Icons.people,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: "Total Events",
                          value: totalEvents.toString(),
                          subtitle: "",
                          icon: Icons.calendar_today,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: "Active Events",
                          value: activeEvents.toString(),
                          subtitle: "Happening now",
                          icon: Icons.show_chart,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: _StatCard(
                          title: "Engagement",
                          value: "87%",
                          subtitle: "+5% this month",
                          icon: Icons.trending_up,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ===== USER BREAKDOWN =====
                  _CardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "User Breakdown",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ProgressRow(
                            "Regular Users", totalUsers, 0.8, Colors.orange),
                        _ProgressRow(
                            "Organizers", (totalUsers * 0.2).toInt(), 0.3,
                            Colors.orange),
                        _ProgressRow("Admins", 5, 0.1, Colors.green),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== POPULAR CATEGORIES =====
                  _CardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Popular Categories",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),

                        ...categoryCount.entries.map((e) {
                          return _CategoryRow(
                              e.key, "${e.value} events");
                        }).toList(),
                      ],
                    ),
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

// ===== UI COMPONENTS =====

class _StatCard extends StatelessWidget {
  final String title, value, subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(color: Colors.green, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final int value;
  final double progress;
  final Color color;

  const _ProgressRow(this.label, this.value, this.progress, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              color: color,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
          const SizedBox(width: 10),
          Text(value.toString()),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String name;
  final String count;

  const _CategoryRow(this.name, this.count);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(count, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}---------------------------------------------------------------------------------*/
/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSystemAnalyticsScreen extends StatefulWidget {
  const AdminSystemAnalyticsScreen({super.key});

  @override
  State<AdminSystemAnalyticsScreen> createState() =>
      _AdminSystemAnalyticsScreenState();
}

class _AdminSystemAnalyticsScreenState
    extends State<AdminSystemAnalyticsScreen> {
  static const Color orange = Color(0xFFFF6A00);

  int totalUsers = 0;
  int totalEvents = 0;
  int activeEvents = 0;

   int admins = 0;
  int organizers = 0;
  int usersOnly = 0;
  String engagement = "0";

  Map<String, int> categoryCount = {};

  @override
  void initState() {
    super.initState();
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
  final usersSnapshot =
      await FirebaseFirestore.instance.collection('users').get();

  final eventsSnapshot =
      await FirebaseFirestore.instance
          .collection('events')
          .where('status', whereIn: ['approved', 'active'])
          .get();

  int active = 0;
    int adminsCount = 0;
    int organizersCount = 0;
    int usersCount = 0;
    int totalInterested = 0;

  

  //Map<String, int> categoryCount = {};
  Map<String, Map<String, dynamic>> eventMap = {};

  //  USERS 
  for (var user in usersSnapshot.docs) {
    final data = user.data();

    // roles
    String role = data["role"] ?? "user";

    if (role == "admin") {
        adminsCount++;
      } else if (role == "organizer") {
        organizersCount++;
      } else {
        usersCount++;
      }

    // interested events
    List ids = data["interestedEvents"] ?? [];
    totalInterested += ids.length;
  }

  //  EVENTS 
  for (var doc in eventsSnapshot.docs) {
    final data = doc.data();

    eventMap[doc.id] = data;

    // active events 
    if (data["date"] != null) {
      final date = DateTime.tryParse(data["date"]);
      if (date != null && date.isAfter(DateTime.now())) {
        active++;
      }
    }
  }

  // POPULAR CATEGORIES 
  /*for (var user in usersSnapshot.docs) {
    final data = user.data();
    List ids = data["interestedEvents"] ?? [];

    for (var id in ids) {
      if (eventMap.containsKey(id)) {
        String category = eventMap[id]?["category"] ?? "Other";

        categoryCount[category] =
            (categoryCount[category] ?? 0) + 1;
      }
    }
  }
  // POPULAR CATEGORIES

// ================= POPULAR CATEGORIES =================

Map<String, int> tempCategoryCount = {};



// TOP 4
final sorted = tempCategoryCount.entries.toList()
  ..sort((a, b) => b.value.compareTo(a.value));

final top4 = Map<String, int>.fromEntries(sorted.take(4));*/

// ================= POPULAR CATEGORIES =================
// نخزن كل الايفنتات داخل eventMap
for (var doc in eventsSnapshot.docs) {

  final data = doc.data();

  eventMap[doc.id] = data;
}

// نمر على كل المستخدمين
for (var user in usersSnapshot.docs) {

  final data = user.data();

  // نجيب الايفنتات المحفوظة بالمفضلة
  List interested = data["interestedEvents"] ?? [];

  for (var eventId in interested) {

    // نتأكد الايفنت موجود
    if (eventMap.containsKey(eventId)) {

      // نجيب التصنيف
      String category =
          eventMap[eventId]?["category"] ?? "Other";

      // نزيد العداد
      categoryCount[category] =
          (categoryCount[category] ?? 0) + 1;
    }
  }
}

// ترتيب التصنيفات تنازليًا
final sorted = categoryCount.entries.toList()
  ..sort((a, b) => b.value.compareTo(a.value));

// أعلى 4 تصنيفات
final top4 = Map.fromEntries(sorted.take(4));


  //  ENGAGEMENT 
  double engagementValue = eventsSnapshot.docs.isEmpty
      ? 0
      : totalInterested / eventsSnapshot.docs.length;

  setState(() {
    totalUsers = usersSnapshot.docs.length;
    totalEvents = eventsSnapshot.docs.length; 
    activeEvents = active;

    categoryCount = top4;

    admins = adminsCount;
      organizers = organizersCount;
      usersOnly = usersCount;
      engagement = (engagementValue * 100).toStringAsFixed(0);

    
    
  });
  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 18),
              color: orange,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "System Analytics",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Overview of myCity Event platform",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                children: [
                  // ===== STATS =====
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: "Total Users",
                          value: totalUsers.toString(),
                          subtitle: "",
                          icon: Icons.people,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: "Total Events",
                          value: totalEvents.toString(),
                          subtitle: "",
                          icon: Icons.calendar_today,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: "Active Events",
                          value: activeEvents.toString(),
                          subtitle: "Happening now",
                          icon: Icons.show_chart,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                       Expanded(
                        child: _StatCard(
                          title: "Engagement",
                          value:  "$engagement%",
                          subtitle: "",
                          icon: Icons.trending_up,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ===== USER BREAKDOWN =====
                  _CardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "User Breakdown",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                       _ProgressRow("Regular Users",usersOnly,totalUsers == 0 ? 0 : usersOnly / totalUsers, Colors.orange,),
                       _ProgressRow("Organizers",organizers,totalUsers == 0 ? 0 : organizers / totalUsers, Colors.orange,),
                       _ProgressRow("Admins",admins,totalUsers == 0 ? 0 : admins / totalUsers, Colors.green,),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== POPULAR CATEGORIES =====
                  _CardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Popular Categories",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),

                        ...categoryCount.entries.map((e) {
                          return _CategoryRow(
                              e.key, "${e.value} events");
                        }).toList(),
                      ],
                    ),
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

// ===== UI COMPONENTS =====

class _StatCard extends StatelessWidget {
  final String title, value, subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(color: Colors.green, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final int value;
  final double progress;
  final Color color;

  const _ProgressRow(this.label, this.value, this.progress, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              color: color,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
          const SizedBox(width: 10),
          Text(value.toString()),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String name;
  final String count;

  const _CategoryRow(this.name, this.count);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(count, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSystemAnalyticsScreen extends StatefulWidget {
  const AdminSystemAnalyticsScreen({super.key});

  @override
  State<AdminSystemAnalyticsScreen> createState() =>
      _AdminSystemAnalyticsScreenState();
}

class _AdminSystemAnalyticsScreenState
    extends State<AdminSystemAnalyticsScreen> {
  static const Color orange = Color(0xFFFF6A00);

  int totalUsers = 0;
  int totalEvents = 0;
  int activeEvents = 0;

  int admins = 0;
  int organizers = 0;
  int usersOnly = 0;
  String engagement = "0";

  Map<String, int> categoryCount = {};

  @override
  void initState() {
    super.initState();
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
  final usersSnapshot =
      await FirebaseFirestore.instance.collection('users').get();

  // للإحصائيات (approved/active فقط)
  final eventsSnapshot =
      await FirebaseFirestore.instance
          .collection('events')
          .where('status', whereIn: ['approved', 'active'])
          .get();

  // ✅ لبناء eventMap نجلب كل الـ events بدون فلتر
  final allEventsSnapshot =
      await FirebaseFirestore.instance.collection('events').get();

  int active = 0;
  int adminsCount = 0;
  int organizersCount = 0;
  int usersCount = 0;
  int totalInterested = 0;

  Map<String, Map<String, dynamic>> eventMap = {};
  Map<String, int> tempCategoryCount = {};

  // USERS
  for (var user in usersSnapshot.docs) {
    final data = user.data();
    String role = data["role"] ?? "user";

    if (role == "admin") {
      adminsCount++;
    } else if (role == "organizer") {
      organizersCount++;
    } else {
      usersCount++;
    }

    List ids = data["interestedEvents"] ?? [];
    totalInterested += ids.length;
  }

  // EVENTS (للإحصائيات فقط)
  for (var doc in eventsSnapshot.docs) {
    final data = doc.data();
    if (data["date"] != null) {
      final date = DateTime.tryParse(data["date"]);
      if (date != null && date.isAfter(DateTime.now())) {
        active++;
      }
    }
  }

  // ✅ بناء eventMap من كل الـ events
  for (var doc in allEventsSnapshot.docs) {
    eventMap[doc.id] = doc.data();
  }

  // POPULAR CATEGORIES
  for (var user in usersSnapshot.docs) {
    final data = user.data();
    List interested = data["interestedEvents"] ?? [];

    for (var eventId in interested) {
      if (eventMap.containsKey(eventId)) {
        String category = eventMap[eventId]?["category"] ?? "Other";
        tempCategoryCount[category] = (tempCategoryCount[category] ?? 0) + 1;
      }
    }
  }

  final sorted = tempCategoryCount.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final top4 = Map<String, int>.fromEntries(sorted.take(4));

  double engagementValue = eventsSnapshot.docs.isEmpty
      ? 0
      : totalInterested / eventsSnapshot.docs.length;

  setState(() {
    totalUsers = usersSnapshot.docs.length;
    totalEvents = eventsSnapshot.docs.length;
    activeEvents = active;
    categoryCount = top4;
    admins = adminsCount;
    organizers = organizersCount;
    usersOnly = usersCount;
    engagement = (engagementValue * 100).toStringAsFixed(0);
  });
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
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 18),
              color: orange,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "System Analytics",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Overview of myCity Event platform",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                children: [
                  // STATS
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: "Total Users",
                          value: totalUsers.toString(),
                          subtitle: "",
                          icon: Icons.people,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: "Total Events",
                          value: totalEvents.toString(),
                          subtitle: "",
                          icon: Icons.calendar_today,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: "Active Events",
                          value: activeEvents.toString(),
                          subtitle: "Happening now",
                          icon: Icons.show_chart,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: "Engagement",
                          value: "$engagement%",
                          subtitle: "",
                          icon: Icons.trending_up,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // USER BREAKDOWN
                  _CardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "User Breakdown",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ProgressRow(
                          "Regular Users",
                          usersOnly,
                          totalUsers == 0 ? 0 : usersOnly / totalUsers,
                          Colors.orange,
                        ),
                        _ProgressRow(
                          "Organizers",
                          organizers,
                          totalUsers == 0 ? 0 : organizers / totalUsers,
                          Colors.orange,
                        ),
                        _ProgressRow(
                          "Admins",
                          admins,
                          totalUsers == 0 ? 0 : admins / totalUsers,
                          Colors.green,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // POPULAR CATEGORIES
                  _CardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Popular Categories",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),

                        categoryCount.isEmpty
                            ? const Center(
                                child: Text(
                                  "No data available",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : Column(
                                children: categoryCount.entries.map((e) {
                                  return _CategoryRow(
                                      e.key, "${e.value} events");
                                }).toList(),
                              ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== UI COMPONENTS =====

class _StatCard extends StatelessWidget {
  final String title, value, subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(color: Colors.green, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final int value;
  final double progress;
  final Color color;

  const _ProgressRow(this.label, this.value, this.progress, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              color: color,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
          const SizedBox(width: 10),
          Text(value.toString()),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String name;
  final String count;

  const _CategoryRow(this.name, this.count);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(count, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
