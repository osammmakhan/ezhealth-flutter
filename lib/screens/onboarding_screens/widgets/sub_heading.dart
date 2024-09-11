import 'package:flutter/material.dart';

class Sub_Heading extends StatelessWidget {
  const Sub_Heading({
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
