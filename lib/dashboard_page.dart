import 'package:flutter/material.dart';
import 'main_scaffold.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Example sales data (replace with real data later)
  final int totalItems = 50;
  final int soldItems = 34;
  final double profit = 12400.75;

  // Task-style card for dashboard items
  Widget taskCard(String title, IconData icon, Color iconColor,
      {String? value, VoidCallback? onTap}) {
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
            if (value != null) // only show if provided
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

  // Sales & Profit Statistics card
  Widget salesStatsCard({
    required int totalItems,
    required int soldItems,
    required double profit,
  }) {
    double progress = totalItems > 0 ? soldItems / totalItems : 0;
    double percentage = progress * 100;

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
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Sales Statistics",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.insights, color: Colors.white),
            ],
          ),
          const SizedBox(height: 10),

          // Sold / Total
          Text(
            "$soldItems of $totalItems items sold",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 10),

          // Progress bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            color: Colors.greenAccent,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 6),

          // Percentage
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${percentage.toStringAsFixed(1)}%",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),

          const SizedBox(height: 14),

          // Profit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Profit",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                "₱${profit.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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

                  // Sales & Profit card
                  salesStatsCard(
                    totalItems: totalItems,
                    soldItems: soldItems,
                    profit: profit,
                  ),
                  const SizedBox(height: 20),

                  // ✅ Removed values from Feedback & Address Location
                  taskCard("Feedback", Icons.feedback, Colors.orange),
                  const SizedBox(height: 12),
                  taskCard("Address Location", Icons.location_on, Colors.green),
                  const SizedBox(height: 12),
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
