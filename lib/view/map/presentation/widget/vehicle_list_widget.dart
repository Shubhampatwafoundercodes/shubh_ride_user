import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/generated/assets.dart';
import 'package:rider_pay/res/app_btn.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/constant/common_network_img.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/res/format/date_time_formater.dart';
import 'package:rider_pay/view/home/presentation/drawer/profile/wallet_screen.dart';
import 'package:rider_pay/view/home/provider/provider.dart';
import 'package:rider_pay/view/map/presentation/controller/ride_flow_controller.dart' show rideFlowProvider, RideStep;
import 'package:rider_pay/view/map/presentation/widget/bike_fare_details.dart';
import 'package:rider_pay/view/map/provider/map_provider.dart';

class VehicleListWidget extends ConsumerWidget {
  const VehicleListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final vehicleState = ref.watch(vehicleTypeProvider);
    final mapState = ref.watch(mapControllerProvider);
    final rideController = ref.read(rideFlowProvider.notifier);
    final rideState = ref.watch(rideFlowProvider);

    final vehicles = vehicleState.vehicleTypeModelData?.data ?? [];

    if (vehicleState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vehicles.isEmpty) {
      return const Center(child: Text("No vehicles available"));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Vehicle list
        AppSizes.spaceH(8),
        ConstText(text: "You get cashback complete your ride cashback!",color: context.success,fontSize: AppConstant.fontSizeZero,fontWeight: AppConstant.semiBold,),
        Divider(thickness: 1,color: context.greyLight,),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.28,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              final  selectedIndex= rideState.selectedVehicleId;
              final isSelected = vehicle.id == selectedIndex;
              final fare = calculateFare(
                totalDistance:mapState.totalDistancePolyline??0 , baseFareStr:vehicle.baseFare.toString(), perKmRateStr: vehicle.perKmRate.toString(),
              );
              print("${mapState.totalDistancePolyline}");
              final baseDurationSec = mapState.routeDurationInSec ?? 0;
              final expectedSec = calculateVehicleDuration(baseDurationSec, vehicle.name ?? "");
              final expectedMin = (expectedSec / 60).round();
              final dropTime = DateTimeFormat.formatDropTime(expectedSec.toInt());

              final totalFare= double.parse(fare.toStringAsFixed(2)) ;
              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      // isDismissible: false,
                      // enableDrag: false,
                      builder: (context) {
                        return BikeFareDetails();
                      },
                    );
                  } else {
                    // onSelectVehicle(index);
                    rideController.selectVehicle(vehicle.id??-1,totalFare);
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.primary.withAlpha(10)
                        : context.greyLight.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? context.primary : Colors.transparent,
                      width: isSelected? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [

                      CommonNetworkImage(imageUrl: vehicle.icon
                      ,fit: BoxFit.contain,
                          height:isSelected?45.h: 40.h, width: isSelected?45.h: 40.h
                      ),


                      // Image.asset(vehicle.i, height:isSelected?45.h: 40.h, width: isSelected?45.h: 40.h),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ConstText(
                                  text: vehicle.name.toString(),
                                  fontWeight: AppConstant.semiBold,
                                  fontSize: AppConstant.fontSizeTwo,
                                  color: context.textPrimary,
                                ),
                                if (isSelected) ...[
                                  SizedBox(width: 6.w),
                                  Icon(
                                    Icons.person,
                                    size: 16,
                                    color: context.black,
                                  ),
                                  ConstText(
                                    text: " ${vehicle.capacity.toString()}",
                                    color: context.black,
                                    fontSize:AppConstant.fontSizeZero,
                                  ),
                                ],
                                if (vehicle.name=="Bike") ...[
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.success.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: ConstText(
                                      text: "FASTEST",
                                      fontSize: 10.sp,
                                      fontWeight: AppConstant.bold,
                                      color: context.success,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (vehicle.description != null)
                              ConstText(
                                text: vehicle.description.toString(),
                                fontSize:isSelected?AppConstant.fontSizeOne:AppConstant.fontSizeZero,
                                fontWeight: AppConstant.regular,
                              ),
                             ConstText(
                              text: "${isSelected ?"${vehicle.awayMinuts.toString()} away":""} Drop $dropTime",
                              fontSize: isSelected?AppConstant.fontSizeSmall:AppConstant.fontSizeSmall,
                              color: context.textSecondary,
                              fontWeight: AppConstant.semiBold,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ConstText(
                            text: fare.toStringAsFixed(2) ,//price
                            fontWeight: AppConstant.semiBold,
                            fontSize: isSelected?AppConstant.fontSizeTwo:AppConstant.fontSizeOne,
                            color: context.textPrimary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        AppSizes.spaceH(10),

        // Bottom container with shadow
        Container(
          padding: AppPadding.screenPaddingH,
          decoration: BoxDecoration(
            color: context.popupBackground,
            boxShadow: [
              BoxShadow(
                color: context.black.withAlpha(40),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, -3), // shadow top side
              ),
            ],
          ),
          child: Column(
            children: [
              AppSizes.spaceH(6.h),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: context.lightSkyBack,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.8,
                        child: const WalletDesignWidget(),
                      );
                    },
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.iconCash,
                      height: 25.h,
                      color: context.black,
                    ),
                    AppSizes.spaceW(10),
                    ConstText(
                      text: "Cash",
                      fontWeight: AppConstant.semiBold,
                      color: context.black,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15.h,
                      color: context.greyDark,
                    ),
                  ],
                ),
              ),
              AppSizes.spaceH(3.h),
              AppBtn(
                onTap: (){
                  if (rideState.selectedVehicleId != -1) {
                    ref.read(mapControllerProvider.notifier).enableConfirmingPickup();
                    rideController.goTo(RideStep.confirmPickupLocation);
                  }
                },
                margin: AppPadding.screenPaddingV,
                title: "Book Auto",
              ),
            ],
          ),
        ),
      ],
    );
  }
  double calculateFare({
    required  double totalDistance,
    required  String baseFareStr,
     required String perKmRateStr,}
      )
  {
    final distanceKm = totalDistance / 1000;

    final baseFare = double.tryParse(baseFareStr) ?? 0;
    final perKmRate = double.tryParse(perKmRateStr) ?? 0;

    return baseFare + (perKmRate * distanceKm);
  }
  double calculateVehicleDuration(int baseDurationSec, String vehicleName) {
    final name = vehicleName.toLowerCase();

    switch (name) {
      case "bike":
        return baseDurationSec * 0.8;
      case "auto":
        return baseDurationSec * 1.0;
      case "cab":
        return baseDurationSec * 1.2;
      case "e-rickshaw":
        return baseDurationSec * 2;
      case "cab premium":
        return baseDurationSec * 1.3;
      default:
        return baseDurationSec * 1.0;
    }
  }

}
