import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/generated/assets.dart';
import 'package:rider_pay/res/app_btn.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/res/constant/smooth_progress_indicator.dart' show SmoothProgressIndicator;
import 'package:rider_pay/view/home/provider/provider.dart';
import 'package:rider_pay/view/map/presentation/widget/cancel_reason_sheet_widget.dart';
import 'package:rider_pay/view/map/presentation/widget/insufficient_fund_sheet.dart';
class WaitingForDriverWidget extends ConsumerStatefulWidget {
  const WaitingForDriverWidget({super.key});

  @override
  ConsumerState<WaitingForDriverWidget> createState() => _WaitingForDriverWidgetState();
}

class _WaitingForDriverWidgetState extends ConsumerState<WaitingForDriverWidget> {

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      // ref.read(reasonOfCancelProvider.notifier).loadReasonsApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.lightSkyBack,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // Header
          Container(
            color: context.popupBackground,
            padding: AppPadding.screenPadding,
            child: Column(
              children: [
                AppSizes.spaceH(10),

                Padding(
                  padding: AppPadding.screenPaddingH,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(Assets.iconBikeIc, height: 40.h),
                      AppSizes.spaceW(20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstText(
                            text: "Looking for ",
                            fontSize:AppConstant.fontSizeSmall,
                            color: context.hintTextColor,
                            fontWeight: AppConstant.semiBold,
                          ),
                          ConstText(
                            text: "Bike Lite ride",
                            fontWeight: AppConstant.semiBold,
                            fontSize:AppConstant.fontSizeThree,
                            color: context.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AppSizes.spaceH(10),
                SmoothProgressIndicator(
                  totalMinutes: 4,
                  totalSegments: 4,
                  onCompleted: () {
                    print("Progress Completed!");
                  },
                ),
              ],
            ),
          ),
            AppSizes.spaceH(10),
          // Pickup - Drop details (sample UI)
          Container(
            padding: AppPadding.screenPadding,
            decoration: BoxDecoration(
              color: context.popupBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstText(
                  text: "Location Details",
                  fontSize: AppConstant.fontSizeTwo,
                  fontWeight: AppConstant.semiBold,
                  color: context.textPrimary,
                ),
                AppSizes.spaceH(8.h),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green, size: 18.sp),
                    AppSizes.spaceW(6),
                    Expanded(
                      child: ConstText(
                        text: "57, Jankipuram Extension, Lucknow",
                        fontSize: AppConstant.fontSizeZero,
                        maxLine: 2,
                        fontWeight: AppConstant.medium,
                      ),
                    ),
                  ],
                ),
                AppSizes.spaceH(6.h),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 18.sp),
                    AppSizes.spaceW(6),
                    Expanded(
                      child: ConstText(
                        text: "6/1043, Khargapur Jagir, Lucknow",
                        fontWeight: AppConstant.medium,
                        fontSize: AppConstant.fontSizeZero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          AppSizes.spaceH(10),

          // Fare
          Container(
            padding: AppPadding.screenPadding,
            color: context.popupBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConstText(
                      text: "Total fare",
                      fontSize: 14.sp,
                      fontWeight: AppConstant.semiBold,
                    ),
                    ConstText(
                      text: "₹ 120",
                      fontSize: 14.sp,
                      fontWeight: AppConstant.bold,
                    ),
                  ],
                ),
                AppSizes.spaceH(4.h),
                Row(
                  children: [
                    Icon(Icons.speaker_notes,color: context.success,size: 18.h,),
                    AppSizes.spaceW(10),
                    ConstText(
                      text: "FIRST50 applied!",
                      fontSize: 12.sp,
                      color: context.success,
                    ),
                  ],
                ),
                Divider(thickness: 0.5,color: context.hintTextColor,),
                AppSizes.spaceH(2.h),
                 Row(
                  children: [
                    Image.asset(Assets.iconCash,height: 20.h,color: context.black,),
                    // Icon(Icons.payments, color: context.black, size: 20.sp),
                    AppSizes.spaceW(8),
                    GestureDetector(
                      onTap: (){
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          // shape: const RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          // ),
                          builder: (_) => CommonBottomSheet(content: const InsufficientFundsSheet()),
                        );
                      },
                      child: ConstText(
                        text: "Paying via Cash",
                        fontSize: AppConstant.fontSizeOne,
                        fontWeight: AppConstant.semiBold,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),




          AppSizes.spaceH(15.h),

          // Cancel Button
          Container(
            color: context.popupBackground,
            child: AppBtn(
              title: "Cancel Ride",
              color: Colors.transparent,
              border: Border.all(color: context.error, width: 1.2),
              titleColor: context.error,
              margin: AppPadding.screenPadding,
              onTap: (){
                ref.read(reasonOfCancelProvider.notifier).loadReasonsApi();

                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  // shape: const RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  // ),
                  builder: (_) => CommonBottomSheet(content: const CancelReasonSheet()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
