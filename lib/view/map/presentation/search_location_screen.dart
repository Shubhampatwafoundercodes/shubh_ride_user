import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/res/app_border.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/app_text_field.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/res/constant/custom_slider_dialog.dart';
import 'package:rider_pay_user/utils/routes/routes_name.dart';
import 'package:rider_pay_user/utils/utils.dart';
// ignore: unused_import
import 'package:rider_pay_user/view/home/presentation/home_screen.dart';
import 'package:rider_pay_user/view/home/presentation/widget/address_list_widget.dart';
import 'package:rider_pay_user/view/home/presentation/widget/common_btn_with_title.dart';
import 'package:rider_pay_user/view/map/presentation/controller/check_zone_notifer.dart';
import 'package:rider_pay_user/view/map/presentation/controller/map_controller.dart';
import 'package:rider_pay_user/view/map/presentation/controller/state/map_state.dart';
import 'package:rider_pay_user/view/map/provider/map_provider.dart';
import 'package:rider_pay_user/view/share_pref/recent_place_provider.dart';
import 'package:rider_pay_user/view/widget/service_not_available_popup.dart';

class SearchLocationScreen extends ConsumerStatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  ConsumerState<SearchLocationScreen> createState() => _DropScreenState();
}

class _DropScreenState extends ConsumerState<SearchLocationScreen> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final FocusNode pickupFocus = FocusNode();
  final FocusNode destinationFocus = FocusNode();

  LocationType? activeType;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      if (!mounted) return;
      final mapL=  ref.read(mapControllerProvider.notifier);
     final pickupAddress=  await mapL.fetchCurrentLocation(type: LocationType.pickup);
     if(pickupAddress.isNotEmpty){
       pickupController.text = MapController.currentLocationText;
       if (destinationController.text.isEmpty) {
         Future.microtask(() => FocusScope.of(context).requestFocus(destinationFocus));
         activeType = LocationType.destination;
       }
     }


    });
  }

  @override
  void dispose() {
    pickupController.dispose();
    destinationController.dispose();
    pickupFocus.dispose();
    destinationFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t=AppLocalizations.of(context)!;
    final mapState = ref.watch(mapNotifierProvider);
    final mapNotifier = ref.read(mapNotifierProvider.notifier);
    final mapCon = ref.watch(mapControllerProvider);
    final notifier = ref.read(mapControllerProvider.notifier);

    final result = mapState.mapAddressData?.predictions ?? [];

    return Stack(
      children: [
        Scaffold(
          backgroundColor: context.background,
          body: SafeArea(
            child: Column(
              children: [
                ///  Header
                Padding(
                  padding: AppPadding.screenPadding.copyWith(
                    top: 12.h,
                    bottom: 12.h,
                  ),
                 child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonBackBtnWithTitle(
                        text: t.drop,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),

                ///  Content
                _buildLocationFields(t),
                AppSizes.spaceH(10),
                Row(children: [
                  AppSizes.spaceW(15),
                  _actionButton(icon: Icons.add, text: t.currentLocation,
                      onTap: () async {
                        final type = activeType ?? LocationType.pickup;
                        final address = await notifier.fetchCurrentLocation(type: type);
                        if (address.isEmpty) return;

                        if (type == LocationType.pickup) {
                          if (destinationController.text == MapController.currentLocationText) {
                            destinationController.clear();
                            notifier.clearDestination();
                          }
                          if (destinationController.text.isEmpty) {
                            // FocusScope.of(context).requestFocus(destinationFocus);
                            activeType = LocationType.destination;
                          }
                          pickupController.text = address;
                        } else {
                          if (pickupController.text == MapController.currentLocationText) {
                            pickupController.clear();
                            notifier.clearPickup();
                          }
                             destinationController.text = address;
                          if (pickupController.text.isEmpty) {
                            // FocusScope.of(context).requestFocus(pickupFocus);
                            activeType = LocationType.pickup;
                          }
                        }
                        if (pickupController.text.isNotEmpty && destinationController.text.isNotEmpty && mapCon.pickupLocation != null && mapCon.destinationLocation != null) {
                          final suc=  await _handleZoneCheckAndNavigate(ref);
                          if(suc){
                            pickupController.clear();
                            destinationController.clear();
                          }

                        }
                      }
                  ),
                ],),


                AppSizes.spaceH(10),
                Stack(
                  children: [
                    Container(
                      height: 1.5,
                      color: AppColor.grey,
                    ),

                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: ref.watch(checkZoneProvider).isLoading||
                              mapState.isLoadingDetails || mapCon.isMapProcessing|| mapCon.isLocationLoading
                              ? null
                              : 0,
                          child: LinearProgressIndicator(
                            minHeight: 8,
                            backgroundColor:context.primary,
                            color: Colors.blue,
                            borderRadius:BorderRadius.circular(08),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                AppSizes.spaceH(10),
                Expanded(
                  child: SingleChildScrollView(
                    // padding: AppPadding.screenPaddingH,
                    child: Column(
                      children: [
                        /// Saved Places
                        if (mapState.isLoadingSearch)
                          Center(child: CircularProgressIndicator())
                        else if (result.isNotEmpty)
                          ListView.separated(
                            shrinkWrap: true,
                            itemCount: result.length,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, __) => Divider(
                              height: 25,
                              color: AppColor.grey,
                              thickness: 0.5,
                            ),
                            itemBuilder: (context, index) {
                              final place = result[index];
                              return GestureDetector(
                                onTap: () async {
                                  if (activeType == null) {
                                    toastMsg("⚠️ Active type null hai!");
                                    return;
                                  }                                  // final localContext = context;
                                  final placeId = place.placeId!;
                                     final selectedAddress = "${place.structuredFormatting?.mainText ?? ""}, ${place.structuredFormatting?.secondaryText ?? ""}";
                                      final placeData = {
                                    "title": place.structuredFormatting?.mainText ?? "",
                                    "subtitle": place.structuredFormatting?.secondaryText ?? "",
                                    "placeId": placeId,
                                    "mainText": place.structuredFormatting?.mainText,
                                    "secondaryText": place.structuredFormatting?.secondaryText,
                                  };

                                  //
                                  // toastMsg("📍 Fetching place details...");
                                  // print("🔹 Step 1: Fetching details for $placeId");


                                      final latLng = await mapNotifier.placeDetails(placeId: placeId, type: activeType,);

                                  if (latLng == null) {
                                    return;
                                  }

                                  mapNotifier.resetSearchPlacesData();



                                  if (activeType == LocationType.pickup) {
                                      pickupController.text = selectedAddress;
                                      notifier.updatePickup(latLng, selectedAddress);

                                      destinationController.clear();
                                      notifier.clearDestination();
                                      activeType = LocationType.destination;

                                  } else {
                                      destinationController.text = selectedAddress;
                                      notifier.updateDestination(latLng, selectedAddress);

                                      if (pickupController.text.isEmpty) {
                                        activeType = LocationType.pickup;
                                      }
                                    }

                                      await Future.delayed(Duration(milliseconds:300));
                                      print("pickupReady && dropReady${mapCon.pickupLocation } D${mapCon.destinationLocation}");
                                  if (pickupController.text.isNotEmpty && destinationController.text.isNotEmpty) {
                                    // toastMsg("🚀 Both locations ready, checking zone...");

                                    final suc=  await _handleZoneCheckAndNavigate(ref);
                                  if(suc){
                                    _savePlaceToRecent(placeData, latLng);

                                  }


                                  }
                                }
,
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined,color: AppColor.greyDark,),
                                    AppSizes.spaceW(12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          ConstText(
                                            text:
                                                place.structuredFormatting?.mainText
                                                    .toString() ??
                                                place.description.toString(),
                                            fontSize: AppConstant.fontSizeOne,
                                            // fontWeight: AppConstant.medium,
                                            // color: context.textPrimary,
                                          ),
                                          AppSizes.spaceH(2),
                                          ConstText(
                                            text:
                                                place.structuredFormatting?.secondaryText ??
                                                "",
                                            fontSize: AppConstant.fontSizeZero,
                                            color: context.textSecondary,
                                            maxLine: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        else
                          AddressListWidget(
                            isFromSearch: true,
                            pickupController: pickupController,
                            destinationController: destinationController,
                            activeType: activeType,
                            pickupFocus: pickupFocus,
                            destinationFocus: destinationFocus,
                            onSelected: () async {

                              if (mapCon.pickupLocation == null || mapCon.destinationLocation == null) {
                                toastMsg("Please select both pickup and drop locations");
                                return;
                              }
                              print("🚀 Checking zone...");
                              final checkZone = ref.read(checkZoneProvider.notifier);

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
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // if (mapCon.isMapProcessing) const FullScreenLoader(),

      ],
    );
  }

  /// 🔹 Current + Drop fields
  Widget _buildLocationFields(AppLocalizations t) {
    return Container(
      padding:EdgeInsets.symmetric(horizontal:15.w,vertical: 8.h),
      margin: AppPadding.screenPaddingH,
      decoration: BoxDecoration(
        color: context.greyLight,
        border: Border.all(color: context.greyMedium, width: 1),
        borderRadius: AppBorders.mediumRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          /// Left side indicators
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(radius: 6, backgroundColor: Colors.green),
              ...List.generate(
                4,
                (index) => Container(
                  height: 5.h,
                  width: 1.5.w,
                  color: AppColor.grey,
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
              const CircleAvatar(radius: 6, backgroundColor: Colors.deepOrange),
            ],
          ),
          AppSizes.spaceW(15),
          Expanded(
            child: Column(
              children: [
                AppTextField(
                  height: 30,
                  margin: EdgeInsets.zero,
                  focusBorderSide: BorderSide.none,
                  borderSide: BorderSide.none,
                  fieldRadius: AppBorders.btnRadius,
                  controller: pickupController,
                  contentPadding: EdgeInsets.zero,
                  autofocus: activeType == LocationType.pickup,

                  hintText: t.enter,
                  // readOnly: true,
                  onTap: (){
                    activeType = LocationType.pickup;
                    if (destinationController.text == MapController.currentLocationText) {
                      destinationController.clear();
                      ref.read(mapControllerProvider.notifier).clearDestination();
                    }
                  },
                  onChanged: (value) {

                    if (value.isEmpty) {
                      ref.read(mapControllerProvider.notifier).clearPickup();
                      return;
                    }

                    if (value.length >= 4) {
                      ref
                          .read(mapNotifierProvider.notifier)
                          .searchPlaces(value);
                    } else {
                      ref
                          .read(mapNotifierProvider.notifier)
                          .resetSearchPlacesData();
                    }
                  },
                ),
                Divider(thickness: 0.5,color: context.hintTextColor,),
                // AppSizes.spaceH(12),
                AppTextField(
                  height: 30,
                  margin: EdgeInsets.zero,
                  focusBorderSide: BorderSide.none,
                  borderSide: BorderSide.none,
                  fieldRadius: AppBorders.btnRadius,
                  contentPadding: EdgeInsets.zero,
                 controller:destinationController ,
                  autofocus: activeType == LocationType.destination,

                  hintText:t.dropLocation,
                  onTap: (){
                    activeType = LocationType.destination;
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      ref.read(mapControllerProvider.notifier).clearDestination();
                      return;
                    }
                    if (value.length >= 4) {
                      ref
                          .read(mapNotifierProvider.notifier)
                          .searchPlaces(value);
                    } else {
                      print("cvbvbbbbbbbb");
                      ref
                          .read(mapNotifierProvider.notifier)
                          .resetSearchPlacesData();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _handleZoneCheckAndNavigate(WidgetRef ref) async {
    final mapCon = ref.read(mapControllerProvider);
    if (mapCon.pickupLocation == null || mapCon.destinationLocation == null) {
      toastMsg("Please select both pickup and drop locations");
      return false;
    }
    final isInZone = await ref.read(checkZoneProvider.notifier).checkZone(
      pickLat: mapCon.pickupLocation!.latitude.toString(),
      pickLng: mapCon.pickupLocation!.longitude.toString(),
      destLat: mapCon.destinationLocation!.latitude.toString(),
      destLng: mapCon.destinationLocation!.longitude.toString(),
    );

    if (isInZone) {
      Navigator.pushNamedAndRemoveUntil(context, RouteName.mapScreen,(routes)=>false);
      return true;
    } else {
      CustomSlideDialog.show(
        // dismissible: false,
        context: context,
        child: ZoneRejectPopup(
          onClose: () {
            Navigator.pop(context);
          },
        ),
      );
      return false;

    }
  }

  void navigateToMapScreen() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, RouteName.mapScreen);
  }

Widget _actionButton({
  required IconData icon,
  required String text,
  void Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: context.greyLight,
        borderRadius: AppBorders.largeRadius,

        border: Border.all(color: context.black, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18.sp),
          AppSizes.spaceW(4),
          ConstText(
            text: text,
            fontSize: AppConstant.fontSizeZero,
            fontWeight: AppConstant.medium,
          ),
        ],
      ),
    ),
  );
}


  void _savePlaceToRecent(Map<String, dynamic> placeData, LatLng? latLng) {
    if (latLng == null) return;
    ref.read(recentPlacesProvider.notifier).addRecent({
      "title": placeData["title"] ?? placeData["mainText"] ?? "",
      "subtitle": placeData["subtitle"] ?? placeData["secondaryText"] ?? "",
      "placeId": placeData["placeId"],
      "mainText": placeData["mainText"],
      "secondaryText": placeData["secondaryText"],
      "lat": latLng.latitude,
      "lng": latLng.longitude,
    });
  }
}
