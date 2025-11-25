

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/main.dart';
import 'package:rider_pay_user/res/app_color.dart';

import 'app_constant.dart';
import 'constant/const_text.dart';


class AppBtn extends StatefulWidget {
  final String? title;
  final Color? titleColor;
  final Color? color;
  final Function()? onTap;
  final double? fontSize;
  final bool? loading;
  final Gradient? gradient;
  final bool hideBorder;
  final Widget? child;
  final FontWeight? fontWeight;
  final BoxBorder? border;
  final double borderRadius;
  final double? height;
  final BorderRadiusGeometry? radiusOnly;
  final double? width;
  final EdgeInsetsGeometry? margin;

  const AppBtn({
    super.key,
    this.title,
    this.titleColor,
    this.color,
    this.onTap,
    this.fontSize,
    this.loading = false,
    this.gradient,
    this.hideBorder = false,
    this.child,
    this.fontWeight,
    this.border,
    this.borderRadius = 35,
    this.height,
    this.radiusOnly,
    this.width,
    this.margin,
  });

  @override
  State<AppBtn> createState() => _AppBtnState();
}

class _AppBtnState extends State<AppBtn> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showBorder = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if(_showBorder)return;
    setState(() {
      _showBorder = true;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showBorder = false;
        });
      }
    });

    await Future.delayed(const Duration(milliseconds: 300));
    widget.onTap?.call();
  }

  Widget buildButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: _showBorder ? const EdgeInsets.all(2) : EdgeInsets.zero,
      margin: widget.margin,
      height: widget.height ?? screenHeight * 0.055,
      width: widget.width ?? screenWidth,
      decoration: BoxDecoration(
        borderRadius: widget.radiusOnly ?? BorderRadius.circular(widget.borderRadius),
        // gradient: _showBorder
        //     ? const LinearGradient(
        //   colors: [Color(0xC6DCDBD6), Color(0xB2B5B5B5)],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // )
        //     : null,
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.color ?? context.primary,
          gradient: widget.gradient,
          border: widget.border,
          borderRadius: widget.radiusOnly ?? BorderRadius.circular(widget.borderRadius),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Color(0x33000000),
          //     blurRadius: 8,
          //     offset: Offset(3, 3),
          //   ),
          // ],
        ),
        child: widget.child ??
            ConstText(
              text: (widget.title ?? 'BUTTON'),
              color: widget.titleColor ?? AppColor.white,
              fontWeight: widget.fontWeight ?? AppConstant.semiBold,
              fontSize: widget.fontSize ?? AppConstant.fontSizeTwo,
            ),
      ),
    );
  }

  Widget buildCircle() {
    return Center(
      child: Container(
        height: widget.height ?? screenHeight * 0.06,
        width: widget.width ?? screenWidth,
        margin: widget.margin,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.color ?? context.primary,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        padding: const EdgeInsets.all(3),
        child: SizedBox(
          width: 23,
          height: 23,
          child: CircularProgressIndicator(
            color: widget.titleColor ?? AppColor.black,
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _handleTap();
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.loading == false ? buildButton() : buildCircle(),
          );
        },
      ),
    );
  }
}
