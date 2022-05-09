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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCoyybx91OQcPRYTyVSeQWGpYi0cBvDcxE',
    appId: '1:724146628311:android:9409bcfae42b5ec8cf3292',
    messagingSenderId: '724146628311',
    projectId: 'taking-notes-project',
    storageBucket: 'taking-notes-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJR00jnIdluzixq7hQvX0MRsUdd4Pkt1w',
    appId: '1:724146628311:ios:92358712eb7095d8cf3292',
    messagingSenderId: '724146628311',
    projectId: 'taking-notes-project',
    storageBucket: 'taking-notes-project.appspot.com',
    iosClientId: '724146628311-ogj7mdeigo56derj3h2oov7ld37otp1c.apps.googleusercontent.com',
    iosBundleId: 'com.example.mynotes',
  );
}