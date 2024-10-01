// Import the necessary Firebase packages.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web; // Add web config here if you plan to support web.
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

  // Configuration for Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDCs0FxdfdVKGdiEaAbiWN26AHB7P9JiIg',
    appId: '1:1062347283966:android:d97a95369b3a3d697634af',
    messagingSenderId: '1062347283966',
    projectId: 'money-tracker-back-up',
    storageBucket: 'money-tracker-back-up.appspot.com',
  );

  // Configuration for iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDVymBpNpgAiZdue-thW3efky-wNwE1vLM',
    appId: '1:1062347283966:ios:8a35c8868dbfcead7634af',
    messagingSenderId: '1062347283966',
    projectId: 'money-tracker-back-up',
    storageBucket: 'money-tracker-back-up.appspot.com',
    iosClientId: '1062347283966-50qqfnjt34eu4h366hmlaqcr1g3ti8f3.apps.googleusercontent.com',
    iosBundleId: 'com.example.backUp',
  );

  // Add web configuration if needed
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCYYcx3ZVh3zGXgn0O9zy7S3aGzB-41WFo',
    appId: '1:1062347283966:web:5674abeef3a022b37634af',
    messagingSenderId: '1062347283966',
    projectId: 'money-tracker-back-up',
    storageBucket: 'money-tracker-back-up.appspot.com',
  );
}