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
    apiKey: 'AIzaSyCf6MxTAJGTCSZkjXh5fF4YAAMUy8vrewM',
    appId: '1:492461681656:web:f669b9b7f215fa6bcb040d',
    messagingSenderId: '492461681656',
    projectId: 'ditonton-96851',
    authDomain: 'ditonton-96851.firebaseapp.com',
    storageBucket: 'ditonton-96851.firebasestorage.app',
    measurementId: 'G-Q16TH71VSS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBYKFjPdxUM7AfgqkZz52VdMi2yOgG1Dug',
    appId: '1:492461681656:android:b050793cffad6bd8cb040d',
    messagingSenderId: '492461681656',
    projectId: 'ditonton-96851',
    storageBucket: 'ditonton-96851.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAmIManK299sb_fVLu3mubQpq4TxWiK06M',
    appId: '1:492461681656:ios:6ba149db3eb05643cb040d',
    messagingSenderId: '492461681656',
    projectId: 'ditonton-96851',
    storageBucket: 'ditonton-96851.firebasestorage.app',
    iosBundleId: 'com.dicoding.ditonton',
  );
}
