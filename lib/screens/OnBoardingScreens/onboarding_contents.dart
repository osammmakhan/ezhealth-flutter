import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
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
          child: SvgImage(
            svgImage: svgImage,
            imageLabel: imageLabel,
          ),
        ),

        Heading(
            displayText1: displayText1,
            textColor1: textColor1,
            displayText2: displayText2,
            textColor2: textColor2),

        SubHeading(descriptionText: descriptionText),
      ],
    );
  }
}

class Heading extends StatelessWidget {
  const Heading({
    super.key,
    required this.displayText1,
    required this.textColor1,
    required this.displayText2,
    required this.textColor2,
  });

  final String displayText1;
  final Color textColor1;
  final String displayText2;
  final Color textColor2;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 180),
      alignment: Alignment.bottomCenter,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: displayText1,
              style: TextStyle(
                color: textColor1,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: displayText2,
              style: TextStyle(
                fontSize: 26,
                color: textColor2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubHeading extends StatelessWidget {
  const SubHeading({
    super.key,
    required this.descriptionText,
  });

  final String descriptionText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 120,
        horizontal: 50,
      ),
      alignment: Alignment.bottomCenter,
      child: Text(
        descriptionText,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}

class SvgImage extends StatelessWidget {
  const SvgImage({
    super.key,
    required this.svgImage,
    required this.imageLabel,
  });

  final String svgImage;
  final String imageLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgImage,
      semanticsLabel: imageLabel,
    );
  }
}