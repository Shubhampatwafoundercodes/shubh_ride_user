import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay/res/app_border.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/theme/theme_controller.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/view/map/presentation/widget/confirm_pickup_location_widget.dart';
import 'package:rider_pay/view/map/presentation/widget/vehicle_list_widget.dart';
import 'package:rider_pay/view/map/presentation/widget/waiting_for_driver_widget.dart';
import 'package:rider_pay/view/map/provider/map_provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_){
      final mapN=ref.read(mapControllerProvider.notifier);
      final mapState=ref.read(mapControllerProvider);
      if(mapState.pickupLocation !=null && mapState.destinationLocation !=null){
        final pickup=LatLng(mapState.pickupLocation?.latitude??0, mapState.pickupLocation?.longitude??0);
        final destination=LatLng(mapState.destinationLocation?.latitude??0, mapState.destinationLocation?.longitude??0);
        mapN.drawRoute(pickup, destination);
      }

    }
    );
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapControllerProvider);
    final mapCon = ref.watch(mapControllerProvider.notifier);
    final rideState = ref.watch(rideFlowProvider);
    final currentStep = rideState.currentStep;
    return WillPopScope(
      onWillPop: () async {
        final controller = ref.read(rideFlowProvider.notifier);
        if (rideState.currentStep == RideStep.confirmPickupLocation) {
          await mapCon.cancelPickupConfirmation();
          controller.back();
          return false;
        }

        if (rideState.steps.length > 1) {
          if (currentStep == RideStep.waitingForDriver || currentStep == RideStep.rideInProgress) {
            return false;
          }
          controller.back();
          return false;
        }else{
          final mapNot= ref.read(mapNotifierProvider.notifier);
          mapNot.resetPlaceDetails();
          mapNot.resetSearchPlacesData();
          mapCon.clearTemporaryState();

        }

        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteName.home,
              (route) => false,
        );
        return false;      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              key: ValueKey(state.mapStyle),
              initialCameraPosition: CameraPosition(
                target: state.pickupLocation ?? _defaultLocation,
                zoom: 14,
              ),
              markers: state.markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
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
                  await mapCtrl.moveCamera(state.pickupLocation?.latitude??0, state.pickupLocation?.longitude??0, 14);
                });
              },
              onCameraMove: (pos) {
                // mapCon.
                if (state.isConfirmingPickup) {
                  mapCon.updateDraggableLatLng(pos.target);
                }
              },
              onCameraIdle: () async {
                if (state.isConfirmingPickup) {
                  if (state.draggablePickupLocation != null) {
                    final center = state.destinationLocation!;
                    await mapCon.updateDraggableLocationAddressPolyline(center);
                  }
                }
              },
            ),
            if (state.isConfirmingPickup)
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.25),
                  child: Icon(Icons.location_pin, size: 40, color: Colors.red),
                ),
              ),
          ],
        ),
        bottomSheet: Container(
          decoration: BoxDecoration(
            color: context.popupBackground,
            borderRadius: AppBorders.smallRadius,
            boxShadow: [
              BoxShadow(blurRadius: 10, color: context.black.withAlpha(40))
            ],
          ),
          child: _buildStepContent(currentStep),
        ),
      ),
    );
  }
  Widget _buildStepContent(RideStep step) {
    switch (step) {
      case RideStep.vehicleList:
        return VehicleListWidget();

      case RideStep.confirmPickupLocation:
        return ConfirmPickupWidget();
      case RideStep.waitingForDriver:
        return WaitingForDriverWidget();

      case RideStep.rideInProgress:
        return  Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text("🚘 Ride in Progress...")),
          ],
        );
    }
  }
}



