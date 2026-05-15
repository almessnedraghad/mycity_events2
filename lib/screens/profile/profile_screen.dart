import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/screens/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  //  List جايه من MainNavScreen (الأحداث اللي ضغطتي عليها قلب)
  final List<Map<String, dynamic>> interestedEvents;

  const ProfileScreen({super.key, required this.interestedEvents});

  static const primaryColor = Color(0xFFFF6A00);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  bool pushNotifications = true;
  bool eventReminders = true;

  final TextEditingController nameController = TextEditingController();

  String email = "";
  String role = "";

  List<Map<String, dynamic>> firebaseInterestedEvents = [];

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadInterestedEvents();
  }

  //  Load name/role from Firestore
  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    email = user.email ?? "";

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    if (doc.exists) {
      nameController.text = (doc.data()?["name"] ?? "").toString();
      role = (doc.data()?["role"] ?? "").toString();
    }

    if (mounted) setState(() {});
  }

  Future<void> loadInterestedEvents() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    final ids = List<String>.from(userDoc.data()?["interestedEvents"] ?? []);

    final eventsSnapshot = await FirebaseFirestore.instance
        .collection("events")
        .get();

    final events = eventsSnapshot.docs.where((doc) => ids.contains(doc.id)).map(
      (doc) {
        final data = doc.data();

        return {"id": doc.id, "title": data["title"], "date": data["date"]};
      },
    ).toList();

    setState(() {
      firebaseInterestedEvents = events;
    });
  }

  // Save edited name
  Future<void> saveName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "name": nameController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            //  Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
              decoration: const BoxDecoration(
                color: ProfileScreen.primaryColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(26),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nameController.text.isEmpty
                                ? "Your Name"
                                : nameController.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            email,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (role.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.22),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                role,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //  Account Info
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Account Information",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isEditing ? Icons.check : Icons.edit,
                                  size: 18,
                                ),
                                onPressed: () async {
                                  if (isEditing) {
                                    await saveName();
                                  }
                                  setState(() => isEditing = !isEditing);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          const Text(
                            "Full Name",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),

                          TextField(
                            controller: nameController,
                            enabled: isEditing,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            "Email",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),

                          Container(
                            height: 44,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(email),
                          ),
                        ],
                      ),
                    ),

                    //  Activities = Interested Events
                    _card(
                      title: "Interested Events",
                      child: firebaseInterestedEvents.isEmpty
                          ? const Text(
                              "No interested events yet.",
                              style: TextStyle(color: Colors.black54),
                            )
                          : Column(
                              children: firebaseInterestedEvents.map((event) {
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    Icons.favorite,
                                    color: ProfileScreen.primaryColor,
                                  ),
                                  title: Text(
                                    event["title"]?.toString() ?? "Event",
                                  ),
                                  subtitle: Text(
                                    event["date"]?.toString() ?? "",
                                  ),
                                );
                              }).toList(),
                            ),
                    ),

                    //  Notifications
                    _card(
                      title: "Notification Settings",
                      child: Column(
                        children: [
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text("Push Notifications"),
                            value: pushNotifications,
                            onChanged: (v) =>
                                setState(() => pushNotifications = v),
                            activeColor: ProfileScreen.primaryColor,
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text("Event Reminders"),
                            value: eventReminders,
                            onChanged: (v) =>
                                setState(() => eventReminders = v),
                            activeColor: ProfileScreen.primaryColor,
                          ),
                        ],
                      ),
                    ),

                    // Sign Out Button
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Sign Out"),
                              content: const Text(
                                "Are you sure you want to sign out?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);

                                    await FirebaseAuth.instance.signOut();

                                    if (!mounted) return;

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LoginScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text("Yes"),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          "Sign Out",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Simple reusable card widget
  Widget _card({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
