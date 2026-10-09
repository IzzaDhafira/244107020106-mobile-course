import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'firebase_options.dart';
import 'messaging/push_service.dart';
import 'data/api_client.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
const storage = FlutterSecureStorage();

// Auth Notifier
final authProvider = NotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setLoggedIn(bool value) => state = value;
}

// Router Provider yang Reaktif terhadap authProvider
final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: navKey,
    initialLocation: '/',
    redirect: (context, state) {
      final isGoingToLogin = state.matchedLocation == '/login';

      if (!isLoggedIn && !isGoingToLogin) return '/login';
      if (isLoggedIn && isGoingToLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/pengumuman/:id',
        builder: (context, state) => DetailScreen(id: state.pathParameters['id']!),
      ),
    ],
  );
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }
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
    PushService().init((route) => navKey.currentState?.context.go(route));
    setupDioInterceptor(() {
      ref.read(authProvider.notifier).setLoggedIn(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- UI SCREENS ---

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              // Simpan token secara asinkron
              await storage.write(key: 'token', value: 'secret_token');
            } catch (e) {
              debugPrint('Storage error (diabaikan untuk mock): $e');
            }
            
            // Ubah state login agar GoRouter otomatis redirect
            ref.read(authProvider.notifier).setLoggedIn(true);
          },
          child: const Text('Mock Login'),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Campus Notify')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/pengumuman/123'),
          child: const Text('Buka Detail Pengumuman #123'),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengumuman #$id')),
      body: Center(
        child: Text('Isi Detail Pengumuman ID: $id', style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}