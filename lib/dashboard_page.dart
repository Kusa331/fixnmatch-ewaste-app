import 'package:flutter/material.dart';
import 'main_scaffold.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Task-style card for dashboard items
  Widget taskCard(String title, IconData icon, Color iconColor, {String? value, VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.2),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value != null)
              Text(
                value,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Icon(Icons.arrow_forward_ios,
                color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
                size: 16),
          ],
        ),
      ),
    );
  }

  // Progress card
  Widget progressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F6B32), Color(0xFF68B092)], // green gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Progress Task Progress",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.close, color: Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "3/5 is completed",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.6899,
            backgroundColor: Colors.white24,
            color: Colors.green, // green for e-waste theme
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 6),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "68.99%",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 0,
      title: "Dashboard",
      body: Container(
        color: Colors.grey[200],
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Greeting
                  const Text(
                    "Hello,",
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                  const Text(
                    "John Lloyd 👋",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Progress card
                  progressCard(),
                  const SizedBox(height: 20),

                  // Task cards
                  taskCard("Total Tasks", Icons.bar_chart, Colors.orange, value: "16"),
                  const SizedBox(height: 12),
                  taskCard("Completed", Icons.check_circle, Colors.green, value: "32"),
                  const SizedBox(height: 12),
                  // New History and Help cards
                  taskCard("History", Icons.history, Colors.blue, onTap: () {
                    // TODO: Navigate to History page
                  }),
                  const SizedBox(height: 12),
                  taskCard("Help", Icons.help_outline, Colors.purple, onTap: () {
                    // TODO: Navigate to Help page
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
