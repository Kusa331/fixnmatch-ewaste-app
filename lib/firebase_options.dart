import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'YOUR_API_KEY_HERE',
        authDomain: 'YOUR_AUTH_DOMAIN_HERE',
        projectId: 'YOUR_PROJECT_ID_HERE',
        storageBucket: 'YOUR_STORAGE_BUCKET_HERE',
        messagingSenderId: 'YOUR_MESSAGING_SENDER_ID_HERE',
        appId: 'YOUR_APP_ID_HERE',
      );
    }
    // Placeholder for non-web; replace via FlutterFire CLI if needed
    return const FirebaseOptions(
      apiKey: 'MOBILE_API_KEY_PLACEHOLDER',
      appId: 'MOBILE_APP_ID_PLACEHOLDER',
      messagingSenderId: 'MOBILE_SENDER_ID_PLACEHOLDER',
      projectId: 'MOBILE_PROJECT_ID_PLACEHOLDER',
      storageBucket: 'MOBILE_STORAGE_BUCKET_PLACEHOLDER',
    );
  }
}
