// firebase_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

class FirebaseService {
  static void logConfigDiagnostics() {
    try {
      final opts = DefaultFirebaseOptions.currentPlatform;
      debugPrint(
        'Firebase diagnostics -> apps=${Firebase.apps.length}, '
        'apiKey=${opts.apiKey}, authDomain=${opts.authDomain}, '
        'projectId=${opts.projectId}, storageBucket=${opts.storageBucket}, '
        'messagingSenderId=${opts.messagingSenderId}, appId=${opts.appId}',
      );
      final values = [
        opts.apiKey,
        opts.authDomain ?? '',
        opts.projectId,
        opts.storageBucket ?? '',
        opts.messagingSenderId ?? '',
        opts.appId,
      ];
      final looksPlaceholder = values.any(
        (v) => v.contains('YOUR_') || v.contains('PLACEHOLDER'),
      );
      if (looksPlaceholder) {
        debugPrint(
          'WARNING: FirebaseOptions contains placeholder values. '
          'Update lib/firebase_options.dart with your real Web SDK config.',
        );
      }
    } catch (e) {
      debugPrint('Firebase diagnostics error: $e');
    }
  }

  static Future<void> initializeFirebase() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;

  static Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      final auth = FirebaseAuth.instance;
      try {
        // Preferred: popup-based sign-in on web
        return await auth.signInWithPopup(GoogleAuthProvider());
      } on FirebaseAuthException catch (e) {
        debugPrint('Google Sign-In web error: ${e.code} - ${e.message}');
        // Extra diagnostics for API key errors
        final msg = e.message ?? '';
        if (e.code.contains('api-key-not-valid') ||
            msg.contains('api-key-not-valid')) {
          logConfigDiagnostics();
        }
        // Fallback if popup is blocked by policy
        if (e.code == 'popup-blocked') {
          try {
            await auth.signInWithRedirect(GoogleAuthProvider());
            // After redirect, caller may use getRedirectResult() on app load.
            return null;
          } on FirebaseAuthException catch (e2) {
            debugPrint(
              'Google Sign-In redirect error: ${e2.code} - ${e2.message}',
            );
            rethrow;
          } catch (e2) {
            debugPrint('Google Sign-In redirect unknown error: $e2');
            rethrow;
          }
        }
        // Surface the error up to the caller
        rethrow;
      } catch (e) {
        debugPrint('Google Sign-In web unknown error: $e');
        rethrow;
      }
    } else {
      try {
        // Mobile/Desktop flow via google_sign_in plugin
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        debugPrint('Google Sign-In mobile error: ${e.code} - ${e.message}');
        rethrow;
      } catch (e) {
        debugPrint('Google Sign-In mobile unknown error: $e');
        rethrow;
      }
    }
  }
}
