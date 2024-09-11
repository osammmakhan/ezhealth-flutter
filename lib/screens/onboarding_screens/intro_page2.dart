import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/screens/onboarding_screens/widgets/onboarding_contents.dart';
import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingContents(
      svgImage: 'lib/assets/svgs/Medical Team.svg',
      imageLabel: 'Image 2',
      displayText1: 'Learn About\t',
      textColor1: customBlue,
      displayText2: 'Your\nDoctors',
      textColor2: Colors.black,
      descriptionText:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a purus ullamcorper',
    );
  }
}
