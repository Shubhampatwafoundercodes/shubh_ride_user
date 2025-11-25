import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';

class ConstAppBackBtn extends StatelessWidget {
  final Color? color;
  final double? scale;
  final double? topPadding;
  final double? leftPadding;
  final IconData? icon;
  final double? iconSize;
  final VoidCallback? onTap;

  const ConstAppBackBtn({
    super.key,
    this.color,
    this.scale,
    this.topPadding,
    this.leftPadding,
    this.icon,
    this.iconSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t= AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.pop(context);
      } ,
      child: Row(
        children: [
          Icon(
            icon ?? Icons.arrow_back_ios_new,
            color: color ??context.textPrimary,
            size: iconSize ?? 18.h,
          ),
          SizedBox(width: 05,),
          ConstText(text: t.back, color: context.textPrimary,

          )
        ],
      ),
    );
  }
}
