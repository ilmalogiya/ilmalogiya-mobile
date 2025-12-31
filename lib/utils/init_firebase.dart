import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> initFirebase() async {
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  await FirebaseMessaging.instance.subscribeToTopic('news');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
}
