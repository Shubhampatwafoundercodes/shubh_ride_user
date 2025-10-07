
import 'package:flutter/material.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/constant/const_text.dart';


class ConstTextBtn extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final Color? textColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final TextDecoration? decoration;
  final double? fontSize;
  final TextAlign? textAlign;
  final AlignmentGeometry? alignment;

  const ConstTextBtn({
    super.key,
    required this.text,
    this.fontWeight,
    this.textColor,
    this.onTap,
    this.padding,
    this.decoration,
    this.fontSize,
    this.textAlign,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        alignment: alignment ?? Alignment.center,
        child: ConstText(text:
          text,
          textAlign: textAlign ?? TextAlign.center,
            fontSize: fontSize ?? AppConstant.fontSizeTwo,
            fontWeight: fontWeight ?? AppConstant.medium,
            color: textColor ?? AppColor.black,
            decoration: decoration,
        ),
      ),
    );
  }
}
