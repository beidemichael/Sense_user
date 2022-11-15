// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyBznVCV8V9bdt-uSf-na4tt_OMHQCGRoDo',
    appId: '1:353768279389:web:f9fd3eb877f548d48eecb4',
    messagingSenderId: '353768279389',
    projectId: 'news-app-329ee',
    authDomain: 'news-app-329ee.firebaseapp.com',
    storageBucket: 'news-app-329ee.appspot.com',
    measurementId: 'G-8KHZKZMFBC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAEUp0Ng0CtSiw0lEZsyb6_HX7eS1v_9SI',
    appId: '1:353768279389:android:38c5fb333b5c8cb98eecb4',
    messagingSenderId: '353768279389',
    projectId: 'news-app-329ee',
    storageBucket: 'news-app-329ee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGH_0rl7Ks_eW4FwAsXAx7xlnB1YryGmY',
    appId: '1:353768279389:ios:162007547850413b8eecb4',
    messagingSenderId: '353768279389',
    projectId: 'news-app-329ee',
    storageBucket: 'news-app-329ee.appspot.com',
    androidClientId: '353768279389-ah7645qmh799j7qnrqfasp61vcu307ac.apps.googleusercontent.com',
    iosClientId: '353768279389-5rc5527q2702fnbijs5okrb6dltc8vtq.apps.googleusercontent.com',
    iosBundleId: 'com.example.newsUser',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBGH_0rl7Ks_eW4FwAsXAx7xlnB1YryGmY',
    appId: '1:353768279389:ios:162007547850413b8eecb4',
    messagingSenderId: '353768279389',
    projectId: 'news-app-329ee',
    storageBucket: 'news-app-329ee.appspot.com',
    androidClientId: '353768279389-ah7645qmh799j7qnrqfasp61vcu307ac.apps.googleusercontent.com',
    iosClientId: '353768279389-5rc5527q2702fnbijs5okrb6dltc8vtq.apps.googleusercontent.com',
    iosBundleId: 'com.example.newsUser',
  );
}
