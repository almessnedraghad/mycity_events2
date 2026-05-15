/*import 'package:flutter/material.dart';

class AdminPendingApprovalsScreen extends StatefulWidget {
  const AdminPendingApprovalsScreen({super.key});

  @override
  State<AdminPendingApprovalsScreen> createState() =>
      _AdminPendingApprovalsScreenState();
}

class _AdminPendingApprovalsScreenState
    extends State<AdminPendingApprovalsScreen>
    with SingleTickerProviderStateMixin {

  static const Color orange = Color(0xFFFF6A00);
  static const Color green = Color(0xFF34C759);
  static const Color red = Color(0xFFFF3B30);

  late TabController _tabController;

  // ====================================
  final List<_OrganizerReq> _organizers = [
    _OrganizerReq("Sarah Ali", "sarah.ali@email.com", "11/10/2025"),
    _OrganizerReq("Mohammed Ahmed", "mohammed.ahmed@email.com", "11/12/2025"),
    _OrganizerReq("Saud Ibrahim", "saud.ibrahim@email.com", "11/13/2025"),
  ];

  // ==================(Events) ==================
  final List<_Event> _events = [
    _Event(
      title: "Tech Innovation Summit 2025",
      date: "11/25/2025",
      time: "09:00",
      location: "Riyadh Front",
      category: "Technology",
      image:
          "https://images.unsplash.com/photo-1508609349937-5ec4ae374ebf",
    ),
    _Event(
      title: "Winter Festival",
      date: "12/10/2025",
      time: "05:00",
      location: "Jeddah",
      category: "Festival",
      image:
          "https://images.unsplash.com/photo-1503428593586-e225b39bddfe",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
  _tabController.dispose();
  super.dispose();
}

  // ================== Actions ==================

  void _approveOrganizer(int index) {
    setState(() => _organizers.removeAt(index));
  }

  void _rejectOrganizer(int index) {
    setState(() => _organizers.removeAt(index));
  }

  void _approveEvent(int index) {
    setState(() => _events.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event Approved ✅")),
    );
  }

  void _rejectEvent(int index) {
    setState(() => _events.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event Rejected ❌")),
    );
  }

  int get totalPending => _organizers.length + _events.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      body: SafeArea(
        child: Column(
          children: [

            //  HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              color: orange,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.person_outline, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Pending Approvals",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$totalPending pending items",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            //  TABS
            Material(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: orange,
                unselectedLabelColor: Colors.grey,
                indicatorColor: orange,
                tabs: [
                  Tab(text: "Organizers (${_organizers.length})"),
                  Tab(text: "Events (${_events.length})"),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [

                  // ================== ORGANIZERS  ==================
                  ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _organizers.length,
                    itemBuilder: (context, index) {
                      final o = _organizers[index];

                      return _OrganizerCard(
                        name: o.name,
                        email: o.email,
                        requested: o.requested,
                        onApprove: () => _approveOrganizer(index),
                        onReject: () => _rejectOrganizer(index),
                      );
                    },
                  ),

                  // ================== EVENTS  ==================
                  ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final e = _events[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // صورة
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              child: Image.network(
                                e.image,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    e.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(e.category),

                                  const SizedBox(height: 6),

                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 14),
                                      const SizedBox(width: 4),
                                      Text(e.date),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.access_time, size: 14),
                                      const SizedBox(width: 4),
                                      Text(e.time),
                                    ],
                                  ),

                                  const SizedBox(height: 6),

                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 14),
                                      const SizedBox(width: 4),
                                      Text(e.location),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () => _approveEvent(index),
                                          icon: const Icon(Icons.check),
                                          label: const Text("Approve"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: green,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => _rejectEvent(index),
                                          icon: const Icon(Icons.close),
                                          label: const Text("Reject"),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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

// ================== Organizer Model ==================
class _OrganizerReq {
  final String name, email, requested;
  _OrganizerReq(this.name, this.email, this.requested);
}

// ================== Event Model ==================
class _Event {
  final String title, date, time, location, category, image;

  _Event({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
    required this.image,
  });
}

// ================== Organizer Card ==================
class _OrganizerCard extends StatelessWidget {
  final String name, email, requested;
  final VoidCallback onApprove, onReject;

  const _OrganizerCard({
    required this.name,
    required this.email,
    required this.requested,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(email),
          Text("Requested: $requested"),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF34C759),
                  ),
                  child: const Text("Approve"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text("Reject"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AdminPendingApprovalsScreen extends StatefulWidget {
  const AdminPendingApprovalsScreen({super.key});

  @override
  State<AdminPendingApprovalsScreen> createState() =>
      _AdminPendingApprovalsScreenState();
}

class _AdminPendingApprovalsScreenState
    extends State<AdminPendingApprovalsScreen>
    with SingleTickerProviderStateMixin {
  static const Color orange = Color(0xFFFF6A00);
  static const Color green = Color(0xFF34C759);
  static const Color red = Color(0xFFFF3B30);

  late TabController _tabController;

  // ================== DATA ==================
  List<_OrganizerReq> _organizers = [];
  List<_Event> _events = [];

  // Streams for real-time updates
  StreamSubscription? orgSub;
  StreamSubscription? eventSub;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    listenToOrganizers();
    listenToEvents();
  }

  // ================== FIREBASE LISTENERS ==================

  // Listen to pending organizer requests
  void listenToOrganizers() {
    orgSub = FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'organizer')
        .where('approvalStatus', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
          final data = snapshot.docs.map((doc) {
            final d = doc.data();

            return _OrganizerReq(
              id: doc.id,
              name: d["name"] ?? "",
              email: d["email"] ?? "",
              requested: d["createdAt"] == null
                  ? ""
                  : d["createdAt"].toDate().toString(),
            );
          }).toList();

          setState(() {
            _organizers = data;
          });
        });
  }

  // Listen to pending events
  void listenToEvents() {
    eventSub = FirebaseFirestore.instance
        .collection('events')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
          final data = snapshot.docs.map((doc) {
            final d = doc.data();

            return _Event(
              id: doc.id,
              title: d["title"] ?? "",
              date: d["date"] ?? "",
              time: d["time"] ?? "",
              location: d["location"] ?? "",
              category: d["category"] ?? "",
              image: d["imageUrl"] ?? "",
            );
          }).toList();

          setState(() {
            _events = data;
          });
        });
  }

  // ================== ACTIONS ==================

  // Approve organizer
  Future<void> _approveOrganizer(String id) async {
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      "approvalStatus": "approved",
    });
  }

  // Reject organizer
  Future<void> _rejectOrganizer(String id) async {
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      "approvalStatus": "rejected",
    });
  }

  // Approve event
  /*Future<void> _approveEvent(String id) async {
    await FirebaseFirestore.instance.collection('events').doc(id).update({
      "approvalStatus": "active",
    });*/
  Future<void> _approveEvent(String id) async {
    await FirebaseFirestore.instance.collection('events').doc(id).update({
      "status": "active",
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Event Approved ✅")));
  }

  // Reject event
  /*Future<void> _rejectEvent(String id) async {
    await FirebaseFirestore.instance.collection('events').doc(id).update({
      "approvalStatus": "rejected",
    });*/
  Future<void> _rejectEvent(String id) async {
    await FirebaseFirestore.instance.collection('events').doc(id).update({
      "status": "rejected",
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Event Rejected ❌")));
  }

  int get totalPending => _organizers.length + _events.length;

  @override
  void dispose() {
    // Cancel streams to prevent memory leaks
    orgSub?.cancel();
    eventSub?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  // ================== UI ==================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      body: SafeArea(
        child: Column(
          children: [
            // HEADER (no change)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              color: orange,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.person_outline, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Pending Approvals",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$totalPending pending items",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // TABS (no change)
            Material(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: orange,
                unselectedLabelColor: Colors.grey,
                indicatorColor: orange,
                tabs: [
                  Tab(text: "Organizers (${_organizers.length})"),
                  Tab(text: "Events (${_events.length})"),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // ================== ORGANIZERS ==================
                  ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _organizers.length,
                    itemBuilder: (context, index) {
                      final o = _organizers[index];

                      return _OrganizerCard(
                        name: o.name,
                        email: o.email,
                        requested: o.requested,
                        onApprove: () => _approveOrganizer(o.id),
                        onReject: () => _rejectOrganizer(o.id),
                      );
                    },
                  ),

                  // ================== EVENTS ==================
                  ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final e = _events[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.network(
                                e.image,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 150,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(e.category),

                                  const SizedBox(height: 6),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(e.date),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.access_time, size: 14),
                                      const SizedBox(width: 4),
                                      Text(e.time),
                                    ],
                                  ),

                                  const SizedBox(height: 6),

                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 14),
                                      const SizedBox(width: 4),
                                      Text(e.location),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () => _approveEvent(e.id),
                                          icon: const Icon(Icons.check),
                                          label: const Text("Approve"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: green,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => _rejectEvent(e.id),
                                          icon: const Icon(Icons.close),
                                          label: const Text("Reject"),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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

// ================== MODELS ==================

class _OrganizerReq {
  final String id, name, email, requested;

  _OrganizerReq({
    required this.id,
    required this.name,
    required this.email,
    required this.requested,
  });
}

class _Event {
  final String id;
  final String title, date, time, location, category, image;

  _Event({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
    required this.image,
  });
}

// ================== ORGANIZER CARD ==================

class _OrganizerCard extends StatelessWidget {
  final String name, email, requested;
  final VoidCallback onApprove, onReject;

  const _OrganizerCard({
    required this.name,
    required this.email,
    required this.requested,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(email),
          Text("Requested: $requested"),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF34C759),
                  ),
                  child: const Text("Approve"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text("Reject"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
