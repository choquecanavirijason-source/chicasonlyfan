import 'package:flutter/foundation.dart'
    show kIsWeb, TargetPlatform, defaultTargetPlatform;
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase no está configurado para web en el proyecto chicas-a776c. '
        'Regístralo con: flutterfire configure --project=chicas-a776c '
        '--platforms=web',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'Firebase no está configurado para iOS en el proyecto chicas-a776c. '
          'Regístralo con: flutterfire configure --project=chicas-a776c '
          '--platforms=ios',
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRrX9CVj6s7sEpoU-QRRoHDOa1Ixfc71k',
    appId: '1:454143068934:android:060dcc8717ebbd20b72c87',
    messagingSenderId: '454143068934',
    projectId: 'chicas-a776c',
    storageBucket: 'chicas-a776c.firebasestorage.app',
  );
}
