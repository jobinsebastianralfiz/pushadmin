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
    apiKey: 'add yours',
    appId: 'add yours',
    messagingSenderId: '993531762259',
    projectId: 'pushnotify-db0c9',
    authDomain: 'pushnotify-db0c9.firebaseapp.com',
    storageBucket: 'pushnotify-db0c9.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCneClEfU3UaIB1tcnid1fEqFml4Hjkwx0',
    appId: '1:993531762259:android:7d69f87ed1b03c307058a6',
    messagingSenderId: '993531762259',
    projectId: 'pushnotify-db0c9',
    storageBucket: 'pushnotify-db0c9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjNP_xqLZPYLVNIzHysn2P3TXv6yRhWsg',
    appId: '1:993531762259:ios:db5060f7630fce4e7058a6',
    messagingSenderId: '993531762259',
    projectId: 'pushnotify-db0c9',
    storageBucket: 'pushnotify-db0c9.appspot.com',
    iosBundleId: 'com.ralfiz.pushadmin',
  );
}
