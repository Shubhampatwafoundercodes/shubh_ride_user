import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/generated/assets.dart';
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/const_pop_up.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';

class SuccessRejectPopup extends StatelessWidget {
  final bool isReject;             // Success ya Reject check
  final String? btnTitle;          // Button ka title (optional)
  final VoidCallback? onAction;    // Button action
  final String? title;             // 👈 Dynamic Title
  final String? subtitle;          // 👈 Dynamic Subtitle (optional)
  final Widget? customContent;     // 👈 Agar aur kuch dikhana ho to

  const SuccessRejectPopup({
    super.key,
    this.isReject = false,
    this.btnTitle,
    this.onAction,
    this.title,
    this.subtitle,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return ConstPopUp(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AppSizes.spaceH(15),
          Align(
             alignment: Alignment.topRight,

              child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },

                  child: Image.asset(Assets.iconCancelIc,height: 15.h,))),
          AppSizes.spaceH(35),

          /// Icon
          Image.asset(
            !isReject ? Assets.imagesSuccess : Assets.imagesReject,
            height: 100.h,
          ),
          AppSizes.spaceH(20),

          /// Title
          if (title != null)
            ConstText(
              text: title!,
              fontWeight: AppConstant.semiBold,
              fontSize: AppConstant.fontSizeLarge,
              color: AppColor.textSecondary,
            ),

          /// Subtitle
          if (subtitle != null) ...[
            AppSizes.spaceH(4),
            ConstText(
              text: subtitle!,
              color: AppColor.textSecondary,
              fontSize: AppConstant.fontSizeOne,
              textAlign: TextAlign.center,
            ),
          ],

          /// Extra Custom Content
          if (customContent != null) ...[
            AppSizes.spaceH(12),
            customContent!,
          ],

          /// Action Button
          if (btnTitle != null && onAction != null) ...[
            AppSizes.spaceH(30),
            AppBtn(
              title: btnTitle!,
              onTap: onAction!,
            ),
          ],

          AppSizes.spaceH(20),
        ],
      ),
    );
  }
}
