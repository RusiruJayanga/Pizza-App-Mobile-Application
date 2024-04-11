import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDxLXRO3GyOdZARuWYHyrNfNdCoE7q3q04',
    appId: '1:243676744853:web:f5e4584a486539a791df9c',
    messagingSenderId: '243676744853',
    projectId: 'pizza-delivery-a9af3',
    authDomain: 'pizza-delivery-a9af3.firebaseapp.com',
    storageBucket: 'pizza-delivery-a9af3.appspot.com',
    measurementId: 'G-450Q6H24JG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCC5RjKvJCOBZo_gT37CPkuZgyDQxjR2Pk',
    appId: '1:243676744853:android:6512209a1f5bf8e791df9c',
    messagingSenderId: '243676744853',
    projectId: 'pizza-delivery-a9af3',
    storageBucket: 'pizza-delivery-a9af3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTdZE-MB5jmeVVHG0VPMJf77MIwuOZlBE',
    appId: '1:243676744853:ios:fd62d19ebbb64dcd91df9c',
    messagingSenderId: '243676744853',
    projectId: 'pizza-delivery-a9af3',
    storageBucket: 'pizza-delivery-a9af3.appspot.com',
    iosBundleId: 'com.example.pizzaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCTdZE-MB5jmeVVHG0VPMJf77MIwuOZlBE',
    appId: '1:243676744853:ios:b07d3c509899fe7c91df9c',
    messagingSenderId: '243676744853',
    projectId: 'pizza-delivery-a9af3',
    storageBucket: 'pizza-delivery-a9af3.appspot.com',
    iosBundleId: 'com.example.pizzaApp.RunnerTests',
  );
}
