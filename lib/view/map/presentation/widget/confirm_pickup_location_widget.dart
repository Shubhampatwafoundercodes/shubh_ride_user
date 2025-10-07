import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/main.dart';
import 'package:rider_pay/res/app_btn.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/utils/utils.dart';
import 'package:rider_pay/view/home/provider/provider.dart' show reasonOfCancelProvider, rideBookingProvider;
import 'package:rider_pay/view/map/presentation/controller/ride_flow_controller.dart';
import 'package:rider_pay/view/map/provider/map_provider.dart';
import 'package:rider_pay/view/share_pref/user_provider.dart';

class ConfirmPickupWidget extends ConsumerWidget {
  const ConfirmPickupWidget({super.key});

  @override
  Widget build(BuildContext context ,WidgetRef ref) {
    final rideState = ref.watch(rideBookingProvider);
    final mapCon = ref.watch(mapControllerProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: AppPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstText(
                text: "Double Check your pickup point",
                fontSize: AppConstant.fontSizeThree,
                fontWeight: AppConstant.bold,
                color: context.black,
              ),
              AppSizes.spaceH(4.h),
              ConstText(
                text: "Select a nearby point for easier pickup",
                fontSize: AppConstant.fontSizeTwo,
                color: context.greyDark,
              ),
              AppSizes.spaceH(15.h),
              // Pickup location input
              Container(
                width: screenWidth,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: context.greyLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.success,width: 1.5),
                ),
                child: mapCon.isLocationLoading?
                    SizedBox.shrink():
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstText(
                      text: mapCon.draggablePickupAddress?.split(RegExp(r'[,/]'))[0] ?? "",
                      fontSize: 13.sp,
                      color: context.black,
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    ConstText(
                      text: mapCon.draggablePickupAddress != null
                          ? mapCon.draggablePickupAddress!
                          .split(RegExp(r'[,/]'))
                          .skip(1)
                          .join(", ")
                          .trim()
                          : "",
                      fontSize: 13.sp,
                      color: context.black,
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),



              ),
              // AppSizes.spaceH(12.h),
              // ConstText(
              //   text: "Save location as",
              //   fontSize: 12.sp,
              //   color: context.greyDark,
              // ),
              // AppSizes.spaceH(6.h),
              // Row(
              //   children: [
              //     _LocationButton(label: "Home"),
              //     AppSizes.spaceW(6.w),
              //     _LocationButton(label: "Gym"),
              //     AppSizes.spaceW(6.w),
              //     _LocationButton(label: "+ Add New"),
              //   ],
              // ),
            ],
          ),
        ),

        Container(
          padding: AppPadding.screenPadding,
          decoration: BoxDecoration(
            color: context.popupBackground,
            boxShadow: [
              BoxShadow(
                color: context.black.withAlpha(40),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: AppBtn(
            title: "Confirm pickup",
            loading: rideState.isLoading ,
            onTap : rideState.isLoading? null: ()   async{
              final rideController = ref.read(rideFlowProvider.notifier);
              final mapCtrl = ref.read(mapControllerProvider.notifier);
              final rideFlowState = ref.read(rideFlowProvider);
              final userId=ref.read(userProvider)?.id.toString();
              final totalDistance = (mapCon.totalDistancePolyline ?? 0) / 1000;
              mapCtrl.confirmNewPickupLocation();
              final payload = {
                "user_id": userId,
                "pickup_address":mapCon.pickupAddress,
                "pickup_lat": mapCon.pickupLocation?.latitude??0,
                "pickup_lng": mapCon.pickupLocation?.longitude??0,
                "drop_address": mapCon.destinationAddress??"",
                "drop_lat":mapCon.destinationLocation?.latitude??0,
                "drop_lng":mapCon.destinationLocation?.longitude??0,
                "vehicle_type_id": rideFlowState.selectedVehicleId,
                "distance_km": totalDistance,
                "estimated_fare":rideFlowState.selectedFare
              };

              await ref.read(rideBookingProvider.notifier).bookRide(payload);
              if (rideState.rideId != null) {
                toastMsg("Ride booked successfully!");
                print("Ride ID: ${rideState.rideId!}");
                // if (center != null) {
                //   final address = await mapCtrl.getAddressFromLatLng(center);
                //   await mapCtrl.confirmPickup(center, address);
                //   // rideController.goTo(RideStep.waitingForDriver);
                // }
                ref.read(reasonOfCancelProvider.notifier).loadReasonsApi();
                rideController.goTo(RideStep.waitingForDriver);
              }

            },
          ),
        ),
      ],
    );
  }
}

// class _LocationButton extends StatelessWidget {
//   final String label;
//   const _LocationButton({required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         height: 36.h,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: context.greyLight,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: context.greyMedium),
//         ),
//         child: ConstText(
//           text: label,
//           fontSize: 12.sp,
//           color: context.black,
//           fontWeight: AppConstant.semiBold,
//         ),
//       ),
//     );
//   }
// }
