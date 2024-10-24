import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Have to hide these before making the project public
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAypF89ApLUkusAtx1ersR1a4pn4x-xzgo",
          appId: "1:735235674573:android:21818f171c0113be5ff484",
          messagingSenderId: "735235674573",
          projectId: "ezhealth-32082"));

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
