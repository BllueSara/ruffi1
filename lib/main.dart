
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/splash_view.dart';
import 'views/onboarding_view.dart';
import 'views/auth_view.dart';
import 'views/bottom_navigation_view.dart';
import 'controllers/home_controller.dart';
import 'controllers/auth_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'IBMPlexSansArabic',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashView(),
          '/onboarding': (context) => const OnboardingView(),
          '/login': (context) => const AuthView(),
          '/home': (context) => const BottomNavigationView(),
        },
      ),
    );
  }
}