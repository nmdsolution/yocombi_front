import 'package:flutter/material.dart';

class YoCombiLogo extends StatelessWidget {
  final double width;
  final double height;

  const YoCombiLogo({
    super.key,
    this.width = 360,
    this.height = 320,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/core/images/yocombi_logorb.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
