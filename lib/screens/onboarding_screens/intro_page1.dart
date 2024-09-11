import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/screens/onboarding_screens/widgets/onboarding_contents.dart';
import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingContents(
        svgImage: 'lib/assets/svgs/Doctor Checkup.svg',
        imageLabel: 'Image 1',
        displayText1: 'Discover\t',
        textColor1: Colors.black,
        displayText2: 'Experianced\nDoctors',
        textColor2: customBlue,
        descriptionText:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a purus ullamcorper');
  }
}
