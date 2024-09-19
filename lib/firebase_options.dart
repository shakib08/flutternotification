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
    apiKey: 'AIzaSyB0c6MGAIWVNY42Fr97Q-Tc9sn8Z_ddZ7w',
    appId: '1:450369066816:web:d58461f80ca71e15b00ca5',
    messagingSenderId: '450369066816',
    projectId: 'notification-c74fb',
    authDomain: 'notification-c74fb.firebaseapp.com',
    storageBucket: 'notification-c74fb.appspot.com',
    measurementId: 'G-C2FNZMQTC2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCqQGgzlRoZgi5F2Jm2m_TdnXvG5tJDLXU',
    appId: '1:450369066816:android:37a0e8f95268de22b00ca5',
    messagingSenderId: '450369066816',
    projectId: 'notification-c74fb',
    storageBucket: 'notification-c74fb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-vPltzg1bRpss9ihLN1OaIMaIOLNhyA8',
    appId: '1:450369066816:ios:327c0e71d0825333b00ca5',
    messagingSenderId: '450369066816',
    projectId: 'notification-c74fb',
    storageBucket: 'notification-c74fb.appspot.com',
    iosBundleId: 'com.example.notification',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC-vPltzg1bRpss9ihLN1OaIMaIOLNhyA8',
    appId: '1:450369066816:ios:327c0e71d0825333b00ca5',
    messagingSenderId: '450369066816',
    projectId: 'notification-c74fb',
    storageBucket: 'notification-c74fb.appspot.com',
    iosBundleId: 'com.example.notification',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB0c6MGAIWVNY42Fr97Q-Tc9sn8Z_ddZ7w',
    appId: '1:450369066816:web:bc36db8547736cf6b00ca5',
    messagingSenderId: '450369066816',
    projectId: 'notification-c74fb',
    authDomain: 'notification-c74fb.firebaseapp.com',
    storageBucket: 'notification-c74fb.appspot.com',
    measurementId: 'G-PL516ZT1KV',
  );
}
