import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

String? pendingDeepLink;

/// =====================================================================
/// PERHATIAN: 
/// 1. Bagian ini BERJALAN DI ISOLATE TERPISAH saat aplikasi terminated/background.
/// 2. DILARANG KERAS mengakses BuildContext, Riverpod, atau state widget di sini.
/// 3. Tugasnya hanya menangani data ringan / logging.
/// =====================================================================
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Hanya simpan atau catat data ringan, navigasi dilakukan saat notifikasi diklik
  debugPrint("Background message received: ${message.messageId}");
}

class PushServiceV2 {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Inisialisasi layanan push notification dan lokal notification
  Future<void> init({required void Function(String route) onNavigate}) async {
    // 1. Daftarkan Background Handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 2. Setup Inisialisasi Local Notifications (Konfigurasi Android vs iOS)
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // Perbedaan iOS: Memerlukan pengaturan izin khusus untuk presentasi awal
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          onNavigate(response.payload!);
        }
      },
    );

    // 3. Request Permission
    await requestPermission();

    // 4. Get FCM Token & Setup Token Refresh (Kirim ke Backend POST /devices)
    await setupTokenHandling();

    // 5. Setup Listeners untuk App States (Foreground, Background, Terminated)
    setupMessageListeners(onNavigate);
  }

  /// Meminta izin notifikasi (Perbedaan signifikan pada Android 13+ / API 33 ke atas
  /// di mana POST_NOTIFICATION menjadi permission runtime yang wajib diminta secara eksplisit).
  Future<void> requestPermission() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  /// Mengambil token awal dan menangani pembaruan token (onTokenRefresh)
  Future<void> setupTokenHandling() async {
    String? token = await _fcm.getToken();
    if (token != null) {
      await _sendTokenToServer(token);
    }

    // Mendengarkan jika token perangkat diperbarui oleh FCM
    _fcm.onTokenRefresh.listen((newToken) async {
      await _sendTokenToServer(newToken);
    });
  }

  /// Simulasi pengiriman token ke Backend (POST /devices)
  Future<void> _sendTokenToServer(String token) async {
    // Implementasi HTTP POST ke backend Anda menggunakan dio / http
    debugPrint('SIMULASI POST /devices -> Token dikirim ke backend: $token');
  }

  /// Mengatur listener untuk Foreground, Background, dan Terminated State
  void setupMessageListeners(void Function(String route) onNavigate) {
    // FOREGROUND: Sistem Android/iOS TIDAK menampilkan banner otomatis saat app terbuka.
    // Wajib menggunakan flutter_local_notifications untuk menampilkan banner manual.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      final route = message.data['route'] ?? '/';

      if (notification != null && android != null) {
        const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
          'pengumuman_channel_id',
          'Pengumuman Kampus',
          channelDescription: 'Notifikasi penting untuk civitas akademika',
          importance: Importance.max,
          priority: Priority.high,
        );

        const NotificationDetails platformDetails = NotificationDetails(
          android: androidDetails,
          iOS: DarwinNotificationDetails(),
        );

        await _localNotificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: platformDetails,
          payload: route,
        );
      }
    });

    // BACKGROUND -> DIKLIK: Pengguna mengklik banner saat aplikasi di latar belakang
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final route = message.data['route'] ?? '/';
      onNavigate(route);
    });

    // TERMINATED -> DIKLIK: Aplikasi dibuka dari kondisi mati total (cold start)
    _fcm.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        final route = message.data['route'] ?? '/';
        onNavigate(route);
      }
    });

    // Tangani deep link yang tersimpan dari local notification saat terminated/background
    if (pendingDeepLink != null) {
      onNavigate(pendingDeepLink!);
      pendingDeepLink = null;
    }
  }

  /// Berlangganan ke topik pengumuman kampus (Broadcast)
  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  /// Berhenti berlangganan dari topik pengumuman kampus
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }
}