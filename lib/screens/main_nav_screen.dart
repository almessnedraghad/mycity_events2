import 'package:flutter/material.dart';
import 'events/interested_events_screen.dart';
import 'events/discover_events_screen.dart'; 
import 'profile/profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  static const Color primaryColor = Color(0xFFFF6A00);

  int selectedIndex = 0;

  final List<Map<String, dynamic>> interestedEvents = [];
  
  late final List<Widget> pages = [
  DiscoverEventsScreen(
    interestedEvents: interestedEvents,
    onOpenInterests: () {}, // ما نحتاجه الآن
  ),
  const PlaceholderScreen(title: "Search"),
  const PlaceholderScreen(title: "Notifications"),
  ProfileScreen(
    interestedEvents: interestedEvents, // 👈 نمررها للبروفايل
  ),
];

  
  /*late final List<Widget> pages = [
    const DiscoverEventsScreen(), 
    const PlaceholderScreen(title: "Search"),
    const PlaceholderScreen(title: "Notifications"),
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
}