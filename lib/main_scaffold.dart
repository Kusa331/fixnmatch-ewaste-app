import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  final int currentIndex;
  final String title;
  final Widget body;

  // 🔹 Define darkGreen here
  final Color darkGreen = const Color(0xFF0F6B32);

  const MainScaffold({
    super.key,
    required this.currentIndex,
    required this.title,
    required this.body,
  });

  void _onNavBarTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/repair'); // Moved Repair
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/marketplace'); // Marketplace after Repair
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/value');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: darkGreen,
        elevation: 2,
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: darkGreen,
        unselectedItemColor: Colors.grey,
        onTap: (index) => _onNavBarTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: "Repair",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: "Marketplace",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: "Value",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
