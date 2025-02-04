import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/payment_provider.dart';
import 'services/firebase_service.dart';
import 'secret.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: Secret.apiKey,
          appId: Secret.appId,
          messagingSenderId: Secret.messagingSenderId,
          projectId: Secret.projectId));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        Provider<FirebaseService>(create: (_) => FirebaseService()),
      ],
      child: const MyApp(),
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
