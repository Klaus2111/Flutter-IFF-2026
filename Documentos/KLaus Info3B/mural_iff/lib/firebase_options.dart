import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  // Identificadores públicos dos aplicativos registrados no Firebase.
  // Quem protege os dados são a autenticação e as regras do Firestore.
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    if (defaultTargetPlatform == TargetPlatform.android) return android;
    throw UnsupportedError('Execute o Mural IFF no Android ou no navegador.');
  }

  static const web = FirebaseOptions(
    apiKey: 'AIzaSyBmVx73DCcfuEtQh0gXjx3uj9VGm-hkcWU',
    appId: '1:804346675489:web:2528f9c5e988f6d406be60',
    messagingSenderId: '804346675489',
    projectId: 'mural-iff-63e6c',
    authDomain: 'mural-iff-63e6c.firebaseapp.com',
    storageBucket: 'mural-iff-63e6c.firebasestorage.app',
  );

  static const android = FirebaseOptions(
    apiKey: 'AIzaSyCEIJoe9gTyOuehZQSZ6LOMmnkFTF29LaI',
    appId: '1:804346675489:android:f3b7e13a65155f6606be60',
    messagingSenderId: '804346675489',
    projectId: 'mural-iff-63e6c',
    storageBucket: 'mural-iff-63e6c.firebasestorage.app',
  );
}
