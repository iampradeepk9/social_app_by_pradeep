
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDvhua8saPw1WH4VAdePLF7AoR7RwhhZmA',
    appId: '1:167400934834:web:e3046e038154729c1e68ab',
    messagingSenderId: '167400934834',
    projectId: 'instagram-7555e',
    authDomain: 'instagram-7555e.firebaseapp.com',
    storageBucket: 'instagram-7555e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC01Z6y2-6nrBl7HXyxFbqH2_292jEyo4g',
    appId: '1:167400934834:android:9f1c6eb6431a5d481e68ab',
    messagingSenderId: '167400934834',
    projectId: 'instagram-7555e',
    storageBucket: 'instagram-7555e.appspot.com',
  );
}
