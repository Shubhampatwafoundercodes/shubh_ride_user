import 'package:flutter/material.dart';
import 'package:rider_pay_user/generated/assets.dart';
import 'package:rider_pay_user/res/app_btn.dart' show AppBtn;
// ignore: unused_shown_name
import 'package:rider_pay_user/res/app_color.dart' show AppColor, AppColorsExt;
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/app_size.dart';
// ignore: unused_import
import 'package:rider_pay_user/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';

class BikeFareDetails extends StatelessWidget {
  final String totalAmount;
  const BikeFareDetails({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: context.popupBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),

        padding:AppPadding.screenPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Image.asset(Assets.iconBikeIc, height: 30),
                  AppSizes.spaceW(10),
                  ConstText(
                    text: "Bike Fare Details",
                    color: context.textPrimary,
                    fontWeight: AppConstant.semiBold,
                    fontSize: AppConstant.fontSizeThree,
                  ),
                ],
              ),
              AppSizes.spaceH(20),

              // Total Fare
              _fareRow(context, "Total Estimate fare price including taxes", "₹$totalAmount",
                  isLarge: true),

              Divider(thickness: 0.3, color: context.greyMedium),

              _fareRow(context, "Ride Fare", "₹$totalAmount"),
              // AppSizes.spaceH(12),
              // _fareRow(context, "Surcharge", "₹40"),
              // AppSizes.spaceH(12),
              // _fareRow(context, "Discount", "₹40", color: context.success),

              AppSizes.spaceH(16),
              ConstText(
                text:
                "*Price may vary based on final pickup or drop location, time taken, final route and toll area.",
                fontSize: AppConstant.fontSizeZero,
                color: context.hintTextColor,
              ),
              AppSizes.spaceH(8),
              ConstText(
                text: "Waiting Charge after 3 mins of captain arrival is ₹1/min",
                fontSize: AppConstant.fontSizeZero,
                color: context.hintTextColor,
              ),
              AppSizes.spaceH(20),

              AppBtn(
                borderRadius:35,
                color: Colors.transparent,
                border: Border.all(color: context.black, width: 1),
                titleColor: context.black,
                title: "Got it",
                onTap: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _fareRow(BuildContext context, String title, String value,
      {bool isLarge = false, Color? color}) {
    return Row(
      children: [
        Expanded(
          child: ConstText(
            text: title,
            fontWeight: AppConstant.semiBold,
            maxLine: 1,
            color: color ?? context.textPrimary,
          ),
        ),
        AppSizes.spaceW(10),
        ConstText(
          text: value,
          fontWeight: AppConstant.semiBold,
          fontSize:
          isLarge ? AppConstant.fontSizeLarge : AppConstant.fontSizeThree,
          color: color ?? context.textPrimary,
        ),
      ],
    );
  }
}
