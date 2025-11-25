import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/generated/assets.dart';
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/const_pop_up.dart';
import 'package:rider_pay_user/res/constant/const_text.dart' show ConstText;


class ZoneRejectPopup extends StatelessWidget {
  final VoidCallback onClose;

  const ZoneRejectPopup({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return ConstPopUp(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Close Button (top right)
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: onClose,
              child: Image.asset(
                Assets.iconCancelIc,
                height: 15.h,
              ),
            ),
          ),
          AppSizes.spaceH(35),

          /// Reject Icon
          Image.asset(
            Assets.imagesReject,
            height: 100.h,
          ),
          AppSizes.spaceH(20),

          /// Title
          ConstText(
            text: "Service Not Available",
            fontWeight: AppConstant.semiBold,
            fontSize: AppConstant.fontSizeLarge,
            color: context.textSecondary,
            textAlign: TextAlign.center,
          ),

          AppSizes.spaceH(8),

          /// Subtitle
          ConstText(
            text:
            "The selected pickup or drop location is currently out of our service area. Please select a different location.",
            color: context.textSecondary,
            fontSize: AppConstant.fontSizeOne,
            textAlign: TextAlign.center,
          ),

          AppSizes.spaceH(30),

          /// Action Button
          AppBtn(
            title: "OK, Got It",
            onTap: onClose,
          ),

          AppSizes.spaceH(20),
        ],
      ),
    );
  }
}
