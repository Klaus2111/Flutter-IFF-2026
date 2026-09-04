import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;

      case TargetPlatform.linux:
        return linux;

      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAtsHDPe8Z7h1aKAli3nMGVF0WFb7Mgyks",
    authDomain: "pdm-2026-75382.firebaseapp.com",
    projectId: "pdm-2026-75382",
    storageBucket: "pdm-2026-75382.firebasestorage.app",
    messagingSenderId: "886342977195",
    appId: "1:886342977195:web:05c4b2209d5a44f23719ee",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAtsHDPe8Z7h1aKAli3nMGVF0WFb7Mgyks",
    authDomain: "pdm-2026-75382.firebaseapp.com",
    projectId: "pdm-2026-75382",
    storageBucket: "pdm-2026-75382.firebasestorage.app",
    messagingSenderId: "886342977195",
    appId: "1:886342977195:web:05c4b2209d5a44f23719ee",
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: "AIzaSyAtsHDPe8Z7h1aKAli3nMGVF0WFb7Mgyks",
    authDomain: "pdm-2026-75382.firebaseapp.com",
    projectId: "pdm-2026-75382",
    storageBucket: "pdm-2026-75382.firebasestorage.app",
    messagingSenderId: "886342977195",
    appId: "1:886342977195:web:05c4b2209d5a44f23719ee",
  );
}
