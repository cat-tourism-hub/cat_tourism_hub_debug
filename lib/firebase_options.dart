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
    apiKey: 'AIzaSyCsNbjkt1WVCBy2p86w0gSDmMjyckMSr28',
    appId: '1:70758533530:web:be9b0e8b03602015c05223',
    messagingSenderId: '70758533530',
    projectId: 'tourism-hub',
    authDomain: 'tourism-hub.firebaseapp.com',
    storageBucket: 'tourism-hub.appspot.com',
    measurementId: 'G-D4R4Y6DCXW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAF-nm-KwqOY_EmB8Qlvzmyw6RQ3Cbwnfc',
    appId: '1:70758533530:android:24f765d43cb78c3fc05223',
    messagingSenderId: '70758533530',
    projectId: 'tourism-hub',
    storageBucket: 'tourism-hub.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBoNR9NwcDkwjv3X9qxpnoXz-Q3gDP8V-k',
    appId: '1:70758533530:ios:291627c2d516d000c05223',
    messagingSenderId: '70758533530',
    projectId: 'tourism-hub',
    storageBucket: 'tourism-hub.appspot.com',
    iosBundleId: 'com.example.catTourismHub',
  );
}