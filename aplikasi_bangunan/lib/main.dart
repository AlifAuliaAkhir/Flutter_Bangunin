import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'pages/login_page.dart';
import 'screens/home_user_screen.dart';
import 'screens/home_admin_screen.dart';
import 'screens/toko_map_screen.dart';
import 'screens/profile_user_screen.dart';
import 'screens/profile_admin_screen.dart';
import 'screens/crud_menu_screen.dart';
import 'screens/splash.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print('API_URL Loaded: ${dotenv.env['API_URL']}');
  } catch (e) {
    print("Gagal memuat .env: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Bangunan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(),
        '/login': (context) => LoginPage(),
        '/home-user': (context) => const HomeUserScreen(),
        '/home-admin': (context) => const HomeAdminScreen(),
        '/map': (context) => const TokoMapScreen(),
        '/profile-user': (context) => const ProfileUserScreen(namaUser: ''),
        '/profile-admin': (context) => const ProfileAdminScreen(),
        '/crud': (context) => const CrudMenuScreen(),
      },
    );
  }
}
