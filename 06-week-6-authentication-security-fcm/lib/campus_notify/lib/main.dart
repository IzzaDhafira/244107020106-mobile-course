import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'messaging/push_service.dart';
import 'providers/auth_provider.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/announcement_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  // Wajib dipanggil sebelum Firebase.initializeApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Setup Notifikasi (Meminta izin & inisialisasi lokal)
  registerBackgroundHandler();
  await requestNotificationPermission();
  await initLocalNotifications(go: (route) {
    navigatorKey.currentContext?.go(route);
  });

  await initFcmToken(onToken: (token) async {
      debugPrint('====================================');
      debugPrint('FCM TOKEN HP SAYA: $token');
      debugPrint('====================================');
  });

  // 2. Daftarkan Listener untuk Foreground dan Terminated state
  listenForeground((route) {
    navigatorKey.currentContext?.go(route);
  });

  // Jalankan aplikasi dengan ProviderScope untuk Riverpod
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // 3. Tangani rute saat aplikasi dibuka dari kondisi terminated
    handleTerminated((route) {
      // Menggunakan addPostFrameCallback agar navigasi dieksekusi setelah widget siap
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentContext?.go(route);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Membaca status autentikasi dari Riverpod
    final authState = ref.watch(authStateProvider);

    // Konfigurasi GoRouter
    final router = GoRouter(
      navigatorKey: navigatorKey, // Pasang navigatorKey di sini
      initialLocation: '/',
      redirect: (context, state) {
        // Jika status auth sedang loading, jangan pindah halaman dulu
        if (authState.isLoading) return null;

        final loggedIn = authState.value ?? false;
        final goingLogin = state.matchedLocation == '/login';

        // Logika Proteksi Halaman
        if (!loggedIn && !goingLogin) return '/login'; // Belum login -> paksa ke login
        if (loggedIn && goingLogin) return '/'; // Sudah login -> halangi akses ke halaman login lagi
        
        return null; // Lanjutkan ke rute yang diminta
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/pengumuman/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return AnnouncementPage(id: id);
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Campus Notify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: router,
    );
  }
}