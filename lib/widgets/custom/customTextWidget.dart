import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? size;
  final TextAlign? textAlign;
  final bool withOverflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final Paint? foreground;
  final String? fontFamily;
  const CustomTextWidget(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.size,
    this.textAlign,
    this.withOverflow = true,
    this.maxLines,
    this.decoration,
    this.foreground,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    TextOverflow? overflow = withOverflow ? TextOverflow.ellipsis : null;
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: size,
          overflow: overflow,
          decoration: decoration,
          foreground: foreground,
          fontFamily: fontFamily),
    );
  }
}
