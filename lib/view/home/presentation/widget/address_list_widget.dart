import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:rider_pay/main.dart';
import 'package:rider_pay/res/app_btn.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay/res/constant/common_network_img.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/res/constant/custom_slider_dialog.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/utils/utils.dart';
import 'package:rider_pay/view/home/data/model/address_type_model.dart';
import 'package:rider_pay/view/home/provider/provider.dart';
import 'package:rider_pay/view/map/presentation/controller/map_controller.dart';
import 'package:rider_pay/view/map/provider/map_provider.dart';
import 'package:rider_pay/view/share_pref/recent_place_provider.dart'
    show recentPlacesProvider;
import 'package:rider_pay/view/widget/location_on_popup.dart';

class AddressListWidget extends ConsumerWidget {
  final bool isFromSearch;
  final TextEditingController? pickupController;
  final TextEditingController? destinationController;
  final LocationType? activeType;
  final FocusNode? pickupFocus;
  final FocusNode? destinationFocus;
  const AddressListWidget({
    super.key,
    required this.isFromSearch,
    this.pickupController,
    this.destinationController,
    this.activeType,
    this.pickupFocus,
    this.destinationFocus,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentPlaces = ref.watch(recentPlacesProvider);
    final locState = ref.watch(locationServiceProvider);

    return Container(
      decoration: BoxDecoration(color: context.greyLight),
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: recentPlaces.asMap().entries.map((entry) {
          final index = entry.key;
          final place = entry.value;
          final isFav = place["isFav"] ?? false;
          final type = place["type"];
          return ListTile(
            minTileHeight: 4,
            minVerticalPadding: 8,
            onTap: () async {
              final mapState = ref.read(mapControllerProvider);
              if (mapState.isMapProcessing || mapState.isLocationLoading) {
                debugPrint("Tap ignored: already processing...");
                return;
              }

              try {
                final lat = place["lat"];
                final lng = place["lng"];
                final destLatLng = LatLng(lat, lng);
                final address = "${place["title"]}, ${place["subtitle"]}";

                if (isFromSearch) {
                  if (activeType == LocationType.pickup) {
                    pickupController?.text = address;

                    if (destinationController?.text.isEmpty ?? true) {
                      FocusScope.of(context).requestFocus(destinationFocus);

                      final addr = await ref
                          .read(mapControllerProvider.notifier)
                          .fetchCurrentLocation(type: LocationType.destination);
                      destinationController?.text = addr;
                    }
                  } else {
                    destinationController?.text = address;

                    if (pickupController?.text.isEmpty ?? true) {
                      FocusScope.of(context).requestFocus(pickupFocus);

                      final addr = await ref
                          .read(mapControllerProvider.notifier)
                          .fetchCurrentLocation(type: LocationType.pickup);
                      pickupController?.text = addr;
                    }
                  }

                  final isNav = await ref
                      .read(mapControllerProvider.notifier)
                      .selectLocationAndUpdateMap(
                        type: activeType ?? LocationType.destination,
                        latLng: destLatLng,
                        address: address,
                      );
                  if (isNav) {
                    Navigator.pushReplacementNamed(context, RouteName.mapScreen);
                  }
                } else {
                  final pickupAddress = await ref
                      .read(mapControllerProvider.notifier)
                      .fetchCurrentLocation(type: LocationType.pickup);

                  if (pickupAddress.isEmpty) {
                    // Agar empty mila → iska matlab service off ya permission deny
                    CustomSlideDialog.show(
                      context: context,
                      child: LocationOnPopup(
                        isBlocked: locState.isBlocked,
                        isServiceOff:
                            !locState.isGranted && !locState.isBlocked,
                        onAction: () async {
                          final granted = await ref
                              .read(locationServiceProvider.notifier)
                              .ensurePermission();
                          if (granted) {
                            Navigator.pop(context);
                            toastMsg("Location enabled, tap again to continue");
                          }
                        },
                      ),
                    );
                    return;
                  }

                  final isNavigation = await ref
                      .read(mapControllerProvider.notifier)
                      .selectLocationAndUpdateMap(
                        type: LocationType.destination,
                        latLng: destLatLng,
                        address: "${place["title"]}, ${place["subtitle"]}",
                      );

                  if (isNavigation) {
                    Navigator.pushReplacementNamed(context, RouteName.mapScreen);
                  }
                }
              } catch (e) {
                debugPrint("Error selecting location: $e");
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
}
