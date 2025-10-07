import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/res/app_border.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/app_text_field.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/view/home/presentation/home_screen.dart';
import 'package:rider_pay/view/home/presentation/widget/address_list_widget.dart';
import 'package:rider_pay/view/home/presentation/widget/common_btn_with_title.dart';
import 'package:rider_pay/view/map/presentation/controller/map_controller.dart';
import 'package:rider_pay/view/map/provider/map_provider.dart';
import 'package:rider_pay/view/share_pref/recent_place_provider.dart' show recentPlacesProvider;

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
    final mapState = ref.watch(mapNotifierProvider);
    final mapCon = ref.watch(mapControllerProvider);
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
                        text: "Drop",
                        padding: EdgeInsets.zero,
                      ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 12.w,
                      //     vertical: 6.h,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: context.greyLight,
                      //     borderRadius: AppBorders.largeRadius,
                      //     border: Border.all(color: context.black, width: 1),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       ConstText(
                      //         text: "For me",
                      //         fontSize: AppConstant.fontSizeOne,
                      //         fontWeight: AppConstant.medium,
                      //       ),
                      //       AppSizes.spaceW(4),
                      //       const Icon(Icons.keyboard_arrow_down, size: 20),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),

                ///  Content
                _buildLocationFields(),
                AppSizes.spaceH(10),
                Row(children: [
                  AppSizes.spaceW(15),
                  _actionButton(icon: Icons.add, text: "Current Location",
                      onTap: () async {
                        final type = activeType ?? LocationType.pickup;
                        final notifier = ref.read(mapControllerProvider.notifier);

                        final address = await notifier.fetchCurrentLocation(type: type);

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

                        if (pickupController.text.isNotEmpty &&
                            destinationController.text.isNotEmpty &&
                            mapCon.pickupLocation != null &&
                            mapCon.destinationLocation != null) {
                          Navigator.pushReplacementNamed(context, RouteName.mapScreen);

                          // Optionally clear controllers
                          pickupController.clear();
                          destinationController.clear();
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
                          widthFactor: mapState.isLoadingDetails || mapCon.isMapProcessing
                              ? null
                              : 0,
                          child: LinearProgressIndicator(
                            minHeight: 5,
                            backgroundColor: Colors.transparent,
                            color: Colors.blue,
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
                              print("$place places ");
                              return GestureDetector(
                                // onTap: () async {
                                //   if (activeType == null) return;
                                //   final placeId = place.placeId;
                                //   final selectedAddress = "${place.structuredFormatting?.mainText ?? ""}, ""${place.structuredFormatting?.secondaryText ?? ""}";
                                //   if (activeType == LocationType.pickup) {
                                //     pickupController.text = selectedAddress;
                                //   } else {
                                //     destinationController.text = selectedAddress;
                                //   }
                                //   ref.read(mapNotifierProvider.notifier).resetSearchPlacesData();
                                //
                                //   final latLng = await ref
                                //       .read(mapNotifierProvider.notifier)
                                //       .placeDetails(
                                //         placeId: placeId!,
                                //         type: activeType,
                                //       );
                                //   if (latLng != null) {
                                //     //
                                //     // ref.read(userProvider.notifier).saveRecentPlace(
                                //     //   place.structuredFormatting?.mainText ?? "",
                                //     //   place.structuredFormatting?.secondaryText ?? "",
                                //     //   latLng.latitude,
                                //     //   latLng.longitude,
                                //     // );
                                //     ref.read(recentPlacesProvider.notifier).addRecent({
                                //       "title": place.structuredFormatting?.mainText ?? "",
                                //       "subtitle": place.structuredFormatting?.secondaryText ?? "",
                                //       "lat": latLng.latitude,
                                //       "lng": latLng.longitude,
                                //     });
                                //     await ref
                                //         .read(mapControllerProvider.notifier)
                                //         .selectLocationAndUpdateMap(
                                //           type: activeType!,
                                //           latLng: latLng,
                                //           address: selectedAddress,
                                //         );
                                //   }
                                // },
                                onTap: () async {
                                  if (activeType == null) return;

                                  final placeId = place.placeId!;
                                  final selectedAddress = "${place.structuredFormatting?.mainText ?? ""}, ${place.structuredFormatting?.secondaryText ?? ""}";

                                  if (activeType == LocationType.pickup) {
                                    pickupController.text = selectedAddress;
                                    if (destinationController.text.isEmpty) {
                                      // FocusScope.of(context).requestFocus(destinationFocus);
                                      activeType = LocationType.destination;
                                      final addr = await ref.read(mapControllerProvider.notifier).fetchCurrentLocation(type: LocationType.destination);
                                      destinationController.text = addr;
                                    }
                                  } else {
                                    destinationController.text = selectedAddress;
                                    if (pickupController.text.isEmpty) {
                                      // FocusScope.of(context).requestFocus(pickupFocus);
                                      activeType = LocationType.pickup;
                                      final addr = await ref.read(mapControllerProvider.notifier)
                                          .fetchCurrentLocation(type: LocationType.pickup);
                                      pickupController.text = addr;
                                    }
                                  }

                                  ref.read(mapNotifierProvider.notifier).resetSearchPlacesData();

                                  final latLng = await ref.read(mapNotifierProvider.notifier).placeDetails(
                                    placeId: placeId,
                                    type: activeType,
                                  );

                                  if (latLng != null) {
                                 final isNavigate=   await ref.read(mapControllerProvider.notifier).selectLocationAndUpdateMap(
                                      type: activeType!,
                                      latLng: latLng,
                                      address: selectedAddress,
                                    );
                                 if (!mounted) return;
                                 if(isNavigate){
                                   Navigator.pushReplacementNamed(context, RouteName.mapScreen);

                                     }
                                    // final st = ref.read(mapControllerProvider);
                                    // if (st.pickupLocation != null && st.destinationLocation != null && (pickupController.text == MapController.currentLocationText ||
                                    //         destinationController.text == MapController.currentLocationText))
                                    // {
                                    //   Navigator.pushNamed(context, RouteName.mapScreen);
                                    // }
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
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (mapCon.isMapProcessing) const FullScreenLoader(),

      ],
    );
  }

  /// 🔹 Current + Drop fields
  Widget _buildLocationFields() {
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

                  hintText: "Enter",
                  // readOnly: true,
                  onTap: (){
                    activeType = LocationType.pickup;
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

                  hintText: "Drop location",
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

}
