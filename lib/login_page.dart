import 'package:fixnmatch/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_page.dart'; // Import your dashboard page
import 'providers/app_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final TextEditingController emailController = TextEditingController();
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
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
                  decoration: InputDecoration(
                    labelText: isLoginMode ? "Email" : "Name",
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Email Field (shown only in Register mode)
                if (!isLoginMode) ...[
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Password Field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ), // Space before login/register button
                // Login/Register Button
                Consumer<AppProvider>(
                  builder: (context, appProvider, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: appProvider.isLoading
                            ? null
                            : () async {
                                // Validate inputs
                                if (isLoginMode) {
                                  if (usernameController.text.isEmpty ||
                                      passwordController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please enter your email and password',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                } else {
                                  if (usernameController.text.isEmpty ||
                                      emailController.text.isEmpty ||
                                      passwordController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please fill name, email, and password',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  // Basic email format check
                                  final email = emailController.text.trim();
                                  final emailValid = RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+',
                                  ).hasMatch(email);
                                  if (!emailValid) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please enter a valid email address',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                }

                                bool success;
                                if (isLoginMode) {
                                  success = await appProvider.signIn(
                                    usernameController.text,
                                    passwordController.text,
                                  );
                                } else {
                                  success = await appProvider.signUp(
                                    usernameController.text,
                                    emailController.text,
                                    passwordController.text,
                                  );
                                }

                                if (success && mounted) {
                                  // Navigate to dashboard on successful login
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardPage(),
                                    ),
                                  );
                                } else if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isLoginMode
                                            ? 'Login failed. Please check your credentials.'
                                            : 'Registration failed. Please try again.',
                                      ),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: appProvider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                isLoginMode ? 'Login' : 'Register',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
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
                const SizedBox(height: 20),

                // Google Sign-In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Image.asset(
                      "assets/signin-assets/signin-assets/Web (mobile + desktop)/png@1x/light/web_light_sq_SI@1x.png",
                      height: 24,
                      width: 24,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.account_circle,
                        size: 24,
                        color: Colors.black54,
                      ),
                    ),
                    label: const Text(
                      "Sign in with Google",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                    ),
                    onPressed: () async {
                      try {
                        final response =
                            await SupabaseService.signInWithGoogle();
                        if (response != null &&
                            response.user != null &&
                            mounted) {
                          // Get user profile after Google sign-in
                          final appProvider = Provider.of<AppProvider>(
                            context,
                            listen: false,
                          );
                          await appProvider.setUserFromGoogleSignIn(
                            response.user!.id,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardPage(),
                            ),
                          );
                        }
                      } on AuthException catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.message)));
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Google Sign-In failed: ${e.toString()}',
                            ),
                          ),
                        );
                      }
                    },
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
