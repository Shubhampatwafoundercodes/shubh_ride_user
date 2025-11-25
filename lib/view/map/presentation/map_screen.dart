import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay_user/main.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/constant/const_pop_up.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/res/constant/const_text_btn.dart';
import 'package:rider_pay_user/theme/theme_controller.dart';
import 'package:rider_pay_user/utils/routes/routes_name.dart';
import 'package:rider_pay_user/view/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_user/view/home/provider/provider.dart';
import 'package:rider_pay_user/view/map/presentation/controller/state/map_state.dart';
import 'package:rider_pay_user/view/map/presentation/widget/vehicle_list_widget.dart';
import 'package:rider_pay_user/view/map/presentation/widget/waiting_for_driver_widget.dart';
import 'package:rider_pay_user/view/map/provider/map_provider.dart';
import 'controller/ride_flow_controller.dart' show rideFlowProvider, RideStep;

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  static const LatLng _defaultLocation = LatLng(28.6139, 77.2090);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final mapN = ref.read(mapControllerProvider.notifier);
      final rideNotifier = ref.read(rideNotifierProvider.notifier);
      ref.read(reasonOfCancelProvider.notifier).loadReasonsApi();
      final mapState = ref.read(mapControllerProvider);
      if (mapState.pickupLocation == null) {
        await mapN.fetchCurrentLocation(type: LocationType.pickup);
      }
      final pickup = mapState.pickupLocation;
      if (pickup != null) {
        await mapN.moveCamera(pickup.latitude, pickup.longitude, 16);
        rideNotifier.listenToNearbyDriverVehicleLocation(
          LatLng(pickup.latitude, pickup.longitude),
        );
      }
      if (mapState.pickupLocation != null &&
          mapState.destinationLocation != null) {
        final pickup = LatLng(
          mapState.pickupLocation?.latitude ?? 0,
          mapState.pickupLocation?.longitude ?? 0,
        );
        final destination = LatLng(
          mapState.destinationLocation?.latitude ?? 0,
          mapState.destinationLocation?.longitude ?? 0,
        );
        mapN.drawRoute(pickup, destination);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapControllerProvider);
    final mapCon = ref.watch(mapControllerProvider.notifier);
    final rideNotifier = ref.read(rideNotifierProvider.notifier);

    final rideState = ref.watch(rideFlowProvider);
    final rideFlowCtrl = ref.watch(rideFlowProvider.notifier);
    final currentStep = rideState.currentStep;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        final controller = ref.read(rideFlowProvider.notifier);
        // if (rideState.currentStep == RideStep.confirmPickupLocation) {
        //   await mapCon.cancelPickupConfirmation();
        //   controller.back();
        //   return false;
        // }


        if (rideState.steps.length > 1) {
          if (currentStep == RideStep.waitingForDriver) {
            final shouldExit = await _showExitConfirmationPopUp();
            if (shouldExit == true) {
              rideNotifier.stopListeningDrivers();
              mapCon.clearTemporaryState();
              SystemNavigator.pop();
            }
            return false;

          }
          controller.back();
          return false;
        } else {
          final mapNot = ref.read(mapNotifierProvider.notifier);
          mapNot.resetPlaceDetails();
          mapNot.resetSearchPlacesData();
          mapCon.clearTemporaryState();
        }
        rideFlowCtrl.forceStep(RideStep.vehicleList);
        rideFlowCtrl.clearAll();

        rideNotifier.stopListeningDrivers();

        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(RouteName.home, (route) => false);
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.4),
              child: GoogleMap(
                key: ValueKey(state.mapStyle),
                initialCameraPosition: CameraPosition(
                  target: state.pickupLocation ?? _defaultLocation,
                  zoom: 14,
                ),
                markers: state.markers,
                myLocationEnabled: true,
                rotateGesturesEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                tiltGesturesEnabled: false,
                mapType: MapType.normal,
                polylines: state.polyline,
                zoomGesturesEnabled: !state.isConfirmingPickup,
                // scrollGesturesEnabled: !state.isConfirmingPickup,
                // style: state.mapStyle,
                onMapCreated: (controller) {
                  final mapCtrl = ref.read(mapControllerProvider.notifier);
                  if (!mapCtrl.completer.isCompleted) {
                    mapCtrl.completer.complete(controller);
                  }

                  Future.delayed(const Duration(milliseconds: 500), () async {
                    final theme = ref.read(themeModeProvider);
                    await mapCtrl.updateMapStyle(theme);
                    await mapCtrl.moveCamera(
                      state.pickupLocation?.latitude ?? 0,
                      state.pickupLocation?.longitude ?? 0,
                      14,
                    );
                  });
                },
                // onCameraMove: (pos) {
                //   // mapCon.
                //   if (state.isConfirmingPickup) {
                //     mapCon.updateDraggableLatLng(pos.target);
                //   }
                // },
                // onCameraIdle: () async {
                //   if (state.isConfirmingPickup) {
                //     if (state.draggablePickupLocation != null) {
                //       final center = state.destinationLocation!;
                //       await mapCon.updateDraggableLocationAddressPolyline(center);
                //     }
                //   }
                // },
              ),
            ),
            if (state.isConfirmingPickup)
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.25,
                  ),
                  child: Icon(Icons.location_pin, size: 40, color: Colors.red),
                ),
              ),

            // Positioned(
            //   top: screenHeight * 0.35,
            //   right: 16,
            //   child: FloatingActionButton(
            //     backgroundColor: context.white,
            //     child: Icon(Icons.my_location, color: context.black),
            //     onPressed: () async {
            //       await mapCon.fetchCurrentLocation();
            //       await Future.delayed(Duration(seconds: 1));
            //       if (state.pickupLocation != null) {
            //         await mapCon.moveCamera(
            //           state.pickupLocation!.latitude,
            //           state.pickupLocation!.longitude,
            //           16,
            //         );
            //       }
            //     },
            //   ),
            // ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: context.popupBackground,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: context.black.withAlpha(40),
                    ),
                  ],
                ),
                child: _buildStepContent(currentStep),
              ),
            ),
            if (state.isMapProcessing || state.isLocationLoading)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.isLocationLoading
                            ? "Fetching your location..."
                            : "Calculating the best route...",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(RideStep step) {
    switch (step) {
      case RideStep.vehicleList:
        return VehicleListWidget();
      // case RideStep.confirmPickupLocation:
      //   return ConfirmPickupWidget();
      case RideStep.waitingForDriver:
        return WaitingForDriverWidget();

    }
  }

  Future<bool> _showExitConfirmationPopUp() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ConstPopUp(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          borderRadius: 12.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange.shade700,
                size: 40,
              ),
              const SizedBox(height: 15),
              ConstText(
                text: "Cancel Ride Request?",
                fontSize: 18,
                fontWeight: AppConstant.bold,
                color: context.textPrimary,
              ),
              const SizedBox(height: 10),
              ConstText(
                text: "Are you sure you want to cancel the ride while waiting for a driver?",
                fontSize: 14,
                textAlign: TextAlign.center,
                color: context.hintTextColor,
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NO Button
                  Expanded(
                    child: ConstTextBtn(
                      // Assuming you have a ConstButton widget
                      text: "NO, CONTINUE",
                      onTap: () =>
                          Navigator.of(context).pop(false), // Return false
                      textColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 15),
                  // YES Button
                  Expanded(
                    child: ConstTextBtn(
                      text: "YES, CANCEL",
                      onTap: () =>
                          Navigator.of(context).pop(true),
                      textColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    return result ?? false;
  }

}
