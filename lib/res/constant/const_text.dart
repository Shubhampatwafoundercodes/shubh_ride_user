import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/res/app_color.dart' show AppColorsExt;
import 'package:rider_pay_user/res/app_constant.dart';

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
    this.decorationColor,
    this.fontStyle,
    this.letterHeight,
    this.textScaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        height: letterHeight,
        fontSize: fontSize ?? AppConstant.fontSizeTwo,
        fontWeight: fontWeight ?? AppConstant.regular,
        color: color ?? context.textSecondary,
        wordSpacing: wordSpacing,
        foreground: foreground,
        fontStyle: fontStyle,
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
  /// Static part (normal text)
  final String firstText;

  /// First tappable text (optional)
  final String? tappableText1;

  /// Second tappable text (optional)
  final String? tappableText2;

  final String? text3;

  /// Tap actions (optional)
  final VoidCallback? onTap1;
  final VoidCallback? onTap2;

  /// Styling
  final double? fontSize;
  final Color? firstColor;
  final Color? tappableColor;
  final FontWeight? fontWeight;

  const DoubleText({
    super.key,
    required this.firstText,
    this.tappableText1,
    this.tappableText2,
    this.onTap1,
    this.onTap2,
    this.fontSize,
    this.firstColor,
    this.tappableColor,
    this.fontWeight,
    this.text3,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: fontSize ?? AppConstant.fontSizeZero,
            color: firstColor ?? context.textPrimary,
            fontWeight: fontWeight ?? FontWeight.normal,
            fontFamily: "Poppins",
          ),
          children: [
            TextSpan(text: firstText),

            if (tappableText1 != null) ...[
              const TextSpan(text: " "),
              TextSpan(
                text: tappableText1,
                style: TextStyle(
                  color: tappableColor ?? context.primary,
                  fontWeight: AppConstant.semiBold,
                  fontSize: AppConstant.fontSizeZero,
                ),
                recognizer: onTap1 != null
                    ? (TapGestureRecognizer()..onTap = onTap1)
                    : null,
              ),
            ],

            if (tappableText2 != null) ...[
              TextSpan(
                text: text3 ?? " and ",
                style: TextStyle(
                  color: tappableColor ?? context.textPrimary,
                  fontSize: AppConstant.fontSizeZero,
                ),
              ),
              TextSpan(
                text: tappableText2,
                style: TextStyle(
                  color: tappableColor ?? context.primary,
                  fontWeight: AppConstant.medium,
                  fontSize: AppConstant.fontSizeZero,
                ),
                recognizer: onTap2 != null
                    ? (TapGestureRecognizer()..onTap = onTap2)
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
