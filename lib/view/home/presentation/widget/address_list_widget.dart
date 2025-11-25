import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:rider_pay_user/main.dart';
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay_user/res/constant/common_network_img.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/res/constant/custom_slider_dialog.dart';
import 'package:rider_pay_user/utils/routes/routes_name.dart';
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/home/provider/provider.dart';
import 'package:rider_pay_user/view/map/presentation/controller/check_zone_notifer.dart';
import 'package:rider_pay_user/view/map/presentation/controller/state/map_state.dart';
import 'package:rider_pay_user/view/map/provider/map_provider.dart';
import 'package:rider_pay_user/view/share_pref/recent_place_provider.dart'
    show recentPlacesProvider;
import 'package:rider_pay_user/view/widget/location_on_popup.dart';
import 'package:rider_pay_user/view/widget/service_not_available_popup.dart';

class AddressListWidget extends ConsumerStatefulWidget {
  final bool isFromSearch;
  final TextEditingController? pickupController;
  final TextEditingController? destinationController;
  final LocationType? activeType;
  final FocusNode? pickupFocus;
  final FocusNode? destinationFocus;

  final VoidCallback? onSelected;


  const AddressListWidget({
    super.key,
    required this.isFromSearch,
    this.pickupController,
    this.destinationController,
    this.activeType,
    this.pickupFocus,
    this.destinationFocus,
    this.onSelected
  });

  @override
  ConsumerState<AddressListWidget> createState() => _AddressListWidgetState();
}

class _AddressListWidgetState extends ConsumerState<AddressListWidget> {
  @override
  Widget build(BuildContext context) {
    final recentPlaces = ref.watch(recentPlacesProvider);
    final locState = ref.watch(locationServiceProvider);
    final mapCon = ref.watch(mapControllerProvider);
    final checkZone = ref.watch(checkZoneProvider);
    // final checkZoneState = ref.read(checkZoneProvider.notifier);
    final mapNotifier = ref.watch(mapControllerProvider.notifier);

    return Container(
      decoration: BoxDecoration(color: context.greyLight),
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: recentPlaces.asMap().entries.map((entry) {
          final place = entry.value;
          final isFav = place["isFav"] ?? false;
          final type = place["type"];
          return ListTile(
            minTileHeight: 4,
            minVerticalPadding: 8,
            onTap: () async {
              if (mapCon.isMapProcessing || mapCon.isLocationLoading ||checkZone.isLoading) return;
              final double? lat = place["lat"];
              final double? lng = place["lng"];
              if (lat == null || lng == null) return;
              final destLatLng = LatLng(lat, lng);
              final address = "${place["title"]}, ${place["subtitle"]}";
              final mapNotifierLocal = ref.read(mapControllerProvider.notifier);
              // final checkZoneNotifier = ref.read(checkZoneProvider.notifier);
              // final locationNotifier = ref.read(locationServiceProvider.notifier);

              try {
                if (widget.isFromSearch) {
                  if (widget.activeType == LocationType.pickup) {
                    widget.pickupController?.text = address;
                    mapNotifier.updatePickup(destLatLng, address);
                    if (widget.destinationController?.text.isEmpty ??  true) {
                      FocusScope.of(context).requestFocus(widget.destinationFocus);

                    }

                  }

                  else {

                    widget.destinationController?.text = address;
                    mapNotifierLocal.updateDestination(destLatLng, address);
                    if (widget.pickupController?.text.isEmpty ?? true) {
                     await mapNotifierLocal.fetchCurrentLocation(type: LocationType.pickup,);
                      widget.pickupController?.text = mapCon.pickupAddress.toString();
                    }


                  }
                  widget.onSelected?.call();


                  // await Future.delayed(const Duration(milliseconds: 900));
                  // if (!mounted) return;
                  // await _handleZoneCheckAndNavigate();
                }






                else {
                  final addr = await mapNotifierLocal.fetchCurrentLocation(type: LocationType.pickup,);

                  await Future.delayed(const Duration(seconds: 1));

                  final readyPickup = mapCon.pickupLocation;

                  if (readyPickup == null || addr.isEmpty)  {
                    CustomSlideDialog.show(
                      context: context,
                      child: LocationOnPopup(
                        isBlocked: locState.isBlocked,
                        isServiceOff:
                        !locState.isGranted && !locState.isBlocked,
                        onAction: () async {
                          final granted = await ref.read(locationServiceProvider.notifier).ensurePermission();
                          if (granted) {
                            // Navigator.pop(context);
                            toastMsg("✅ Location enabled, please wait...");
                            final addr2 = await mapNotifier.fetchCurrentLocation(type: LocationType.pickup,);
                            if (addr2.isNotEmpty && mapCon.pickupLocation != null) {
                              mapNotifierLocal.updateDestination(destLatLng, address);
                              await Future.delayed(const Duration(milliseconds: 500));
                              await _handleZoneCheckAndNavigate();

                              // Navigator.pushNamedAndRemoveUntil(
                              //   context,
                              //   RouteName.mapScreen,
                              //       (routes) => false,
                              // );
                            } else {
                              toastMsg(
                                "⚠️ Could not get location, try again.",
                              );
                            }
                          }
                        },
                      ),
                    );
                    return;
                  }
                  mapNotifier.updateDestination(destLatLng, address);

                  await _handleZoneCheckAndNavigate();

                  // if (readyPickup != null) {
                  //   print("🚀 Navigating to MapScreen...");
                  //   Navigator.pushNamedAndRemoveUntil(
                  //     context,
                  //     RouteName.mapScreen,
                  //     (routes) => false,
                  //   );
                  // }
                }
              } catch (e) {
                debugPrint("❌ Error selecting address: $e");
              }
            },
            leading: isFav
                ? (place["icon"] != null
                      ? CommonNetworkImage(
                          imageUrl: place["icon"],
                          height: 18.h,
                          width: 18.w,
                          color: context.greyDark,
                        )
                      : Icon(_getIconForType(type), color: context.greyDark))
                : Icon(Icons.history, color: context.greyDark),
            title: ConstText(
              text: isFav ? type : place["title"] ?? "",
              fontSize: AppConstant.fontSizeOne,
              color: context.textPrimary,
            ),
            subtitle: ConstText(
              text: place["subtitle"] ?? "",
              color: context.textSecondary,
              maxLine: 1,
              fontSize: AppConstant.fontSizeZero,
            ),
            trailing: isFav
                ? Icon(Icons.favorite, color: context.primary)
                : GestureDetector(
                    onTap: () => _showFavouriteBottomSheet(ref, place),
                    child: Icon(Icons.favorite_border, color: context.greyDark),
                  ),
          );
        }).toList(),
      ),
    );
  }

  void _showFavouriteBottomSheet(WidgetRef ref, dynamic place) {
    final Map<String, dynamic> placeMap = Map<String, dynamic>.from(place);
    final state = ref.watch(addressTypeNotifierProvider);
    final addressTypes = state.types;
    final addressData = addressTypes?.data ?? [];
    String? selectedType;
    String? selectedIcon;

    showModalBottomSheet(
      context: ref.context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => CommonBottomSheet(
          title: "Add to favourites",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: screenWidth,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.greyLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ConstText(
                  text: "Select favourite type",
                  color: context.textPrimary,
                ),
              ),
              AppSizes.spaceH(10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: addressData.map((datum) {
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (datum.icon != null)
                          CommonNetworkImage(
                            imageUrl: datum.icon!,
                            height: 18,
                            width: 18,
                            color: context.greyMedium,
                          ),
                        SizedBox(width: 6),
                        ConstText(
                          text: datum.name ?? "",
                          fontSize: AppConstant.fontSizeOne,
                        ),
                      ],
                    ),
                    showCheckmark: false,
                    selected: selectedType == datum.name,
                    side: BorderSide(color: context.black),
                    selectedColor: context.primary,
                    backgroundColor: context.greyLight,
                    onSelected: (selected) {
                      setModalState(() {
                        selectedType = datum.name;
                        selectedIcon = datum.icon;
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              AppBtn(
                title: "Add to favourite",
                titleColor: selectedType == null
                    ? context.black
                    : context.white,
                onTap: selectedType == null
                    ? null
                    : () {
                        ref
                            .read(recentPlacesProvider.notifier)
                            .markFavourite(
                              selectedType!,
                              placeMap,
                              icon: selectedIcon,
                            );
                        Navigator.pop(context);
                      },
                color: selectedType == null
                    ? context.hintTextColor
                    : context.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String? type) {
    switch (type) {
      case "Home":
        return Icons.home;
      case "Work":
        return Icons.work;
      case "Gym":
        return Icons.fitness_center;
      default:
        return Icons.place;
    }
  }

  Future<void> _handleZoneCheckAndNavigate() async {
    final mapCon = ref.read(mapControllerProvider);
    final checkZone = ref.read(checkZoneProvider.notifier);
    print("🗺 pickup: ${mapCon.pickupLocation}");
    print("🗺 destination: ${mapCon.destinationLocation}");
    if (mapCon.pickupLocation == null || mapCon.destinationLocation == null) {
      toastMsg("Please select both pickup and drop locations");
      return;
    }
    print("🚀 Checking zone...");

    final isInZone = await checkZone.checkZone(
      pickLat: mapCon.pickupLocation!.latitude.toString(),
      pickLng: mapCon.pickupLocation!.longitude.toString(),
      destLat: mapCon.destinationLocation!.latitude.toString(),
      destLng: mapCon.destinationLocation!.longitude.toString(),
    );
    print("✅ Zone API response: $isInZone");
    if (isInZone) {
      Navigator.pushNamedAndRemoveUntil(context, RouteName.mapScreen,(routes)=>false);
    } else {
      CustomSlideDialog.show(
        context: context,
        child: ZoneRejectPopup(
          onClose: () {
            Navigator.pop(context);
          },
        ),
      );
    }
  }
}
