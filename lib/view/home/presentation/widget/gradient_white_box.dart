import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/res/app_color.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GradientContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
            const Color(0xFF1E1E2C), // Dark navy base
            const Color(0xFF2A2A40), // Slightly lighter blend
          ]
              : [
            context.greyLight, // Light bluish background
            context.white,        // White blend
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: context.black.withAlpha(30),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          else
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.6),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
        border: Border.all(color:context.greyMedium,width: 0.2)
      ),
      child: child,
    );
  }
}
