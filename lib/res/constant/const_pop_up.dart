
import 'package:flutter/material.dart';
import 'package:rider_pay/main.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_padding.dart';


class ConstPopUp extends StatelessWidget {
  final Widget child;
  final Color? bgColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const ConstPopUp(
      {super.key,
      required this.child,
      this.bgColor,
      this.borderColor,
      this.borderRadius, this.padding
      });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.black45,
        insetPadding: AppPadding.screenPadding,
        child: Container(
            decoration: BoxDecoration(
                color: bgColor ??  context.popupBackground,
                borderRadius:BorderRadius.circular(5),
                border: Border.all(width: 1.5, color: borderColor ?? context.greyMedium)),
            // ignore: prefer_const_constructors
            padding:padding?? EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: child
        ),
      ),
    );
  }
}

class CustomPopUp extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final double? leftPadding;
  final double? topPadding;
  final double? borderRadius;
  final Color? color;
  const CustomPopUp(
      {super.key,
      this.height,
      this.width,
      this.child,
      this.leftPadding,
      this.topPadding,
      this.borderRadius,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          height: height ?? screenHeight * 0.53,
          width: width ?? screenWidth * 0.85,
          padding: EdgeInsets.symmetric(
              horizontal: leftPadding ?? 15, vertical: topPadding ?? 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            color: color ?? AppColor.white,
          ),
          child: child,
        ),
      ),
    );
  }
}
