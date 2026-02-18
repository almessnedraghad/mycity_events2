import 'package:flutter/material.dart';
import 'complete_profile_screen.dart';

class ChooseRoleScreen extends StatelessWidget {
  final String email;
  static const primaryColor = Color(0xFFFF6A00);

  const ChooseRoleScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    Widget roleCard({
      required IconData icon,
      required String title,
      required String desc,
      String? footnote,
      required VoidCallback onTap,
    }) {
      return InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFFD2AE)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    if (footnote != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        footnote,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text("Back", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        height: 34,
                        width: 34,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset("assets/logo.png", fit: BoxFit.contain),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "myCity Event",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // White Card
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(26)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "I am a...",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Choose your account type",
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 18),

                    roleCard(
                      icon: Icons.person,
                      title: "User",
                      desc:
                          "Browse events, add to your interest list, and discover what's happening in your city",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CompleteProfileScreen(
                              email: email,
                              role: "user",
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    roleCard(
                      icon: Icons.event,
                      title: "Organizer",
                      desc:
                          "Create and manage events, reach your audience, and grow your community",
                      footnote: "⚠ Requires admin approval",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CompleteProfileScreen(
                              email: email,
                              role: "organizer",
                            ),
                          ),
                        );
                      },
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
}
