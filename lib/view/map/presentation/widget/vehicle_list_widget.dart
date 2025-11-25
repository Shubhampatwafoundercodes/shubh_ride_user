import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/common_network_img.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/res/format/date_time_formater.dart';
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/firebase_service/ride/data/model/ride_booking_model.dart';
import 'package:rider_pay_user/view/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_user/view/home/presentation/drawer/profile/wallet_screen.dart';
import 'package:rider_pay_user/view/home/provider/provider.dart';
import 'package:rider_pay_user/view/map/presentation/controller/ride_flow_controller.dart' show rideFlowProvider, RideStep;
import 'package:rider_pay_user/view/map/presentation/widget/bike_fare_details.dart';
import 'package:rider_pay_user/view/map/provider/map_provider.dart';
import 'package:rider_pay_user/view/share_pref/user_provider.dart';

class VehicleListWidget extends ConsumerStatefulWidget {
  const VehicleListWidget({super.key});
  @override
  ConsumerState<VehicleListWidget> createState() => _VehicleListWidgetState();
}

class _VehicleListWidgetState extends ConsumerState<VehicleListWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rideFlowProvider.notifier).clearAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t=AppLocalizations.of(context)!;
    final vehicleState = ref.watch(vehicleTypeProvider);
    final mapState = ref.watch(mapControllerProvider);
    final rideController = ref.read(rideFlowProvider.notifier);
    final rideState = ref.watch(rideFlowProvider);
    final rideBookState = ref.watch(rideBookingProvider);
    final profileN = ref.read(profileProvider.notifier);
    final rideNotifier = ref.read(rideNotifierProvider.notifier);

    final vehicles = vehicleState.vehicleTypeModelData?.data ?? [];

    if (vehicleState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vehicles.isEmpty) {
      return  Center(child: ConstText(text: t.noVehicle));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
       AppSizes.spaceH(8),
        ConstText(
          text: t.cashbackMsg,
          color: context.success,
          fontSize: AppConstant.fontSizeZero,
          fontWeight: AppConstant.semiBold,
        ),
        Divider(thickness: 1, color: context.greyLight),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.28,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              final selectedId = rideState.selectedVehicleId;
              final isSelected = vehicle.id == selectedId;
              final fare = calculateFare(
                totalDistance: mapState.totalDistancePolyline ?? 0,
                baseFareStr: vehicle.baseFare.toString(),
                perKmRateStr: vehicle.perKmRate.toString(),
              );
              final totalFare = double.parse(fare.toStringAsFixed(2));
              final baseDurationSec = mapState.routeDurationInSec ?? 0;
              final expectedSec = calculateVehicleDuration(
                baseDurationSec,
                vehicle.name ?? "",
              );
              final expectedMin = (expectedSec / 60).round();
              final dropTime = DateTimeFormat.formatDropTime(
                expectedSec.toInt(),
              );
              return GestureDetector(
                onTap: () {
                  rideController.selectVehicle(
                    vehicle.id ?? 1,
                    fare: totalFare,
                  );


                  if (isSelected) {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return BikeFareDetails(
                          totalAmount: totalFare.toString(),
                        );
                      },
                    );
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
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CommonNetworkImage(
                        imageUrl: vehicle.icon,
                        fit: BoxFit.contain,
                        height: isSelected ? 45.h : 40.h,
                        width: isSelected ? 45.h : 40.h,
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
                                    fontSize: AppConstant.fontSizeZero,
                                  ),
                                ],
                                if (vehicle.name == "Bike") ...[
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.success.withAlpha(20),
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
                                fontSize: isSelected
                                    ? AppConstant.fontSizeOne
                                    : AppConstant.fontSizeZero,
                                fontWeight: AppConstant.regular,
                              ),
                            ConstText(
                              text:
                                  "${isSelected ? "${vehicle.awayMinuts.toString()} away" : ""} Drop $dropTime",
                              fontSize: isSelected
                                  ? AppConstant.fontSizeSmall
                                  : AppConstant.fontSizeSmall,
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
                            text: "₹${totalFare.toString()}",
                            fontWeight: AppConstant.semiBold,
                            fontSize: isSelected
                                ? AppConstant.fontSizeTwo
                                : AppConstant.fontSizeOne,
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
              AppSizes.spaceH(8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _paymentOption(context, t.cash),
                  AppSizes.spaceW(15),
                  _paymentOption(context, t.online),
                ],
              ),
              AppSizes.spaceH(7.h),
              AppBtn(
                margin:EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom ,),
                title: t.bookRide,
                loading:
                    rideBookState.isLoading ||
                    ref.watch(rideNotifierProvider).isLoading,
                color: rideState.selectedVehicleId == -1
                    ? context.hintTextColor
                    : context.primary,

                onTap:
                    (rideBookState.isLoading ||
                        ref.watch(rideNotifierProvider).isLoading ||
                        rideState.selectedVehicleId == -1)
                    ? null
                    : () async {
                        final walletAmount = ref
                            .read(walletProvider.notifier)
                            .walletAmount;
                        final totalFare = rideState.selectedFare ?? 0.0;
                        if (rideState.selectedPaymentMethod == "Online" &&
                            walletAmount < totalFare) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: context.lightSkyBack,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 0.8,
                                child: const WalletDesignWidget(),
                              );
                            },
                          );
                          return;
                        }
                        final pickupLat = LatLng(
                          mapState.pickupLocation?.latitude ?? 0,
                          mapState.pickupLocation?.longitude ?? 0,
                        );
                        final getPickupAddress = await ref.read(mapControllerProvider.notifier).getAddressFromLatLng(pickupLat);
                        final userId = ref.read(userProvider.notifier).userId.toString();
                        final totalDistance = (mapState.totalDistancePolyline ?? 0) / 1000;
                        // mapCtrl.confirmNewPickupLocation();
                        final payload = {
                          "user_id": userId,
                          "pickup_address": getPickupAddress.toString(),
                          "pickup_lat": pickupLat.latitude,
                          "pickup_lng": pickupLat.longitude,
                          "drop_address": mapState.destinationAddress ?? "",
                          "drop_lat":
                              mapState.destinationLocation?.latitude ?? 0,
                          "drop_lng":
                              mapState.destinationLocation?.longitude ?? 0,
                          "vehicle_type_id": rideState.selectedVehicleId,
                          "distance_km": totalDistance,
                          "estimated_fare": totalFare,
                        };
                        final rideIds = await ref.read(rideBookingProvider.notifier).bookRide(payload);
                        print("is success: $rideIds");
                        if (rideIds != null) {
                          toastMsg("Ride booked successfully!");
                          final firebaseRide = RideBookingModel(
                            rideId: rideIds,
                            userId: userId,
                            driverId: "",
                            vehicleType: rideState.selectedVehicleId,
                            pickupLocation: {
                              "lat": pickupLat.latitude,
                              "lng": pickupLat.longitude,
                              "address": getPickupAddress.toString(),
                            },
                            dropLocation: {
                              "lat": mapState.destinationLocation?.latitude,
                              "lng": mapState.destinationLocation?.longitude,
                              "address": mapState.destinationAddress,
                            },
                            distanceKm: totalDistance,
                            fare: totalFare,
                            status: "pending",
                            otp: profileN.otp,
                            statusText: "Searching",
                            requestedDrivers: [],
                            rejectedDrivers: [],
                            userNumber: profileN.phone,
                            paymentMode: rideState.selectedPaymentMethod,
                            paymentStatus: "waiting",
                            // bookedAt: DateTime.timestamp(),
                          );
                          print("total distance: aa- $totalDistance");
                          await rideNotifier.bookRideAndListen(firebaseRide);
                          rideNotifier.stopListeningDrivers();
                          rideController.goTo(RideStep.waitingForDriver);
                        } else {
                          toastMsg("Some thing went Wrong Please try again later",);
                        }
                      },
              ),
              AppSizes.spaceH(10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentOption(BuildContext context, String title) {
    final selected = ref.watch(rideFlowProvider).selectedPaymentMethod;
    final isSelected = selected == title;
    return GestureDetector(
      onTap: () => ref.read(rideFlowProvider.notifier).selectPayment(title),
      child: Row(
        children: [
          Container(
            height: 18,
            width: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? context.primary : Colors.transparent,
              border: Border.all(
                color: isSelected ? Colors.transparent : context.hintTextColor,
              ),
            ),
            child: isSelected
                ? Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.white,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          SizedBox(width: 10.h),
          ConstText(
            text: title,
            fontSize: AppConstant.fontSizeTwo,
            color: context.textPrimary,
          ),
        ],
      ),
    );
  }

  double calculateFare({
    required double totalDistance,
    required String baseFareStr,
    required String perKmRateStr,
  })
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
