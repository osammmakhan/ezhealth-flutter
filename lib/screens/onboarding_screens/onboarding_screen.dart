import 'package:ez_health/screens/onboarding_screens/widgets/dot_Indicators.dart';
import 'package:ez_health/screens/onboarding_screens/intro_page1.dart';
import 'package:ez_health/screens/onboarding_screens/intro_page2.dart';
import 'package:ez_health/screens/onboarding_screens/intro_page3.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  //Controller to keep track on which page we're on
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page View
          PageView(
            controller: _controller,
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),

          // Dot Indicators
          DotIndicator(controller: _controller),
        ],
      ),
    );
  }
}
