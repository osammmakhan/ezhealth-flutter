import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ez_health/screens/onboarding_screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCRHChdhYuX-hf12tyoodZU030Me27wOZ0",
      appId: "1:29965316139:android:958521c9c6bb7457353a6e",
      messagingSenderId: "29965316139",
      projectId: "ez-health-8a163"
      )
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OnboardingScreen(),
    );
  }
}
