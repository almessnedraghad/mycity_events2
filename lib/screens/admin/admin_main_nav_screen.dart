/*import 'package:flutter/material.dart';
import 'admin_system_analytics_screen.dart';
import 'admin_pending_approvals_screen.dart';
import 'admin_event_moderation_screen.dart';
import 'admin_profile_screen.dart';


class AdminMainNavScreen extends StatefulWidget {
final List<Map<String, dynamic>> flaggedEvents;// مؤقت عشان صفحة المودريشن بعدين نجيبها من الفايرستور

const AdminMainNavScreen({
  super.key,
  required this.flaggedEvents,
  });


@override
State<AdminMainNavScreen> createState() => _AdminMainNavScreenState();
}

class _AdminMainNavScreenState extends State<AdminMainNavScreen> {
static const Color primaryColor = Color(0xFFFF6A00);

int selectedIndex = 0;

late final List<Widget> pages = [
const AdminSystemAnalyticsScreen(),
const AdminPendingApprovalsScreen(),
      AdminEventModerationScreen(flaggedEvents: widget.flaggedEvents,),// مؤقت عشان صفحة المودريشن بعدين نجيبها من الفايرستور 
const AdminProfileScreen(),
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
      });
    },

    type: BottomNavigationBarType.fixed,
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey,

    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: "Analytics",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_add_alt_1_outlined),
        activeIcon: Icon(Icons.person_add_alt_1),
        label: "Approvals",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shield_outlined),
        activeIcon: Icon(Icons.shield),
        label: "Events",
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
}*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_system_analytics_screen.dart';
import 'admin_pending_approvals_screen.dart';
import 'admin_event_moderation_screen.dart';
import 'admin_profile_screen.dart';

class AdminMainNavScreen extends StatefulWidget {
  const AdminMainNavScreen({super.key});

  @override
  State<AdminMainNavScreen> createState() => _AdminMainNavScreenState();
}

class _AdminMainNavScreenState extends State<AdminMainNavScreen> {
  static const Color primaryColor = Color(0xFFFF6A00);

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Analytics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1_outlined),
            activeIcon: Icon(Icons.person_add_alt_1),
            label: "Approvals",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            activeIcon: Icon(Icons.shield),
            label: "Events",
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

  //switch case to return the right page based on the selected index
  Widget _buildPage() {
    switch (selectedIndex) {
      case 0:
        return const AdminSystemAnalyticsScreen();

      case 1:
        return const AdminPendingApprovalsScreen();

      case 2:
            return const AdminEventModerationScreen();
          
      case 3:
        return const AdminProfileScreen();

      default:
        return const SizedBox();
    }
  }
}
