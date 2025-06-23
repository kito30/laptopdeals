import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopdeals/screens/homepage.dart';
import 'package:laptopdeals/screens/mainpage.dart';
import 'package:laptopdeals/screens/login.dart';
import 'package:laptopdeals/widgets/colors.dart';
import 'package:laptopdeals/screens/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:laptopdeals/widgets/navbar.dart';
import 'package:laptopdeals/screens/saveddeal.dart';
import 'package:laptopdeals/screens/userprofile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: LaptopApp()));
}

class LaptopApp extends StatelessWidget {
  const LaptopApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laptop App',
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.inversePrimary,
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(140, 10),

            backgroundColor: colorScheme.onInverseSurface,
          ),
        ),
      ),
      routes: {
        '/': (context) => const AppShell(body: MainPage()),
        '/main': (context) => const AppShell(body: MainPage()),
        '/login': (context) => const AppShell(body: LoginPage()),
        '/register': (context) => const AppShell(body: RegisterPage()),
        '/homepage': (context) => const MainLayout(body: Homepage()),
        '/saved': (context) => const MainLayout(body: SavedDeals()),
        '/profile': (context) => const MainLayout(body: UserProfile()),
      },
      initialRoute: '/',
    );
  }
}

class AppShell extends StatelessWidget {
  final Widget body;

  const AppShell({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laptop Deals',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: body,
    );
  }
}

class MainLayout extends StatelessWidget {
  final Widget body;
  final int initialIndex = 0;

  const MainLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    void onDestinationSelected(int index) {
      if (index == 0) {
        Navigator.pushNamed(context, '/homepage');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/saved');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/profile');
      }
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: Navbar(
        initialIndex: initialIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
