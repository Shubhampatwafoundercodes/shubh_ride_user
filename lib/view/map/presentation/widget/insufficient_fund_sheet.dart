import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';

class InsufficientFundsSheet extends StatelessWidget {
  const InsufficientFundsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        ConstText(
          text: "Insufficient Funds",
          fontSize: AppConstant.fontSizeThree,
          fontWeight: AppConstant.semiBold,
          color: context.textPrimary,
        ),
        AppSizes.spaceH(12.h),

        // Total fare row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstText(
              text: "Total fare",
              fontSize: AppConstant.fontSizeOne,
              color: context.textSecondary,
            ),
            ConstText(
              text: "₹12",
              fontSize: AppConstant.fontSizeOne,
              fontWeight: AppConstant.semiBold,
              color: context.textPrimary,
            ),
          ],
        ),
        AppSizes.spaceH(16.h),

        // Paying via
        ConstText(
          text: "PAYING VIA",
          fontSize: AppConstant.fontSizeZero,
          fontWeight: AppConstant.medium,
          color: context.textSecondary,
        ),
        AppSizes.spaceH(8.h),

        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: context.greyLight),
          ),
          child: Row(
            children: [
              const Icon(Icons.account_balance_wallet, color: Colors.black54),
              AppSizes.spaceW(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstText(
                      text: "Rapido Wallet",
                      fontSize: AppConstant.fontSizeOne,
                      fontWeight: AppConstant.medium,
                      color: context.textPrimary,
                    ),
                    ConstText(
                      text: "Low Balance: ₹0",
                      fontSize: AppConstant.fontSizeZero,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Change payment method
                },
                child: ConstText(
                  text: "Change",
                  fontSize: AppConstant.fontSizeZero,
                  color: context.primary,
                  fontWeight: AppConstant.medium,
                ),
              )
            ],
          ),
        ),

        AppSizes.spaceH(20.h),

        AppBtn(
          title: "Recharge Wallet & Pay",
          onTap: () {
            // TODO: Recharge
          },
        ),
        AppSizes.spaceH(12.h),

        AppBtn(
          title: "Pay remaining ₹12 at drop",
          color: Colors.yellow.shade700,
          titleColor: Colors.black,
          onTap: () {

          },
        ),
      ],
    );
  }
}
