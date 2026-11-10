import 'dart:io';
import 'package:flutter/foundation.dart'
    show kIsWeb, TargetPlatform, defaultTargetPlatform;
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAH6j2xPSF-U7oyU0j6nfvxIMOR2hZr994',
    appId: '1:118765182842:web:PLACEHOLDER',
    messagingSenderId: '118765182842',
    projectId: 'chicasapp',
    authDomain: 'chicasapp.firebaseapp.com',
    storageBucket: 'chicasapp.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAH6j2xPSF-U7oyU0j6nfvxIMOR2hZr994',
    appId: '1:118765182842:android:8e3f246dac25af639780c3',
    messagingSenderId: '118765182842',
    projectId: 'chicasapp',
    storageBucket: 'chicasapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAH6j2xPSF-U7oyU0j6nfvxIMOR2hZr994',
    appId: '1:118765182842:ios:PLACEHOLDER',
    messagingSenderId: '118765182842',
    projectId: 'chicasapp',
    storageBucket: 'chicasapp.firebasestorage.app',
    iosBundleId: 'com.chicasonlyfans.app',
  );
}
