import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/home_screen_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          // TODO: Hide these before making the project public
          apiKey: "AIzaSyAypF89ApLUkusAtx1ersR1a4pn4x-xzgo",
          appId: "1:735235674573:android:21818f171c0113be5ff484",
          messagingSenderId: "735235674573",
          projectId: "ezhealth-32082"));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}
