import 'package:ez_health/screens/onboarding_screens/widgets/heading.dart';
import 'package:ez_health/screens/onboarding_screens/widgets/sub_heading.dart';
import 'package:ez_health/screens/onboarding_screens/widgets/svg_image.dart';
import 'package:flutter/material.dart';

class OnboardingContents extends StatelessWidget {
  const OnboardingContents({
    super.key,
    required this.svgImage,
    required this.imageLabel,
    required this.displayText1,
    required this.textColor1,
    required this.displayText2,
    required this.textColor2,
    required this.descriptionText,
  });

  final String displayText1,
      displayText2,
      svgImage,
      imageLabel,
      descriptionText;
  final Color textColor1, textColor2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: SVG_Image(
            svgImage: svgImage,
            imageLabel: imageLabel,
          ),
        ),

        //Headings
        Heading(
            displayText1: displayText1,
            textColor1: textColor1,
            displayText2: displayText2,
            textColor2: textColor2),

        //Sub-Heading Text
        Sub_Heading(
          descriptionText: descriptionText,
        ),
      ],
    );
  }
}
