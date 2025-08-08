import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyText extends StatelessWidget {
  const MyText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.color,
    this.letterSpacing,
    this.maxLines,
    this.overflow,
    this.textDecoration,
    this.fontStyle,
    this.softWrap,
    this.shadows,
    this.isBold = false,
  });

  final String text;
  final double? fontSize;
  final double? letterSpacing;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontStyle? fontStyle;
  final bool? softWrap;
  final List<Shadow>? shadows;
  final TextDecoration? textDecoration;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = GoogleFonts.lato(
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : fontWeight,
      letterSpacing: letterSpacing,
      color: color,
      fontStyle: fontStyle,
      decoration: textDecoration,
      shadows: shadows,
    );

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}
