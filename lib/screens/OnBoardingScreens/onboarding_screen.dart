import 'package:flutter/material.dart';
import 'dot_indicators.dart';
import 'onboarding_contents.dart';
import '/assets/constants/constants.dart';

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
              OnBoardingPage(
                  svgImage: 'lib/assets/svgs/Doctor Checkup.svg',
                  imageLabel: 'Image 1',
                  displayText1: 'Discover\t',
                  textColor1: Colors.black,
                  displayText2: 'Experianced\nDoctors',
                  textColor2: customBlue,
                  descriptionText:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a purus ullamcorper'),
              OnBoardingPage(
                  svgImage: 'lib/assets/svgs/Medical Team.svg',
                  imageLabel: 'Image 2',
                  displayText1: 'Learn About\t',
                  textColor1: customBlue,
                  displayText2: 'Your\nDoctors',
                  textColor2: Colors.black,
                  descriptionText:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a purus ullamcorper'),
              OnBoardingPage(
                svgImage: 'lib/assets/svgs/Calendar Guy.svg',
                imageLabel: 'Image 3',
                displayText1: 'Efforless\t',
                textColor1: Colors.black,
                displayText2: 'Appointment\nBooking',
                textColor2: customBlue,
                descriptionText:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a purus ullamcorper',
              ),
            ],
          ),

          // Dot Indicators
          DotIndicator(controller: _controller),
        ],
      ),
    );
  }
}