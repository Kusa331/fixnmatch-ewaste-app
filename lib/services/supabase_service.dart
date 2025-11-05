// supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;
  static GoTrueClient get auth => Supabase.instance.client.auth;

  static Future<void> initializeSupabase() async {
    // Initialize Supabase with your project URL and anon key
    // Replace these with your actual Supabase project credentials
    await Supabase.initialize(
      url: 'https://cmiouxuqqvbeuorhuerw.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNtaW91eHVxcXZiZXVvcmh1ZXJ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIzNDY2ODEsImV4cCI6MjA3NzkyMjY4MX0.OFcb_QIrCR1gsZTr9cjiKgbS0tjQg7Tzrl7eXXeIabo',
      debug: kDebugMode,
    );
  }

  static Future<AuthResponse?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web: use Supabase OAuth (redirects, returns bool)
        await auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: Uri.base.toString(),
        );
        // On web, OAuth redirects, so we return null
        // The user will be redirected back after authentication
        return null;
      } else {
        // Mobile: use Google Sign-In plugin then Supabase
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          // User cancelled sign-in
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        if (googleAuth.idToken == null) {
          throw Exception('Failed to get Google ID token');
        }

        // Sign in to Supabase with Google token
        final response = await auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: googleAuth.idToken!,
          accessToken: googleAuth.accessToken,
        );

        return response;
      }
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      rethrow;
    }
  }

  static User? get currentUser => auth.currentUser;

  static bool get isAuthenticated => auth.currentUser != null;

  static Future<void> signOut() async {
    await auth.signOut();
    if (!kIsWeb) {
      // Also sign out from Google Sign-In on mobile
      await GoogleSignIn().signOut();
    }
  }
}
