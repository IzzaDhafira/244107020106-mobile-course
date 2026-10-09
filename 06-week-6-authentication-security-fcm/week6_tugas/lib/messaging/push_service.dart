import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

final FlutterLocalNotificationsPlugin localNotif = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  debugPrint("Background message: ${message.messageId}");
}

class PushService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init(void Function(String) onNavigate) async {
    debugPrint(">>> Inisialisasi PushService dimulai...");
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
    
    await localNotif.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (res) {
        if (res.payload != null) onNavigate(res.payload!);
      },
    );

    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint("Status Izin FCM: ${settings.authorizationStatus}");

    _fcm.getToken().then((t) {
      debugPrint("====================================");
      debugPrint("TOKEN FCM PERANGKAT:");
      debugPrint(t);
      debugPrint("====================================");
    }).catchError((err) {
      debugPrint("Error mengambil token FCM: $err");
    });

    _fcm.onTokenRefresh.listen((newToken) {
      debugPrint("TOKEN FCM DIPERBARUI (Refresh): $newToken");
    });

    await _fcm.subscribeToTopic('pengumuman-kampus');
    debugPrint("Berhasil subscribe ke topik: pengumuman-kampus");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Pesan FCM masuk (Foreground): ${message.notification?.title}");
      final route = message.data['route'] ?? '/';
      
      localNotif.show(
        id: message.hashCode,
        title: message.notification?.title,
        body: message.notification?.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'campus_channel_id',
            'Campus Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: route,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notifikasi diklik dari background state");
      final route = message.data['route'] ?? '/';
      onNavigate(route);
    });

    _fcm.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint("Aplikasi dibuka dari kondisi Terminated via notifikasi");
        final route = message.data['route'] ?? '/';
        onNavigate(route);
      }
    });
  }
}