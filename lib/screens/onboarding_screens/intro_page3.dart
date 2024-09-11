import 'package:ez_health/assets/constants/constants.dart';
import 'package:ez_health/screens/onboarding_screens/widgets/onboarding_contents.dart';
import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingContents(
      svgImage: 'lib/assets/svgs/Calendar Guy.svg',
      imageLabel: 'Image 3',
      displayText1: 'Efforless\t',
      textColor1: Colors.black,
      displayText2: 'Appointment\nBooking',
      textColor2: customBlue,
      descriptionText:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a purus ullamcorper',
    );
  }
}
