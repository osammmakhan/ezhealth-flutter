import 'package:ez_health/assets/constants/constants.dart';
import 'package:flutter/material.dart';

class HorizontalBtn extends StatelessWidget {
  const HorizontalBtn({
    super.key,
    required this.text,
    required this.onPressed,
    this.nextScreen,
    this.backgroundColor,
    this.foregroundColor,
    this.minimumSize,
    this.textStyle,
  });

  final String text;
  final Function() onPressed;
  final Widget? nextScreen;

  // Optional styling properties
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Size? minimumSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
          if (nextScreen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextScreen!),
            );
          }
        },
        child: Text(
          text,
          style: textStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ??
              customBlue, // Use passed backgroundColor or default
          foregroundColor: foregroundColor ??
              Colors.white, // Use passed foregroundColor or default
          minimumSize: minimumSize ??
              const Size(
                  double.infinity, 36), // Use passed minimumSize or default
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
