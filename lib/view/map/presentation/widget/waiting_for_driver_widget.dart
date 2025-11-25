import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/generated/assets.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/main.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay_user/res/constant/const_pop_up.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/res/constant/smooth_progress_indicator.dart'
    show SmoothProgressIndicator;
import 'package:rider_pay_user/utils/routes/routes_name.dart';

import 'package:rider_pay_user/view/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_user/view/home/provider/provider.dart'
    show rideBookingProvider;
import 'package:rider_pay_user/view/map/presentation/controller/ride_flow_controller.dart'
    show rideFlowProvider, RideStep;
import 'package:rider_pay_user/view/map/presentation/widget/after_driver_accept_section_widget.dart';
import 'package:rider_pay_user/view/map/presentation/widget/requested_drivers_list_widget.dart';
import 'package:rider_pay_user/view/map/presentation/widget/trip_details_bottom_sheet.dart'
    show TripDetailsBottomSheet;
import 'package:rider_pay_user/view/map/provider/map_provider.dart';

class WaitingForDriverWidget extends ConsumerStatefulWidget {
  const WaitingForDriverWidget({super.key});
  @override
  ConsumerState<WaitingForDriverWidget> createState() =>
      _WaitingForDriverWidgetState();
}

class _WaitingForDriverWidgetState
    extends ConsumerState<WaitingForDriverWidget> {
  bool _dialogShown = false;

  @override
  void dispose() {
    _dialogShown = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t=AppLocalizations.of(context)!;
    final rideState = ref.watch(rideNotifierProvider);
    final ride = rideState.currentRide;

    if (ride == null) {
      return const Center(child: SizedBox.shrink());
    }

    final pickup = ride.pickupLocation;
    final driverData = ride.requestedDrivers.isNotEmpty
        ? ride.requestedDrivers.first
        : null;
    final driverLocation = driverData?["location"];
    final driverLat = driverLocation?['latitude'];
    final driverLng = driverLocation?['longitude'];

    final pickupLat = pickup['lat'];
    final pickupLng = pickup['lng'];

    Map<String, dynamic> result = {};
    if (driverLat != null &&
        driverLng != null &&
        pickupLat != null &&
        pickupLng != null) {
      result = calculateDistanceAndETA(
        driverLat: driverLat,
        driverLng: driverLng,
        pickupLat: pickupLat,
        pickupLng: pickupLng,
      );
    }

    final distanceKm = result['distanceKm'];
    final etaMinutes = result['etaMinutes'];

    // final statusText = _getRideStatusText(ride.statusText, distanceKm, etaMinutes);
    final isRideFinished = ride.status.toString().toUpperCase() == "COMPLETED" || ride.statusText.toString().toUpperCase() == "CANCELLED";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dialogShown) return;
      if (isRideFinished) {
        _dialogShown = true;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) _showRideCompleteDialog(context, ref,t);
        });
        return;
      }

      // if (ride.paymentStatus == "processing" && ride.paymentMode?.toLowerCase() == "online") {
      //   _dialogShown = true;
      //   _showPaymentBottomSheet(ride);
      // }
    });

    return Container(
      color: context.lightSkyBack,
      height: screenHeight * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstText(
                              text: (ride.requestedDrivers.isEmpty
                                  ? t.searchingDriver
                                  : t.driverFound),
                              fontSize: AppConstant.fontSizeSmall,
                              color: context.hintTextColor,
                              fontWeight: AppConstant.semiBold,
                            ),
                            ConstText(
                              text: ride.acceptedByDriver
                                  ? (ride.statusText?.toLowerCase() ==
                                            "arrived drop"
                                        ? t.pleaseConfirmPayment
                                        : ride.statusText?.toLowerCase() ==
                                              "otp verified"
                                        ?t.rideInProgress
                                        : ride.statusText?.toLowerCase() ==
                                              "arrived pickup"
                                        ? t.driverArrivedPickup
                                        : t.driverOnTheWay)
                                  :t.waitingDriverResponse,
                              fontSize: AppConstant.fontSizeOne,
                              color: context.textPrimary,
                            ),
                            if (ride.acceptedByDriver)
                              _buildRideStatus(
                                ride.statusText,
                                distanceKm,
                                etaMinutes,
                              ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isRideFinished) {
                            try {
                              final mapNot = ref.read(
                                mapNotifierProvider.notifier,
                              );
                              final mapCon = ref.read(
                                mapControllerProvider.notifier,
                              );
                              mapCon.clearTemporaryState();
                              final rideFlow = ref.read(
                                rideFlowProvider.notifier,
                              );
                              final rideNotifier = ref.read(
                                rideNotifierProvider.notifier,
                              );
                              rideNotifier.stopListening();
                              mapNot.resetPlaceDetails();
                              mapNot.resetSearchPlacesData();
                              rideFlow.goTo(RideStep.vehicleList);
                              if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteName.home,
                                  (route) => false,
                                );
                              }

                            } catch (e, st) {
                              debugPrint("❌ Error finishing ride: $e");
                            }
                          } else {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (_) => CommonBottomSheet(
                                title: t.tripDetails,
                                content: const TripDetailsBottomSheet(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isRideFinished ? Colors.red : Colors.blue,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: ConstText(
                            text: isRideFinished
                                ? t.rideCompleted
                                : t.tripDetails,
                            fontSize: AppConstant.fontSizeSmall,
                            fontWeight: AppConstant.semiBold,
                            color: isRideFinished ? context.error : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppSizes.spaceH(10),
                if (!ride.acceptedByDriver)
                  SmoothProgressIndicator(
                    totalMinutes: 5,
                    totalSegments: 4,
                    onCompleted: () {
                      print("Progress Completed!");
                      final mapNot = ref.read(mapNotifierProvider.notifier);
                      final mapCon = ref.read(mapControllerProvider.notifier);
                      final rideRepo = ref.read(rideRepoProvider);
                      final rideFlow = ref.read(rideFlowProvider.notifier);
                      final rideNotifier = ref.read(
                        rideNotifierProvider.notifier,
                      );
                      final rideId = ref.read(rideBookingProvider).rideId;
                      if (rideId != null) {
                        rideNotifier.cancelRideAndStopListening(rideId);
                        rideRepo.deleteRide(rideId);
                        print("Ride document deleted from Firestore: $rideId");
                      } else {
                        print("rideId is empty, skipping Firestore delete");
                      }
                      rideNotifier.stopListening();
                      mapCon.clearTemporaryState();
                      mapNot.resetPlaceDetails();
                      mapNot.resetSearchPlacesData();
                      rideFlow.goTo(RideStep.vehicleList);
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, RouteName.home);
                      }
                      print(
                        "✅ Ride cancelled & Firestore doc deleted successfully.",
                      );
                    },
                  ),
              ],
            ),
          ),

          AppSizes.spaceH(10),

          if (ride.acceptedByDriver)
            Expanded(
              child: DriverAcceptedSection(
                driverData: Map<String, dynamic>.from(
                  ride.requestedDrivers.isNotEmpty
                      ? ride.requestedDrivers.first
                      : {},
                ),
                pickupLocation: Map<String, dynamic>.from(ride.pickupLocation),
                dropLocation: Map<String, dynamic>.from(ride.dropLocation),
                otp: ride.otp?.toString() ?? "----",
                statusText: ride.statusText?.toString() ?? "----",
                paymentMode: ride.paymentMode,
                paymentStatus: ride.paymentStatus,
                fare: ride.fare,
                rideId: ride.rideId,
                status: ride.status,
              ),
            )
          else
            Expanded(
              child: RequestedDriversList(
                rideId: ride.rideId,
                requestedDrivers: List<Map<String, dynamic>>.from(
                  ride.requestedDrivers,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showRideCompleteDialog(BuildContext context, WidgetRef ref,AppLocalizations t) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () async => false,
          child: ConstPopUp(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.green, size: 70),
                const SizedBox(height: 16),
                ConstText(text: t.rideCompleted),
                const SizedBox(height: 8),
                ConstText(
                  text: t.tripCompletedMsg,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final mapNot = ref.read(mapNotifierProvider.notifier);
                      final rideFlow = ref.read(rideFlowProvider.notifier);
                      final rideNotifier = ref.read(rideNotifierProvider.notifier,);
                      final mapCon = ref.read(mapControllerProvider.notifier);
                      mapCon.clearTemporaryState();
                      rideNotifier.stopListening();
                      mapNot.resetPlaceDetails();
                      mapNot.resetSearchPlacesData();
                      rideFlow.clearAll();
                      rideFlow.forceStep(RideStep.vehicleList);
                      if (context.mounted) {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop(); // close dialog
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteName.home,
                          (Route<dynamic> route) => false,
                        );
                      }
                      print("✅ Ride completed popup closed & reset done.");
                    } catch (e) {
                      print("❌ Error in completing ride: $e");
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    child: ConstText(text: "OK"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRideStatus(String? status, double? distanceKm, int? etaMin) {
    final normalizedStatus = (status ?? "").trim().toLowerCase();

    Color bgColor = Colors.grey.shade200;
    Color textColor = Colors.black;
    String displayText = '';

    switch (normalizedStatus) {
      case 'searching':
        displayText = 'Searching for a nearby driver...';
        bgColor = Colors.yellow.shade100;
        textColor = Colors.orange.shade800;
        break;

      case 'start':
      case 'start ride':
      case 'started':
        if (distanceKm != null && etaMin != null) {
          displayText =
              'Driver is ${distanceKm.toStringAsFixed(1)} km away (~$etaMin min)';
        } else {
          displayText = 'Driver is on the way to pickup';
        }
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade900;
        break;

      case 'arrived pickup':
      case 'arrived at pickup':
        displayText = 'Driver has arrived at your pickup location';
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        break;

      case 'otp verified':
      case 'otp_verified':
        displayText = 'Ride started — Sit back and relax!';
        bgColor = Colors.teal.shade100;
        textColor = Colors.teal.shade900;
        break;

      case 'arrived drop':
      case 'arrived_drop':
        displayText = 'Driver has reached your destination';
        bgColor = Colors.indigo.shade100;
        textColor = Colors.indigo.shade900;
        break;

      case 'complete ride':
      case 'completed':
        displayText = 'Ride completed — Thank you for riding with us!';
        bgColor = Colors.grey.shade300;
        textColor = Colors.black;
        break;

      case 'cancelled':
        displayText = 'Ride cancelled';
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
        break;

      default:
        displayText = 'Waiting for driver confirmation...';
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ConstText(
        text: displayText,
        fontSize: AppConstant.fontSizeOne,
        color: textColor,
      ),
    );
  }

  /// 🔹 Function to calculate distance (in km) and ETA (in minutes)
  Map<String, dynamic> calculateDistanceAndETA({
    required dynamic driverLat,
    required dynamic driverLng,
    required dynamic pickupLat,
    required dynamic pickupLng,
  }) {
    try {
      final dLat = double.tryParse(driverLat?.toString() ?? '');
      final dLng = double.tryParse(driverLng?.toString() ?? '');
      final pLat = double.tryParse(pickupLat?.toString() ?? '');
      final pLng = double.tryParse(pickupLng?.toString() ?? '');

      if (dLat == null || dLng == null || pLat == null || pLng == null) {
        print("⚠️ Missing coordinates for distance calc");
        return {'distanceKm': null, 'etaMinutes': null};
      }
      const R = 6371;
      final dLatRad = _deg2rad(dLat - pLat);
      final dLonRad = _deg2rad(dLng - pLng);
      final a =
          sin(dLatRad / 2) * sin(dLatRad / 2) +
          cos(_deg2rad(pLat)) *
              cos(_deg2rad(dLat)) *
              sin(dLonRad / 2) *
              sin(dLonRad / 2);
      final c = 2 * atan2(sqrt(a), sqrt(1 - a));
      final distanceKm = R * c;

      const avgSpeedKmh = 30; // Rough average
      final etaMinutes = (distanceKm / avgSpeedKmh * 60).ceil();

      print("📍 Distance: ${distanceKm.toStringAsFixed(2)} km, ETA: $etaMinutes min",);

      return {'distanceKm': distanceKm, 'etaMinutes': etaMinutes};
    } catch (e) {
      print("❌ Error calculating distance/ETA: $e");
      return {'distanceKm': null, 'etaMinutes': null};
    }
  }

  double _deg2rad(double deg) => deg * (pi / 180);
}
