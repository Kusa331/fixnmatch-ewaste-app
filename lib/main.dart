import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dashboard_page.dart';
import 'marketplace_page.dart';
import 'repair_page.dart';
import 'value_page.dart';
import 'profile_page.dart'; // ✅ Import the profile page

void main() {
  runApp(const FixMatchApp());
}

class FixMatchApp extends StatelessWidget {
  const FixMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FixMatch",

      // 🔹 Material 3 Theme for modern look
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F6B32), // dark green as seed
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),

      // 🔹 Start at LoginPage
      initialRoute: '/login',

      // 🔹 Define routes
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/marketplace': (context) => const MarketplacePage(),
        '/repair': (context) => const RepairPage(),
        '/value': (context) => const ValuePage(),
        '/profile': (context) => const ProfilePage(), // ✅ Added Profile route
      },
    );
  }
}
