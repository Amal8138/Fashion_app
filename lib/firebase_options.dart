// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
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
    apiKey: 'AIzaSyCDId5e9s6TR_tSuF1tlTxuat5oNLuRrRg',
    appId: '1:316000904141:web:f331975be848329cf2da84',
    messagingSenderId: '316000904141',
    projectId: 'fashionapp-3b98a',
    authDomain: 'fashionapp-3b98a.firebaseapp.com',
    storageBucket: 'fashionapp-3b98a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBX5NO8tyo3d3jrgRynw9ceXlqtna0m_TQ',
    appId: '1:316000904141:android:f9d79d360cb5245bf2da84',
    messagingSenderId: '316000904141',
    projectId: 'fashionapp-3b98a',
    storageBucket: 'fashionapp-3b98a.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCDId5e9s6TR_tSuF1tlTxuat5oNLuRrRg',
    appId: '1:316000904141:web:9f14fe77fc8cb460f2da84',
    messagingSenderId: '316000904141',
    projectId: 'fashionapp-3b98a',
    authDomain: 'fashionapp-3b98a.firebaseapp.com',
    storageBucket: 'fashionapp-3b98a.appspot.com',
  );
}
