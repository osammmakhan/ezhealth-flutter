import 'package:flutter/material.dart';
import 'package:ez_health/assets/constants/constants.dart';

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
    this.enabled = true,  // New parameter
  });

  final String text;
  final Function()? onPressed;
  final Widget? nextScreen;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Size? minimumSize;
  final TextStyle? textStyle;
  final bool enabled;  // New parameter to control button state

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: ElevatedButton(
          onPressed: enabled
              ? () {
                  if (onPressed != null) {
                    onPressed!();
                  }
                  if (nextScreen != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => nextScreen!),
                    );
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? customBlue,
            foregroundColor: foregroundColor ?? Colors.white,
            minimumSize: minimumSize ?? const Size(double.infinity, 36),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
            disabledBackgroundColor: backgroundColor?.withOpacity(0.5) ??
                customBlue.withOpacity(0.5),
            disabledForegroundColor: foregroundColor?.withOpacity(0.5) ??
                Colors.white.withOpacity(0.5),
          ),
          child: Text(
            text,
            style: textStyle ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
          ),
        ),
      ),
    );
  }
}