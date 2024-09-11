import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SVG_Image extends StatelessWidget {
  const SVG_Image({
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
