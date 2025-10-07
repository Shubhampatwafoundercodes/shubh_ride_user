import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/constant/const_text.dart';

class CommonBackBtnWithTitle extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? padding ;
  const CommonBackBtnWithTitle({
    super.key, required this.text, this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pop(context);
      },
      child: Padding(
        padding:padding??  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(Icons.arrow_back, color: context.textPrimary),
            SizedBox(width: 8.w),
            ConstText(text:
            text,
              fontSize: AppConstant.fontSizeThree,
              color: context.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
