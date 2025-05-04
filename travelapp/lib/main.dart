// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Firebase core
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Your providers
import 'providers/auth_provider.dart';
import 'providers/place_provider.dart';

// Your screens
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_page.dart';
import 'screens/list_page.dart';
import 'screens/details_page.dart';
import 'screens/cart_page.dart';
import 'screens/profile_page.dart';
import 'screens/admin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the options in firebase_options.dart
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PlaceProvider()),
      ],
      child: const TravelApp(),
    ),
  );
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wonderful United Kingdom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF2F2F2),
      ),

      // Start at the login screen
      initialRoute: '/login',

      // Named routes for easy navigation
      routes: {
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupPage(),
        '/home': (_) => const HomePage(),
        '/list': (_) => const ListPage(),
        '/detail': (_) => const DetailsPage(),
        '/cart': (_) => const CartPage(),
        '/profile': (_) => const ProfilePage(),
        '/admin': (_) => const AdminPage(),
      },

      // Fallback in case you push a route that isn't defined above:
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => const LoginPage());
      },
    );
  }
}
