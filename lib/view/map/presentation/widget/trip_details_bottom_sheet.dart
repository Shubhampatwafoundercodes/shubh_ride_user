import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/generated/assets.dart';
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay_user/view/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_user/view/map/presentation/widget/cancel_reason_sheet_widget.dart';

class TripDetailsBottomSheet extends ConsumerWidget {
  const TripDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideState = ref.watch(rideNotifierProvider);
    final ride = rideState.currentRide;

    if (ride == null) {
      return Center(
        child: ConstText(text: "Loading ride details...", fontSize: 14.sp),
      );
    }

    final pickup = ride.pickupLocation;
    final drop = ride.dropLocation;

    return Container(
      // height: screenHeight*0.3,
      color: context.popupBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Details Title
          ConstText(
            text: "Location Details",
            fontSize: AppConstant.fontSizeTwo,
            fontWeight: AppConstant.semiBold,
            color: context.textPrimary,
          ),
          AppSizes.spaceH(8.h),

          // Pickup
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.green, size: 18.sp),
              AppSizes.spaceW(6),
              Expanded(
                child: ConstText(
                  text: pickup['address'] ?? "N/A",
                  fontSize: AppConstant.fontSizeZero,
                  maxLine: 2,
                  fontWeight: AppConstant.medium,
                ),
              ),
            ],
          ),
          AppSizes.spaceH(6.h),

          // Drop
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red, size: 18.sp),
              AppSizes.spaceW(6),
              Expanded(
                child: ConstText(
                  text: drop['address'] ?? "N/A",
                  fontWeight: AppConstant.medium,
                  fontSize: AppConstant.fontSizeZero,
                ),
              ),
            ],
          ),
          AppSizes.spaceH(15.h),

          // Fare
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstText(
                text: "Total fare",
                fontSize: 14.sp,
                fontWeight: AppConstant.semiBold,
              ),
              ConstText(
                text: "₹ ${ride.fare.toStringAsFixed(0)}",
                fontSize: 14.sp,
                fontWeight: AppConstant.bold,
              ),
            ],
          ),
          AppSizes.spaceH(4.h),

          // Optional Note
          // if (ride.discountCode != null)
          //   Row(
          //     children: [
          //       Icon(Icons.speaker_notes, color: context.success, size: 18.h),
          //       AppSizes.spaceW(10),
          //       ConstText(
          //         text: "{ride.discountCode} applied!",
          //         fontSize: 12.sp,
          //         color: context.success,
          //       ),
          //     ],
          //   ),

          Divider(thickness: 0.5, color: context.hintTextColor),
          AppSizes.spaceH(2.h),

          // Payment Info
          Row(
            children: [
              Image.asset(
                Assets.iconCash,
                height: 20.h,
                color: context.black,
              ),
              AppSizes.spaceW(8),
              ConstText(
                text: "Paying via ${ride.paymentMode ?? 'Cash'}",
                fontSize: AppConstant.fontSizeOne,
                fontWeight: AppConstant.semiBold,
                color: context.textSecondary,
              ),
            ],
          ),
          AppSizes.spaceH(25.h),

          // Cancel Ride Button (only if driver hasn't accepted)
          if (ride.status.toLowerCase() != "otp_verified" &&  ride.status.toLowerCase() != "completed" && ride.status.toLowerCase() != "cancelled" )
            AppBtn(
              title: "Cancel Ride",
              color: Colors.transparent,
              border: Border.all(color: context.error, width: 1.2),
              titleColor: context.error,
              margin: EdgeInsets.zero,
              onTap: () {

                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => CommonBottomSheet(
                    content: const CancelReasonSheet(),
                  ),
                );
              },
            ),
          AppSizes.spaceH(20.h),
        ],
      ),
    );
  }
}

