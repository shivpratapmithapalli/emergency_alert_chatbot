// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDezdrdTOS_arqcTPHnOk-WAktnun2vbZw',
    appId: '1:798237308400:web:2b6f5ca8033186a3a81935',
    messagingSenderId: '798237308400',
    projectId: 'emergency-alert-cfa28',
    authDomain: 'emergency-alert-cfa28.firebaseapp.com',
    storageBucket: 'emergency-alert-cfa28.firebasestorage.app',
    measurementId: 'G-YW350HWYQV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJz2ZbL3AoaDBz9-YuKq5p9QSxH7TKwJs',
    appId: '1:798237308400:android:4f7d56765e5d1e72a81935',
    messagingSenderId: '798237308400',
    projectId: 'emergency-alert-cfa28',
    storageBucket: 'emergency-alert-cfa28.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCno2zo46t4hl7UR5X_MXUUy3ZcCigSV3Q',
    appId: '1:798237308400:ios:2d8a9240f02f31d3a81935',
    messagingSenderId: '798237308400',
    projectId: 'emergency-alert-cfa28',
    storageBucket: 'emergency-alert-cfa28.firebasestorage.app',
    iosBundleId: 'com.example.emergencyAlertApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCno2zo46t4hl7UR5X_MXUUy3ZcCigSV3Q',
    appId: '1:798237308400:ios:2d8a9240f02f31d3a81935',
    messagingSenderId: '798237308400',
    projectId: 'emergency-alert-cfa28',
    storageBucket: 'emergency-alert-cfa28.firebasestorage.app',
    iosBundleId: 'com.example.emergencyAlertApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDezdrdTOS_arqcTPHnOk-WAktnun2vbZw',
    appId: '1:798237308400:web:aeb7dcdf04e004e8a81935',
    messagingSenderId: '798237308400',
    projectId: 'emergency-alert-cfa28',
    authDomain: 'emergency-alert-cfa28.firebaseapp.com',
    storageBucket: 'emergency-alert-cfa28.firebasestorage.app',
    measurementId: 'G-M9C0921QYR',
  );
}
