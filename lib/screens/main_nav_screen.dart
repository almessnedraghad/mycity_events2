/*import 'package:flutter/material.dart';
import 'events/interested_events_screen.dart';
import 'events/discover_events_screen.dart'; 
import 'profile/profile_screen.dart';
import 'events/notification_service.dart';

//  عداد الإشعارات (global)
int notificationCount = 0;
class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  static const Color primaryColor = Color(0xFFFF6A00);

  int selectedIndex = 0;

  final List<Map<String, dynamic>> interestedEvents = [];
  List<Map<String, dynamic>> flaggedEvents = [];

  late final List<Widget> pages = [
   /* DiscoverEventsScreen(
      interestedEvents: interestedEvents,
      flaggedEvents: flaggedEvents,
      onOpenInterests: () {},
    ),*/
    DiscoverEventsScreen(
    interestedEvents: interestedEvents,
    flaggedEvents: flaggedEvents,
    onOpenInterests: () {},
  ),
    const PlaceholderScreen(title: "Search"),
    const NotificationsScreen(),
    const PlaceholderScreen(title: "Recommended"),
    ProfileScreen(
      interestedEvents: interestedEvents,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,

        onTap: (index) {
          setState(() {
            selectedIndex = index;

            //  تصفير العداد إذا فتح النوتيفيكيشن
            if (index == 2) {
              notificationCount = 0;
            }
          });
        },

        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,

        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),

          // Notifications + Badge
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none),

                if (notificationCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        notificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: const Icon(Icons.notifications),
            label: "Notifications",
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            activeIcon: Icon(Icons.star),
            label: "Recommended",
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

//  شاشة مؤقتة
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("$title Screen")),
    );
  }
}
/** class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});
  
  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  static const Color primaryColor = Color(0xFFFF6A00);

  int selectedIndex = 0;

  final List<Map<String, dynamic>> interestedEvents = [];
  List<Map<String, dynamic>> flaggedEvents = [];// مؤقت عشان صفحة المودريشن بعدين نجيبها من الفايرستور

  late final List<Widget> pages = [
  DiscoverEventsScreen(
    interestedEvents: interestedEvents,
    flaggedEvents: flaggedEvents, //تبليغ عن الأحداث المرفوضة عشان ما تظهر في الديسكفر

    onOpenInterests: () {}, // ما نحتاجه الآن
  ),
  const PlaceholderScreen(title: "Search"),
  const PlaceholderScreen(title: "Notifications"),
  const PlaceholderScreen(title: "Recommended"),//مؤقتا بعدين نجيبها من الفايرستور
  ProfileScreen(
    interestedEvents: interestedEvents, //  نمررها للبروفايل
  ),
];

  /*late final List<Widget> pages = [
    const DiscoverEventsScreen(), 
    const PlaceholderScreen(title: "Search"),
    const PlaceholderScreen(title: "Notifications"),
    NotificationsScreen(//مؤقتا بعدين نجيبها من الفايرستور
    pushEnabled: true,
    remindersEnabled: true,),
    
    RecommendedEventsScreen(
    allEvents: allEvents,
    interestedEvents: interestedEvents,),
    const ProfileScreen(),
  ];*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),

        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,

        showUnselectedLabels: true,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            activeIcon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            activeIcon: Icon(Icons.star),
            label: "Recommended",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

//  مؤقت عشان الصفحات الي باقي بتسويها وجد
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("$title Screen")),
    );
  }
} */*/
import 'package:flutter/material.dart';
import 'events/discover_events_screen.dart';
import 'events/recommended_events_screen.dart';
import 'profile/profile_screen.dart';
import 'events/notification_service.dart';

int notificationCount = 0;

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  static const Color primaryColor = Color(0xFFFF6A00);

  int selectedIndex = 0;

  final List<Map<String, dynamic>> interestedEvents = [];
  List<Map<String, dynamic>> allEvents = [];
  List<Map<String, dynamic>> flaggedEvents = [];

  Widget _buildPage() {
    switch (selectedIndex) {
      case 0:
        return DiscoverEventsScreen(
          interestedEvents: interestedEvents,
          flaggedEvents: flaggedEvents,
          onOpenInterests: () {},
          onEventsLoaded: (events) {
            setState(() => allEvents = events);
          },
        );
      case 1:
        return const PlaceholderScreen(title: "Search");
      case 2:
        return const NotificationsScreen();
      case 3:
        return RecommendedEventsScreen(
          allEvents: allEvents,
          interestedEvents: interestedEvents,
        );
      case 4:
        return ProfileScreen(interestedEvents: interestedEvents);
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            if (index == 2) notificationCount = 0;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none),
                if (notificationCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        notificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: const Icon(Icons.notifications),
            label: "Notifications",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            activeIcon: Icon(Icons.star),
            label: "Recommended",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("$title Screen")),
    );
  }
}
