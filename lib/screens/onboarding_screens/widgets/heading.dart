import 'package:flutter/material.dart';

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
