import 'package:flutter/material.dart';
import 'package:ez_health/assets/constants/constants.dart';

class CustomNavigationButton extends StatelessWidget {
  final IconData icon;
  final bool isFilled;
  final VoidCallback? onPressed;

  const CustomNavigationButton({
    Key? key,
    required this.icon,
    required this.isFilled,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: isFilled ? customBlue : Colors.white,
        side: BorderSide(
          color: customBlue,
          width: 2,
        ),
        elevation: isFilled ? 2 : 0,
      ),
      child: Icon(
        icon,
        color: isFilled ? Colors.white : customBlue,
      ),
    );
  }
}
