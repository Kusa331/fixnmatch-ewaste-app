import 'package:flutter/material.dart';
import 'dashboard_page.dart'; // Import your dashboard page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color darkGreen = const Color(0xFF0F6B32);
  final Color lightGreen = const Color(0xFF68B092);

  bool showCrud = false; // controls whether to show login/register
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoginMode = true; // toggle between login and register

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: showCrud ? _buildCrudCard() : _buildGetStarted(),
          ),
        ),
      ),
    );
  }

  /// =====================
  /// GET STARTED SCREEN
  /// =====================
  Widget _buildGetStarted() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            // 🔹 Adjust this SizedBox to move the logo lower
            const SizedBox(height: 20), // Logo pushed lower
            Image.asset(
              "assets/logo.png", // Your Canva logo here
              height: 100,
            ),
            const SizedBox(height: 1), // Space between logo and title
            const Text(
              "Fix & Match",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12), // Space between title and subtitle
            const Text(
              "CTRL + CREW",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),

        // Get Started Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.arrow_forward),
            label: const Text(
              "Get Started",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: darkGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
            ),
            onPressed: () {
              setState(() {
                showCrud = true;
              });
            },
          ),
        ),
        const SizedBox(height: 20),

        // Tagline
        Text(
          "Manage your e-waste efficiently and responsibly",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  /// =====================
  /// LOGIN / REGISTER CARD
  /// =====================
  Widget _buildCrudCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Adjust this SizedBox to move the logo lower inside card
                const SizedBox(height: 20), // Logo slightly lower in card
                Image.asset(
                  "assets/logo.png", // Your Canva logo here
                  height: 80,
                ),
                const SizedBox(height: 1), // Space between logo and title
                const Text(
                  "Fix & Match",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8), // Space between title and subtitle
                const Text(
                  "CTRL + CREW",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24), // Space before input fields

                // Username Field
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24), // Space before login/register button

                // Login/Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isLoginMode) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Registration Successful!")),
                        );
                        setState(() {
                          isLoginMode = true;
                        });
                      }

                      usernameController.clear();
                      passwordController.clear();
                    },
                    child: Text(isLoginMode ? "Login" : "Register"),
                  ),
                ),
                const SizedBox(height: 12),

                // Toggle Button
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLoginMode = !isLoginMode;
                    });
                  },
                  child: Text(
                    isLoginMode
                        ? "Don't have an account? Register"
                        : "Already have an account? Login",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
