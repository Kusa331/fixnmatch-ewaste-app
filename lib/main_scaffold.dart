import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  final int currentIndex;
  final String title;
  final Widget body;

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
        Navigator.pushReplacementNamed(context, '/repair');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/marketplace');
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
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: darkGreen,
        elevation: 3,
      ),
      body: body,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: const Offset(0, -2),
              blurRadius: 6,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade600,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: (index) => _onNavBarTap(context, index),
          items: [
            _customNavItem(Icons.dashboard_rounded, "Dashboard", 0),
            _customNavItem(Icons.build_circle_rounded, "Repair", 1),
            _customNavItem(Icons.storefront_rounded, "Marketplace", 2),
            _customNavItem(Icons.monetization_on_rounded, "Value", 3),
            _customNavItem(Icons.person_rounded, "Profile", 4),
          ],
        ),
      ),
    );
  }

  /// Custom Navigation Item to make selected icon bold and inside a darkGreen pill
  BottomNavigationBarItem _customNavItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: currentIndex == index ? darkGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          size: 26,
          color: currentIndex == index ? Colors.white : Colors.grey.shade600,
        ),
      ),
      label: label,
    );
  }
}
