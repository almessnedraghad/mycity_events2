import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/screens/auth/login_screen.dart';
class OrganizerProfileScreen extends StatefulWidget {
  const OrganizerProfileScreen({super.key});

  @override
  State<OrganizerProfileScreen> createState() => _OrganizerProfileScreenState();
}

class _OrganizerProfileScreenState extends State<OrganizerProfileScreen> {
  static const Color primaryColor = Color(0xFFFF6A00);
  static const Color backgroundColor = Color(0xFFF5F5F5);

  bool pushNotifications = true;
  bool eventReminders = true;

  bool isLoading = true;

  String displayName = "Organizer";
  String email = "";
  String role = "organizer";

  //  edit name
  bool isEditingName = false;
  bool isSavingName = false;
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    nameController.dispose();
    nameFocus.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isLoading = false;
        displayName = "Not signed in";
      });
      return;
    }

    email = user.email ?? "";

    final doc =
        await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
    final data = doc.data();

    final loadedName =
        (data?["fullName"] ?? data?["name"] ?? "Organizer").toString();

    setState(() {
      displayName = loadedName;
      nameController.text = loadedName; //  fill controller
      role = (data?["role"] ?? "organizer").toString();
      isLoading = false;
    });
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _toggleEditOrSaveName() async {
    // Start editing
    if (!isEditingName) {
      setState(() => isEditingName = true);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        nameFocus.requestFocus();
        nameController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: nameController.text.length,
        );
      });
      return;
    }

    // Save
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final newName = nameController.text.trim();
    if (newName.isEmpty) {
      _snack("Name can't be empty");
      return;
    }

    setState(() => isSavingName = true);

    try {
      await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        "name": newName,
        "fullName": newName, // عشان توافق طريقتك في القراءة
      });

      setState(() {
        displayName = newName;
        isEditingName = false;
      });

      _snack("Name updated ✅");
    } catch (e) {
      _snack("Error: $e");
    } finally {
      if (mounted) setState(() => isSavingName = false);
    }
  }

  void _cancelEdit() {
    setState(() {
      isEditingName = false;
      nameController.text = displayName; // يرجع الاسم القديم
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.22),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                role,
                                style: const TextStyle(
                                  color: Colors.white,
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
                const SizedBox(height: 16),

                _card(
                  title: "Account Information",
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isEditingName)
                        IconButton(
                          tooltip: "Cancel",
                          icon: const Icon(Icons.close, color: Colors.black54),
                          onPressed: isSavingName ? null : _cancelEdit,
                        ),
                      IconButton(
                        tooltip: isEditingName ? "Save" : "Edit",
                        icon: Icon(
                          isEditingName ? Icons.check : Icons.edit,
                          color: Colors.black54,
                        ),
                        onPressed: isSavingName ? null : _toggleEditOrSaveName,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Full Name",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),

                      //  editable field instead of _disabled
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: nameController,
                          focusNode: nameFocus,
                          enabled: isEditingName && !isSavingName,
                          readOnly: !isEditingName,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your name",
                            suffixIcon: isSavingName
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),
                      const Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      _disabled(email),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                _card(
                  title: "Notification Settings",
                  leading: const Icon(
                    Icons.notifications_none,
                    color: primaryColor,
                  ),
                  child: Column(
                    children: [
                      _toggle(
                        "Push Notifications",
                        "Receive notifications about new events",
                        pushNotifications,
                        (v) => setState(() => pushNotifications = v),
                      ),
                      const Divider(height: 22),
                      _toggle(
                        "Event Reminders",
                        "Get reminded before events start",
                        eventReminders,
                        (v) => setState(() => eventReminders = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                OutlinedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    //نحذفه اذا ضبط  تسجيل الخروج
                    /* Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);*/
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                          (route) => false,
                        );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    minimumSize: const Size(double.infinity, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text("Sign Out"),
                ),
              ],
            ),
    );
  }

  Widget _card({
    required String title,
    Widget? leading,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (leading != null) ...[leading, const SizedBox(width: 8)],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _disabled(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(color: Colors.black54)),
    );
  }

  Widget _toggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}