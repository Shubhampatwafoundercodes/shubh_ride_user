
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/res/app_color.dart' show AppColor, AppColorsExt;
import 'package:rider_pay/res/app_constant.dart';


class ConstText extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final int? maxLine;
  final double? fontSize;
  final bool? strikethrough;
  final FontWeight? fontWeight;
  final double? wordSpacing;
  final double? letterSpacing;
  final double? letterHeight;
  final TextDecoration? decoration;
  final Color? color;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final Paint? foreground;
  final Color? decorationColor;
  final FontStyle? fontStyle;
  final double? textScaleFactor;

  const ConstText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.overflow,
    this.maxLine,
    this.textAlign,
    this.wordSpacing,
    this.letterSpacing,
    this.decoration,
    this.strikethrough,
    this.foreground,
    this.fontFamily,
    this.decorationColor, this.fontStyle, this.letterHeight, this.textScaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        height:letterHeight ,
        fontSize: fontSize ?? AppConstant.fontSizeTwo,
        fontWeight: fontWeight ?? AppConstant.regular,
        color: color ?? context.textSecondary,
        wordSpacing: wordSpacing,
        foreground: foreground,
        fontStyle:fontStyle,
        letterSpacing: letterSpacing,
        decoration: decoration,
        decorationColor: decorationColor,
        fontFamily: fontFamily ?? 'Poppins',
        overflow: maxLine != null ? TextOverflow.ellipsis : null,
      ),
    );
  }
}


class DoubleText extends StatelessWidget {
  final String firstText;
  final String secondText;
  final VoidCallback onTap;
  final double? firstSize;
  final double? secondSize;
  final Color? firstColor;
  final Color? secondColor;
  final FontWeight? firstWeight;
  final FontWeight? secondWeight;

  const DoubleText({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.onTap,
    this.firstSize,
    this.secondSize,
    this.firstColor,
    this.secondColor,
    this.firstWeight,
    this.secondWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstText(
          text: firstText,
          fontSize: firstSize ?? AppConstant.fontSizeTwo,
          color: firstColor??context.textPrimary,
          fontWeight: firstWeight,
        ),
         SizedBox(width: 4.w),
        GestureDetector(
          onTap: onTap,
          child: ConstText(
            text: secondText,
            fontSize: secondSize??AppConstant.fontSizeOne,
            color: secondColor??context.primary,
            fontWeight: secondWeight ?? FontWeight.bold,
            // decoration: TextDecoration.underline,
            // decorationColor: AppColor.primary,
          ),
        ),
      ],
    );
  }
}
