
import 'package:flutter/material.dart';
import 'package:rider_pay_user/res/app_border.dart';
// ignore: unused_import
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';


class ConstContainer extends StatelessWidget {
  final double? vertical;
  final double? horizontal;
  final Widget? child;
  final void Function()? onTap;
  final Color? color;
  final String? img;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final Gradient? gradient;
  final BoxFit? boxFit;
  final AlignmentGeometry? alignment;
  final BoxBorder? border;
  final String? title;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;


  const ConstContainer({
    super.key,

    this.child,
    this.onTap,
    this.color,
    this.img,
    this.width,
    this.height,
    this.borderRadius,
    this.gradient,
    this.boxFit,
    this.alignment,
    this.border,
    this.title,
    this.margin,
    this.boxShadow, this.padding, this.vertical, this.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: alignment ?? Alignment.center,
        padding:padding?? EdgeInsets.symmetric(
          horizontal: horizontal ?? 15,
          vertical: vertical ?? 5,
        ),
        margin: margin,
        height: height,
        width: width,
        decoration: BoxDecoration(
            boxShadow: boxShadow,
            border: border,
            image: img != null
                ? DecorationImage(
              image: AssetImage(img!),
              fit: boxFit ?? BoxFit.contain,
            )
                : null,
            color: color ?? Colors.transparent,
            gradient: gradient,
            borderRadius: borderRadius ?? AppBorders.defaultRadius),
        child: child ?? (title != null
            ? ConstText(text: title!)
            : const SizedBox.shrink()),
      ),
    );
  }
}
